#!/usr/bin/env bats

load fixture

@test "matching multiple patterns into the same file" {
    run -0 segregatetee --match '^#' "$FILE1" --match '[0-9]' "$FILE1" < "$INPUT"
    assert_output - <<'EOF'


this is unusual

EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
1 first line
2 second line
3 third element
4 more
# attention!
98 the end
# 99 comment trailer
EOF
}

@test "mixing match and exclude patterns into the same file" {
    run -0 segregatetee --exclude '^#' "$FILE1" --match '[0-9]' "$FILE1" < "$INPUT"
    assert_output - <<'EOF'
# attention!
EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
1 first line
2 second line

3 third element
4 more

this is unusual

98 the end
# 99 comment trailer
EOF
}
