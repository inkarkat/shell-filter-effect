#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

export INPUT="${BATS_TEST_DIRNAME}/input.txt"
export FILE1="${BATS_TMPDIR}/file1.txt"
export FILE2="${BATS_TMPDIR}/file2.txt"
export FILE3="${BATS_TMPDIR}/file3.txt"
export FILE4="${BATS_TMPDIR}/file4.txt"

fixtureSetup()
{
    rm --force -- "$FILE1" "$FILE2" "$FILE3" "$FILE4"
}
setup()
{
    fixtureSetup
}
