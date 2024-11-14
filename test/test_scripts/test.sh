moon clean
moon build
moonrun target/wasm-gc/release/build/bin/bin.wasm -- ./test/test_src/cls-bug2.mbt -o ./test/test_after_asm/cls-bug2.s
zig build-exe -target riscv64-linux -femit-bin=./test/test_after_asm/cls-bug2.out ./test/test_after_asm/cls-bug2.s ./riscv_rt/zig-out/lib/libmincaml.a -O Debug -fno-strip -mcpu=baseline_rv64
./libriscv/emulator/rvlinux --silent --no-translate ./test/test_after_asm/cls-bug2.out