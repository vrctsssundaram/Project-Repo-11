# Test procedure

1. Install a SystemVerilog-capable Icarus Verilog toolchain.
2. Run `make test` in the repository root; require exit code 0 and the final PASS message.
3. Install Yosys and run `make synth` to check synthesizability and inspect the mapping statistics.
4. Review the hosted GitHub Actions run and `docs/RESULTS.md` for the exact tested revision.

Directed regression covers: valid two-word and one-word descriptors, chained packet boundary, stream backpressure, misaligned descriptor rejection, AXI RRESP failure.

For device qualification, separately run target-specific implementation, static timing, power, CDC/protocol checks as appropriate and hardware tests.
