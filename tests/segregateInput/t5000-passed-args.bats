#!/usr/bin/env bats

load fixture

@test "passing matching lines with leading numbers as arguments" {
    run -0 segregateInput --regexp-command '^[0-9]' 'printf I\ have\ %s.\\n {}' < "$INPUT"
    assert_output - <<'EOF'
# 0 comment header
I have 1 first line.
I have 2 second line.

I have 3 third element.
I have 4 more.

# attention!
this is unusual

I have 98 the end.
# 99 comment trailer
EOF
}

@test "passing matching lines with leading numbers as arguments multiple times" {
    run -0 segregateInput --regexp-command '^[0-9]' 'args=({}); printf I\ have\ %d\ lines:\\n ${#args[@]}; printf I\ have\ %s.\\n {}' < "$INPUT"
    assert_output - <<'EOF'
# 0 comment header
I have 2 lines:
I have 1 first line.
I have 2 second line.

I have 2 lines:
I have 3 third element.
I have 4 more.

# attention!
this is unusual

I have 1 lines:
I have 98 the end.
# 99 comment trailer
EOF
}
