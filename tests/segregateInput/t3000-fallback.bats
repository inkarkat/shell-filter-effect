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
