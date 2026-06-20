#!/usr/bin/env bats

load fixture

@test "fallback command covers everything not matched" {
    run -0 segregateInput \
	--fallback-command "$QUOTE_COMMAND" \
	--regexp-command '^#' "$UPPERCASE_COMMAND" \
	--regexp-command '[0-9]' "$FRAGMENT_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
# 0 COMMENT HEADER
,----
| 1 first line
| 2 second line
`----
>
,----
| 3 third element
| 4 more
`----
>
# ATTENTION!
>this is unusual
>
,----
| 98 the end
`----
# 99 COMMENT TRAILER
EOF
}

@test "fallback exec covers everything not matched" {
    run -0 segregateInput \
	--fallback-exec "${COUNT_COMMAND[@]}" \; \
	--regexp-command '^#' "$UPPERCASE_COMMAND" \
	--regexp-command '[0-9]' "$FRAGMENT_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
# 0 COMMENT HEADER
,----
| 1 first line
| 2 second line
`----
1
,----
| 3 third element
| 4 more
`----
1
# ATTENTION!
1
2
,----
| 98 the end
`----
# 99 COMMENT TRAILER
EOF
}

@test "--regexp overrides fallback and prints to stdout" {
    run -0 segregateInput \
	--fallback-command "$QUOTE_COMMAND" \
	--regexp '^#' \
	--regexp-command '[0-9]' "$FRAGMENT_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
# 0 comment header
,----
| 1 first line
| 2 second line
`----
>
,----
| 3 third element
| 4 more
`----
>
# attention!
>this is unusual
>
,----
| 98 the end
`----
# 99 comment trailer
EOF
}

@test "fallback command twice combines the commands" {
    run -0 segregateInput \
	--fallback-exec "${COUNT_COMMAND[@]}" \; \
	--fallback-command "$QUOTE_COMMAND" \
	--regexp-command '^#' "$UPPERCASE_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
# 0 COMMENT HEADER
>1
>2
>3
>4
>5
>6
# ATTENTION!
>1
>2
>3
# 99 COMMENT TRAILER
EOF
}
