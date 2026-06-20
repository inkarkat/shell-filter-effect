#!/usr/bin/env bats

load fixture

@test "combination of individual matches, patttern, and no-match patterns" {
    run -0 segregateInput \
	--match-command '9| [a-z]{4}$' "$FRAGMENT_COMMAND" \
	--regexp-command '^#' "$UPPERCASE_COMMAND" \
	--no-match-command '^$' "$QUOTE_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
# 0 COMMENT HEADER
,----
| 1 first line
| 2 second line
`----

>3 third element
,----
| 4 more
`----

# ATTENTION!
>this is unusual

,----
| 98 the end
| # 99 comment trailer
`----
EOF
}
