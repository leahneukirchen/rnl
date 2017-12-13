#!/bin/sh

export "PATH=.:$PATH"

printf '1..11\n'
printf '# error handling\n'

tap3 '-1 on a pipe, no newlines' <<'EOF'
printf foo | rnl -1
>>>/foo/
EOF

tap3 '-1 on a pipe, one newline' <<'EOF'
printf 'foo\n' | rnl -1 | wc -c
>>>/3/
EOF

tap3 '-1 on a pipe, two newlines' <<'EOF'
printf 'foo\nbar\n\n' | rnl -1
>>>
foo
bar
EOF

tap3 '-1 on a pipe, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' | rnl -1
>>>
foo

bar

EOF

tap3 '-1 on a pipe, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) | rnl -1 | wc -l
>>>/9999/
EOF



tap3 '-1 on a file, no newlines' <<'EOF'
printf foo > TMP; rnl -1 TMP; cat TMP; rm TMP
>>>/foo/
EOF

tap3 '-1 on a file, one newline' <<'EOF'
printf 'foo\n' > TMP; rnl -1 TMP; wc -c TMP; rm TMP
>>>/3/
EOF

tap3 '-1 on a file, two newlines' <<'EOF'
printf 'foo\nbar\n\n' > TMP; rnl -1 TMP; cat TMP; rm TMP
>>>
foo
bar
EOF

tap3 '-1 on a file, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' > TMP; rnl -1 TMP; cat TMP; rm TMP
>>>
foo

bar

EOF

tap3 '-1 on a file, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) > TMP; rnl -1 TMP; wc -l TMP; rm TMP
>>>/9999/
EOF


tap3 '-1 on a biggish file, 9999 newlines' <<'EOF'
( yes 'foo' | sed 10000q; yes '' | sed 10000q ) > TMP; rnl -1 TMP; wc -l < TMP; rm TMP
>>>/19999/
EOF
