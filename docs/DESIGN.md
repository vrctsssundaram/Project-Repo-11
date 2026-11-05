# Technical design

A four-state IDLE/ISSUE/RECEIVE/OUTPUT controller processes one accepted descriptor at a time. Each 32-bit word issues an aligned AXI4 single-beat AR request. Successful R responses are held until the stream sink accepts them; the final word carries TLAST only when the descriptor requests end-of-packet. Invalid descriptors or failed read responses complete with an error count and no further reads.

## Integration profile

Descriptors enter through direct control ports. An aligned AXI4 read request retrieves one 32-bit beat at a time and a registered stream transfers the response.
