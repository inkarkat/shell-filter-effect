#!/usr/bin/env bats

load fixture

readonly PATTERN='9|[a-z]+$'
@test "identical PATTERN for different kinds prints message and exits with 2" {
    run -2 segregateInput --regexp-exec "$PATTERN" "${COUNT_COMMAND[@]}" \; --match-command "$PATTERN" "$QUOTE_COMMAND" < "$INPUT"
    assert_output "ERROR: Pattern '${PATTERN}' is specified more than once for different kinds: --regexp and --match"
}
