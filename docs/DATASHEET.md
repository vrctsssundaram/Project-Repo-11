# Interface summary

| Field | Definition |
|---|---|
| Descriptor | 32-bit aligned address, 8-bit count in words (1–255), end-of-packet flag |
| Read master | AXI4 AR address/length/size/burst and R data/resp/last/valid/ready; one request outstanding |
| Stream | 32-bit data, TVALID/TREADY/TLAST; held stable under stall |
| Status | Per-descriptor done pulse; completed and error counters |

## Integration profile

Descriptors enter through direct control ports. An aligned AXI4 read request retrieves one 32-bit beat at a time and a registered stream transfers the response.
