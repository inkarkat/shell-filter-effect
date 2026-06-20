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

@test "identical matches only count lines with a 9 or the same last word" {
    run -0 segregateInput --match-exec '9|[a-z]+$' "${COUNT_COMMAND[@]}" \; < "$INPUT"
    assert_output - <<'EOF'
1
1
2

1
1

# attention!
1

1
2
EOF
}

@test "identical matches twice with the identical pattern combines the commands" {
    run -0 segregateInput --match-exec '9|[a-z]+$' "${COUNT_COMMAND[@]}" \; --match-command '9|[a-z]+$' "$FRAGMENT_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
,----
| 1
`----
,----
| 1
| 2
`----

,----
| 1
`----
,----
| 1
`----

# attention!
,----
| 1
`----

,----
| 1
| 2
`----
EOF
}

@test "identical exec matches take precedence over equivalent following pattern" {
    run -0 segregateInput --match-exec '9|[a-z]+$' "${COUNT_COMMAND[@]}" \; --match-command '[9]|[abcdefghijklmnopqrstuvwxyz]+$' "$QUOTE_COMMAND" < "$INPUT"
    assert_output - <<'EOF'
1
1
2

1
1

# attention!
1

1
2
EOF
}
