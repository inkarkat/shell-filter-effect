#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 segregateInput
    assert_line -n 0 'ERROR: No --regexp, --match, or --no-match passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 segregateInput --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 segregateInput -h
    refute_line -n 0 -e '^Usage:'
}

@test "additional argument prints usage instructions" {
    run -2 segregateInput --regexp-command doesNotMatch "$FRAGMENT_COMMAND" additionalArgument
    assert_line -n 0 -e '^Usage:'
}
