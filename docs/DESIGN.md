# Technical design

A four-state IDLE/ISSUE/RECEIVE/OUTPUT controller processes one accepted descriptor at a time. Each 32-bit word issues an aligned AXI4 single-beat AR request. Successful R responses are held until the stream sink accepts them; the final word carries TLAST only when the descriptor requests end-of-packet. Invalid descriptors or failed read responses complete with an error count and no further reads.

## Scope boundary

Descriptors arrive directly from control logic; there is no descriptor fetch engine, AXI write channel, burst coalescing, AXI transaction ID, or cache-coherency integration. One read beat is outstanding at a time.
