start_stage="typecheck"
end_stage="typecheck"
file_name="cls-reg-bug"
in_path="./test/test_after_parsing/${file_name}.json"
out_path="./test/test_after_typing/${file_name}.json"
moon run src/bin/main.mbt -- --json --start-stage $start_stage --end-stage $end_stage $in_path -o $out_path