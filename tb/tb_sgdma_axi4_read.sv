module tb_sgdma_axi4_read;
    reg clk=0; always #5 clk=~clk;
    reg rst_n=0,desc_valid=0,desc_eop=0,m_axi_arready=1,m_axi_rlast=1,m_axi_rvalid=0,m_axis_tready=0;
    reg [31:0] desc_addr=0,m_axi_rdata=0;
    reg [7:0] desc_words=0;
    reg [1:0] m_axi_rresp=0;
    wire desc_ready,m_axi_arvalid,m_axi_rready,m_axis_tvalid,m_axis_tlast,desc_done;
    wire [31:0] m_axi_araddr,m_axis_tdata,desc_completed,error_count;
    wire [7:0] m_axi_arlen;
    wire [2:0] m_axi_arsize;
    wire [1:0] m_axi_arburst;
    integer received=0;
    sgdma_axi4_read dut(.*);

    always @(posedge clk) begin
        if (!rst_n) begin m_axi_rvalid <= 0; m_axi_rresp <= 0; end
        else begin
            if (m_axi_arvalid && m_axi_arready) begin
                if (m_axi_arlen!==0 || m_axi_arsize!==3'd2 || m_axi_arburst!==2'b01)
                    $fatal(1,"Incorrect AXI4 read control");
                m_axi_rdata <= m_axi_araddr ^ 32'ha5a50000;
                m_axi_rresp <= (m_axi_araddr == 32'h3000) ? 2'b10 : 2'b00;
                m_axi_rvalid <= 1;
            end else if (m_axi_rvalid && m_axi_rready) m_axi_rvalid <= 0;
            if (m_axis_tvalid && m_axis_tready) begin
                case (received)
                    0: if(m_axis_tdata!==32'ha5a51000 || m_axis_tlast) $fatal(1,"First output");
                    1: if(m_axis_tdata!==32'ha5a51004 || m_axis_tlast) $fatal(1,"Second output");
                    2: if(m_axis_tdata!==32'ha5a52000 || !m_axis_tlast) $fatal(1,"Third output");
                    default: $fatal(1,"Unexpected output");
                endcase
                received = received + 1;
            end
        end
    end
    task send_desc(input [31:0] addr,input [7:0] words,input eop);
        begin
            @(negedge clk);
            while(!desc_ready) @(negedge clk);
            desc_addr=addr;desc_words=words;desc_eop=eop;desc_valid=1;
            @(negedge clk);desc_valid=0;
        end
    endtask
    initial begin
        repeat(4) @(negedge clk);rst_n=1;
        send_desc(32'h1000,2,0);
        wait(m_axis_tvalid);
        repeat(3) begin
            @(negedge clk);
            if(m_axis_tdata!==32'ha5a51000 || !m_axis_tvalid || m_axis_tlast)
                $fatal(1,"Backpressure stability");
        end
        m_axis_tready=1;
        wait(desc_completed==1);
        send_desc(32'h2000,1,1);
        wait(desc_completed==2);
        send_desc(32'h1001,2,0);
        repeat(3) @(negedge clk);
        if(error_count!==1) $fatal(1,"Alignment rejection");
        send_desc(32'h3000,1,1);
        repeat(8) @(negedge clk);
        if(error_count!==2 || desc_completed!==2 || received!==3)
            $fatal(1,"Counters mismatch completed=%d error=%d received=%d",desc_completed,error_count,received);
        $display("PASS: descriptor sequence, AXI4 read, stable backpressure, alignment and RRESP errors");
        $finish;
    end
    initial begin #100000;$fatal(1,"Watchdog");end
endmodule
