#!/usr/bin/env bats

load fixture

@test "matching the same comments into multiple default files" {
    run -0 segregatetee --to "$FILE1" --to "$FILE2" --match '^#' < "$INPUT"
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

@test "giving a default file and overriding it for another match" {
    run -0 segregatetee --to "$FILE1" --match '^#' --match 'line$' -- "$FILE2" < "$INPUT"
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

@test "giving a default file and overriding it for another match, then falling back to it" {
    run -0 segregatetee --to "$FILE1" --match '^#' --match 'line$' -- "$FILE2" --match 'unusual' < "$INPUT"
    assert_output - <<'EOF'

3 third element
4 more


98 the end
EOF
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
this is unusual
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line
EOF
}

@test "giving separate default files for two matches" {
    run -0 segregatetee --to "$FILE1" --match '^#' --to "$FILE2" --match 'line$' < "$INPUT"
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

@test "giving separate default files (2 and 1 respectively) for two matches with override in between" {
    run -0 segregatetee --to "$FILE1" --to "$FILE2" --match '^#' --to "$FILE3" --match 'unusual' "$FILE4" --match 'line$' < "$INPUT"
    assert_output - <<'EOF'

3 third element
4 more


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
    diff -y - --label expected "$FILE3" <<'EOF'
1 first line
2 second line
EOF
    diff -y - --label expected "$FILE4" <<'EOF'
this is unusual
EOF
}
