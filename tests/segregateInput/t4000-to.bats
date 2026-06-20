#!/usr/bin/env bats

load fixture

@test "two different patterns into identical command processes lines separately " {
    run -0 segregateInput \
	--regexp-command '^#' "$FRAGMENT_COMMAND" \
	--regexp-command '[0-9]' "$FRAGMENT_COMMAND" \
	< "$INPUT"
    assert_output - <<'EOF'
,----
| # 0 comment header
`----
,----
| 1 first line
| 2 second line
`----

,----
| 3 third element
| 4 more
`----

,----
| # attention!
`----
this is unusual

,----
| 98 the end
`----
,----
| # 99 comment trailer
`----
EOF
}

@test "two different patterns with separate to-command processes lines together " {
    run -0 segregateInput \
	--to-command "$FRAGMENT_COMMAND" \
	--regexp '^#' \
	--regexp '[0-9]' \
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

,----
| # attention!
`----
this is unusual

,----
| 98 the end
| # 99 comment trailer
`----
EOF
}

@test "use of two different to-commands" {
    run -0 segregateInput \
	--to-command "$QUOTE_COMMAND" \
	--regexp 'th' \
	--to-command "$FRAGMENT_COMMAND" \
	--regexp '^#' \
	--regexp '[0-5]' \
	< "$INPUT"
    assert_output - <<'EOF'
,----
| # 0 comment header
| 1 first line
| 2 second line
`----

>3 third element
,----
| 4 more
`----

,----
| # attention!
`----
>this is unusual

>98 the end
,----
| # 99 comment trailer
`----
EOF
}

@test "combination of to-command and regexp-command" {
    run -0 segregateInput \
	--to-command "$FRAGMENT_COMMAND" \
	--regexp '^#' \
	--regexp-command 'th' "$QUOTE_COMMAND" \
	--regexp '[0-5]' \
	< "$INPUT"
    assert_output - <<'EOF'
,----
| # 0 comment header
| 1 first line
| 2 second line
`----

>3 third element
,----
| 4 more
`----

,----
| # attention!
`----
>this is unusual

>98 the end
,----
| # 99 comment trailer
`----
EOF
}
