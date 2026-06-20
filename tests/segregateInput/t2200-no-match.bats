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
