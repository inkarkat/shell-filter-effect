#!/usr/bin/env bats

load fixture

setup()
{
    fixtureSetup

    [ ! -w /etc ] || skip "Need non-writable /etc directory"
    export cannotBeWritten=/etc/cannotBeWritten
    [ ! -w "$cannotBeWritten" ] || skip "Need non-writable $cannotBeWritten file"

}

@test "writing to an unwritable directory prints error once and fails with 1 but otherwise proceeds" {
    LC_ALL=C run -1 --separate-stderr segregatetee --match '^#' "$FILE1" "$cannotBeWritten" --match 'line$' "$cannotBeWritten" "$FILE2" < "$INPUT"
    assert_output - <<'EOF'

3 third element
4 more

this is unusual

98 the end
EOF
    output="$stderr" assert_output -p '/etc/cannotBeWritten: Permission denied'
    lines=("${stderr_lines[@]}"); assert_equal ${#lines[@]} 1

    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line
EOF
}

@test "when all matches are to unwritable file(s) those lines are discarded" {
    LC_ALL=C run -1 --separate-stderr segregatetee --match '^#' "$FILE1" --match 'third|unusual' "$cannotBeWritten" --match 'line$' "$cannotBeWritten" "$FILE2" < "$INPUT"
    assert_output - <<'EOF'

4 more


98 the end
EOF
    output="$stderr" assert_output -p '/etc/cannotBeWritten: Permission denied'

    diff -y - --label expected "$FILE1" <<'EOF'
# 0 comment header
# attention!
# 99 comment trailer
EOF
    diff -y - --label expected "$FILE2" <<'EOF'
1 first line
2 second line
EOF
}
