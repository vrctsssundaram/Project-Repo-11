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

**Evidence:** Tool-reported Icarus Verilog regression and Yosys synthesis results for the source revision cited above.
