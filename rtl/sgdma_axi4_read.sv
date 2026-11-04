module sgdma_axi4_read (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        desc_valid,
    output wire        desc_ready,
    input  wire [31:0] desc_addr,
    input  wire [7:0]  desc_words,
    input  wire        desc_eop,
    output wire [31:0] m_axi_araddr,
    output wire [7:0]  m_axi_arlen,
    output wire [2:0]  m_axi_arsize,
    output wire [1:0]  m_axi_arburst,
    output wire        m_axi_arvalid,
    input  wire        m_axi_arready,
    input  wire [31:0] m_axi_rdata,
    input  wire [1:0]  m_axi_rresp,
    input  wire        m_axi_rlast,
    input  wire        m_axi_rvalid,
    output wire        m_axi_rready,
    output reg  [31:0] m_axis_tdata,
    output reg         m_axis_tlast,
    output wire        m_axis_tvalid,
    input  wire        m_axis_tready,
    output reg         desc_done,
    output reg  [31:0] desc_completed,
    output reg  [31:0] error_count
);
    localparam [1:0] IDLE=2'd0, ISSUE=2'd1, RECEIVE=2'd2, OUTPUT=2'd3;
    reg [1:0] state;
    reg [31:0] address;
    reg [7:0] remaining;
    reg end_packet;

    wire [32:0] end_address = {1'b0,desc_addr} + ({25'd0,desc_words} << 2);
    wire invalid_desc = (desc_words == 0) || (desc_addr[1:0] != 0) ||
                        (end_address > 33'h100000000);

    assign desc_ready = (state == IDLE);
    assign m_axi_araddr = address;
    assign m_axi_arlen = 8'd0;
    assign m_axi_arsize = 3'd2;
    assign m_axi_arburst = 2'b01;
    assign m_axi_arvalid = (state == ISSUE);
    assign m_axi_rready = (state == RECEIVE);
    assign m_axis_tvalid = (state == OUTPUT);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            address <= 0;
            remaining <= 0;
            end_packet <= 0;
            m_axis_tdata <= 0;
            m_axis_tlast <= 0;
            desc_done <= 0;
            desc_completed <= 0;
            error_count <= 0;
        end else begin
            desc_done <= 0;
            case (state)
                IDLE: if (desc_valid) begin
                    if (invalid_desc) begin
                        error_count <= error_count + 1'b1;
                        desc_done <= 1;
                    end else begin
                        address <= desc_addr;
                        remaining <= desc_words;
                        end_packet <= desc_eop;
                        state <= ISSUE;
                    end
                end
                ISSUE: if (m_axi_arready) state <= RECEIVE;
                RECEIVE: if (m_axi_rvalid) begin
                    if (m_axi_rresp != 2'b00 || !m_axi_rlast) begin
                        error_count <= error_count + 1'b1;
                        desc_done <= 1;
                        state <= IDLE;
                    end else begin
                        m_axis_tdata <= m_axi_rdata;
                        m_axis_tlast <= (remaining == 1) && end_packet;
                        state <= OUTPUT;
                    end
                end
                OUTPUT: if (m_axis_tready) begin
                    if (remaining == 1) begin
                        desc_completed <= desc_completed + 1'b1;
                        desc_done <= 1;
                        state <= IDLE;
                    end else begin
                        remaining <= remaining - 1'b1;
                        address <= address + 32'd4;
                        state <= ISSUE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
