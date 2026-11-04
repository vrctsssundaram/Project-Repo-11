# Verification record

Date: 05 November 2026
Source revision tested: `5527357d89a746f025c8b2b0569481bf006e254a`
Hosted verification: https://github.com/vrctsssundaram/Project-Repo-11/actions/runs/41900970603

| Measurement | Recorded result |
|---|---|
| SystemVerilog compilation | **PASS** (Icarus Verilog, `-g2012 -Wall`) |
| Directed self-checking simulation | **PASS** (exit code 0) |
| Directed checks | valid two-word and one-word descriptors, chained packet boundary, stream backpressure, misaligned descriptor rejection, AXI RRESP failure |
| Generic Yosys synthesis | **PASS**; 662 technology-independent cells |
| FPGA/ASIC technology-specific utilization | Not measured |
| Static timing, maximum clock, power | Not measured |
| Physical hardware throughput | Not measured |

The synthesis count is taken from the top-level `stat` section of the hosted generic Yosys run, not a device-mapped area estimate. The directed testbench is bounded and does not constitute exhaustive or formal verification. No artificial waveform, timing, area, or power result is presented as a measurement.
