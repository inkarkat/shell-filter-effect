#!/usr/bin/env bats

load fixture

@test "matching comments with fallback" {
    run -0 segregatetee --match '^#' "$FILE1" --fallback "$FILE2" < "$INPUT"
    assert_output ''
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line

3 third element
4 more

this is unusual

98 the end
EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
}

@test "matching different stuff into multiple files with fallback" {
    run -0 segregatetee --match '^#' -- "$FILE1" --match 'line$' -- "$FILE2" --fallback "$FILE3" < "$INPUT"
    assert_output ''
    diff -y - --label expected "$FILE3" <<'EOF'

3 third element
4 more

this is unusual

98 the end
EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line
EOF
}
