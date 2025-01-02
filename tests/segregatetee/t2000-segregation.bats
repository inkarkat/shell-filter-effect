#!/usr/bin/env bats

load fixture

@test "non-matching pattern prints whole input to stdout" {
    run -0 segregatetee --match doesNotMatch /dev/null < "$INPUT"
    assert_output - < "$INPUT"
}

@test "matching comments" {
    run -0 segregatetee --match '^#' "$FILE1" < "$INPUT"
    assert_output - <<'EOF'
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

@test "matching everything except comments" {
    run -0 segregatetee --exclude '^#' "$FILE1" < "$INPUT"
    assert_output - <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE1" <<'EOF'
1 first line
2 second line

3 third element
4 more

this is unusual

98 the end
EOF
}
