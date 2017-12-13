#!/bin/sh

export "PATH=.:$PATH"

printf '1..11\n'
printf '# error handling\n'

tap3 '-s on a pipe, no newlines' <<'EOF'
printf foo | rnl
>>>/foo/
EOF

tap3 '-s on a pipe, one newline' <<'EOF'
printf 'foo\n' | rnl
>>>
foo
EOF

tap3 '-s on a pipe, two newlines' <<'EOF'
printf 'foo\nbar\n\n' | rnl
>>>
foo
bar
EOF

tap3 '-s on a pipe, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' | rnl
>>>
foo

bar
EOF

tap3 '-s on a pipe, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) | rnl
>>>
foo
EOF



tap3 '-s on a file, no newlines' <<'EOF'
printf foo > TMP; rnl TMP; cat TMP; rm TMP
>>>/foo/
EOF

tap3 '-s on a file, one newline' <<'EOF'
printf 'foo\n' > TMP; rnl TMP; cat TMP; rm TMP
>>>
foo
EOF

tap3 '-s on a file, two newlines' <<'EOF'
printf 'foo\nbar\n\n' > TMP; rnl TMP; cat TMP; rm TMP
>>>
foo
bar
EOF

tap3 '-s on a file, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' > TMP; rnl TMP; cat TMP; rm TMP
>>>
foo

bar
EOF

tap3 '-s on a file, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) > TMP; rnl TMP; cat TMP; rm TMP
>>>
foo
EOF


tap3 '-s on a biggish file, 9999 newlines' <<'EOF'
( yes 'foo' | sed 10000q; yes '' | sed 10000q ) > TMP; rnl TMP; wc -l < TMP; rm TMP
>>>/10000/
EOF
