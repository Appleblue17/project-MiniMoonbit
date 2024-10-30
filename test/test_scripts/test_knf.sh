start_stage="knf"
end_stage="knf"
file_name="fib_small"
in_path="./test/test_after_typing/${file_name}.json"
out_path="./test/test_after_knf/${file_name}.json"
# moon run src/bin/main.mbt -- --start-stage $start_stage --end-stage $end_stage $in_path
moon run src/bin/main.mbt -- --json --start-stage $start_stage --end-stage $end_stage $in_path -o $out_path
# moon run src/bin/main.mbt -- --start-stage $start_stage --end-stage $end_stage $in_path --knf-interpreter