#!/usr/bin/env bats

load fixture

@test "identical matches only combine lines with a 9 or the same last word" {
    run -0 segregateInput --match-command '9|[a-z]+$' "$FRAGMENT_COMMAND" < "$INPUT"
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
`----
,----
| 4 more
`----

# attention!
,----
| this is unusual
`----

,----
| 98 the end
| # 99 comment trailer
`----
EOF
}
