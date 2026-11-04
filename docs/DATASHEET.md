# Interface summary

| Field | Definition |
|---|---|
| Descriptor | 32-bit aligned address, 8-bit count in words (1–255), end-of-packet flag |
| Read master | AXI4 AR address/length/size/burst and R data/resp/last/valid/ready; one request outstanding |
| Stream | 32-bit data, TVALID/TREADY/TLAST; held stable under stall |
| Status | Per-descriptor done pulse; completed and error counters |

## Assumptions and limits

Descriptors arrive directly from control logic; there is no descriptor fetch engine, AXI write channel, burst coalescing, AXI transaction ID, or cache-coherency integration. One read beat is outstanding at a time.
