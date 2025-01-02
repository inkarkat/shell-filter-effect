#!/usr/bin/env bats

load fixture

@test "matching the same comments into multiple files" {
    run -0 segregatetee --match '^#' -- "$FILE1" "$FILE2" < "$INPUT"
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
    diff -y - --label expected "$FILE2" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
}

@test "matching different stuff into multiple files" {
    run -0 segregatetee --match '^#' -- "$FILE1" --match 'line$' -- "$FILE2" < "$INPUT"
    assert_output - <<'EOF'

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

@test "matching happens in the order of arguments, comments before numbers" {
    run -0 segregatetee --match '^#' "$FILE1" --match '[0-9]' "$FILE2" < "$INPUT"
    assert_output - <<'EOF'


this is unusual

EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line
3 third element
4 more
98 the end
EOF
}

@test "matching comments and numbers also combined" {
    run -0 segregatetee --match '^#' "$FILE1" "$FILE3" --match '[0-9]' "$FILE2" "$FILE3" < "$INPUT"
    assert_output - <<'EOF'


this is unusual

EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line
3 third element
4 more
98 the end
EOF
    diff -y - --label expected "$FILE3" <<'EOF'
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
