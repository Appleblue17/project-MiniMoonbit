start_stage="riscv"
end_stage="riscv"
file_name="adder"
in_path="./test/test_after_closure/${file_name}.json"
out_path="./test/test_after_asm/${file_name}.json"

# moon run src/bin/main.mbt -- --start-stage $start_stage --end-stage $end_stage $in_path
moon run src/bin/main.mbt -- --json --start-stage $start_stage --end-stage $end_stage $in_path -o $out_path
# zig build-exe -target riscv64-linux -femit-bin=$file_name $out_path /runtime/riscv_rt/zig-out/lib/libmincaml.a -O Debug -fno-strip -mcpu=baseline_rv64
# rvlinux -n $file_name