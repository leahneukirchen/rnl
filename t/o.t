#!/bin/sh

export "PATH=.:$PATH"

printf '1..11\n'
printf '# error handling\n'

tap3 '-o on a pipe, no newlines' <<'EOF'
printf foo | rnl -o
>>>/foo/
EOF

tap3 '-o on a pipe, one newline' <<'EOF'
printf 'foo\n' | rnl -o | wc -c
>>>/3/
EOF

tap3 '-o on a pipe, two newlines' <<'EOF'
printf 'foo\nbar\n\n' | rnl -o
>>>
foo
bar
EOF

tap3 '-o on a pipe, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' | rnl -o
>>>
foo

bar

EOF

tap3 '-o on a pipe, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) | rnl -o | wc -l
>>>/9999/
EOF



tap3 '-o on a file, no newlines' <<'EOF'
printf foo > TMP; rnl -o TMP; cat TMP; rm TMP
>>>/foo/
EOF

tap3 '-o on a file, one newline' <<'EOF'
printf 'foo\n' > TMP; rnl -o TMP; wc -c TMP; rm TMP
>>>/3/
EOF

tap3 '-o on a file, two newlines' <<'EOF'
printf 'foo\nbar\n\n' > TMP; rnl -o TMP; cat TMP; rm TMP
>>>
foo
bar
EOF

tap3 '-o on a file, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' > TMP; rnl -o TMP; cat TMP; rm TMP
>>>
foo

bar

EOF

tap3 '-o on a file, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) > TMP; rnl -o TMP; wc -l TMP; rm TMP
>>>/9999/
EOF


tap3 '-o on a biggish file, 9999 newlines' <<'EOF'
( yes 'foo' | sed 10000q; yes '' | sed 10000q ) > TMP; rnl -o TMP; wc -l < TMP; rm TMP
>>>/19999/
EOF
