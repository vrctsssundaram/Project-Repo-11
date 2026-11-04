# SGDMA-AXI4

Descriptor-fed 32-bit memory-to-stream transfer engine.

## Features

- Software-supplied address, length and end-of-packet descriptor
- AXI4 single-beat read requests with read-response checks
- Registered AXI-Stream output that holds under backpressure
- Alignment, address-wrap and response-error counters

## Verification

Run `make test` for the self-checking regression or `make synth` for a synthesis check. See `docs/` for the design, interface, procedure and recorded results.

This is a bounded RTL subsystem with explicit limitations; no board or standards certification is claimed.

Project owner: Sundaram S S.
