#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

export INPUT="${BATS_TEST_DIRNAME}/input.txt"
readonly FRAGMENT_COMMAND='sed -e s/^/\|\ / -e 1i,---- -e \$a\`----'
readonly UPPERCASE_COMMAND='sed -e y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/'
readonly COUNT_COMMAND='sed -n ='
readonly QUOTE_COMMAND='sed -e s/^/\>/'
