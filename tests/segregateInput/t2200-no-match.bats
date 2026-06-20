#!/usr/bin/env bats

load fixture

@test "matching everything but comments" {
    run -0 segregateInput --no-match-command '^#' "$FRAGMENT_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
# 0 comment header
,----
| 1 first line
| 2 second line
| 
| 3 third element
| 4 more
| 
`----
# attention!
,----
| this is unusual
| 
| 98 the end
`----
# 99 comment trailer
EOF
}

@test "matching everything but empty lines" {
    run -0 segregateInput --no-match-command '^$' "$FRAGMENT_COMMAND" < "$INPUT"
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
| this is unusual
`----

,----
| 98 the end
| # 99 comment trailer
`----
EOF
}

@test "counting everything but empty lines" {
    run -0 segregateInput --no-match-exec '^$' "${COUNT_COMMAND[@]}" \; < "$INPUT"
    assert_output - <<'EOF'
1
2
3

1
2

1
2

1
2
EOF
}

@test "matching everything but empty lines twice with the identical pattern combines the commands" {
    run -0 segregateInput --no-match-command '^$' "$QUOTE_COMMAND" --no-match-command '^$' "$FRAGMENT_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
,----
| ># 0 comment header
| >1 first line
| >2 second line
`----

,----
| >3 third element
| >4 more
`----

,----
| ># attention!
| >this is unusual
`----

,----
| >98 the end
| ># 99 comment trailer
`----
EOF
}

@test "counting everything but empty lines take precedence over equivalent following pattern" {
    run -0 segregateInput --no-match-exec '^$' "${COUNT_COMMAND[@]}" \; --no-match-command '^x?$' "$QUOTE_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
1
2
3

1
2

1
2

1
2
EOF
}
