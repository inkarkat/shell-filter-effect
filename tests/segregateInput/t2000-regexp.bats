#!/usr/bin/env bats

load fixture

@test "non-matching pattern prints whole input to stdout" {
    run -0 segregateInput --regexp-command doesNotMatch "$FRAGMENT_COMMAND"  < "$INPUT"
    assert_output - < "$INPUT"
}

@test "matching comments (individual lines)" {
    run -0 segregateInput --regexp-command '^#' "$UPPERCASE_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
# 0 COMMENT HEADER
1 first line
2 second line

3 third element
4 more

# ATTENTION!
this is unusual

98 the end
# 99 COMMENT TRAILER
EOF
}

@test "matching leading numbers (consecutive lines)" {
    run -0 segregateInput --regexp-command '^[0-9]' "$FRAGMENT_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
# 0 comment header
,----
| 1 first line
| 2 second line
`----

,----
| 3 third element
| 4 more
`----

# attention!
this is unusual

,----
| 98 the end
`----
# 99 comment trailer
EOF
}

@test "matching happens in the order of arguments, comments before numbers" {
    run -0 segregateInput \
	--regexp-command '^#' "$UPPERCASE_COMMAND" \
	--regexp-command '[0-9]' "$FRAGMENT_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
# 0 COMMENT HEADER
,----
| 1 first line
| 2 second line
`----

,----
| 3 third element
| 4 more
`----

# ATTENTION!
this is unusual

,----
| 98 the end
`----
# 99 COMMENT TRAILER
EOF

    run -0 segregateInput \
	--regexp-command '[0-9]' "$FRAGMENT_COMMAND" \
	--regexp-command '^#' "$UPPERCASE_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
,----
| # 0 comment header
| 1 first line
| 2 second line
`----

,----
| 3 third element
| 4 more
`----

# ATTENTION!
this is unusual

,----
| 98 the end
| # 99 comment trailer
`----
EOF
}
