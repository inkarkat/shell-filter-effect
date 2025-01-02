#!/usr/bin/env bats

load fixture

@test "existing file content is truncated by default" {
    segregatetee --match '^#' "$FILE1" < "$INPUT"
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF

    run -0 segregatetee --match 'line$' "$FILE1" < "$INPUT"
    diff -y - --label expected "$FILE1" <<'EOF'
1 first line
2 second line
EOF
}

@test "appending more matches to an existing file" {
    segregatetee --match '^#' "$FILE1" < "$INPUT"
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF

    run -0 segregatetee --match 'line$' --append "$FILE1" < "$INPUT"
    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
1 first line
2 second line
EOF
}
