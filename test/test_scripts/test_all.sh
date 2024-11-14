start_stage="parse"
end_stage="riscv"
file_name="cls-bug2"
in_path="./test/test_src/${file_name}.mbt"
out_path="./test/test_after_asm/${file_name}.s"
out_bin="./test/test_after_asm/${file_name}.bin"

# moon run src/bin/main.mbt -- --start-stage $start_stage --end-stage $end_stage $in_path
moon run src/bin/main.mbt -- --json --start-stage $start_stage --end-stage $end_stage $in_path -o $out_path
zig build-exe -target riscv64-linux -femit-bin=$out_bin $out_path ./riscv_rt/zig-out/lib/libmincaml.a -O Debug -fno-strip -mcpu=baseline_rv64
./libriscv/emulator/rvlinux -n $out_bin
