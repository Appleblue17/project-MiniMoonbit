start_stage="parse"
end_stage="closure"
file_name="non-tail-if2"
in_path="./test/test_src/${file_name}.mbt"
out_path="./test/test_after_parsing/${file_name}.json"
# moon run src/bin/main.mbt -- --start-stage $start_stage --end-stage $end_stage $in_path
# moon run src/bin/main.mbt -- --json --start-stage $start_stage --end-stage $end_stage $in_path -o $out_path
# moon run src/bin/main.mbt -- --start-stage $start_stage --end-stage $end_stage $in_path --closure-interpreter