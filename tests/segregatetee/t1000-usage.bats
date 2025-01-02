#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 segregatetee
    assert_line -n 0 'ERROR: No --match or --exclude passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 segregatetee --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 segregatetee -h
    refute_line -n 0 -e '^Usage:'
}

@test "--append without --match prints message and usage instructions" {
    run -2 segregatetee --append
    assert_line -n 0 'ERROR: --append must follow a --match or --exclude parameter.'
    assert_line -n 1 -e '^Usage:'
}

@test "--append after --match FILE prints message and usage instructions" {
    run -2 segregatetee --match foo FILE --append
    assert_line -n 0 'ERROR: --append must immediately follow a --match or --exclude parameter.'
    assert_line -n 1 -e '^Usage:'
}
