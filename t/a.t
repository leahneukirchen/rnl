#!/bin/sh

export "PATH=.:$PATH"

printf '1..11\n'
printf '# error handling\n'

tap3 '-a on a pipe, no newlines' <<'EOF'
printf foo | rnl -a | wc -c
>>>/3/
EOF

tap3 '-a on a pipe, one newline' <<'EOF'
printf 'foo\n' | rnl -a | wc -c
>>>/3/
EOF

tap3 '-a on a pipe, two newlines' <<'EOF'
printf 'foo\nbar\n\n' | rnl -a | wc -c
>>>/7/
EOF

tap3 '-a on a pipe, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' | rnl -a | wc -c
>>>/8/
EOF

tap3 '-a on a pipe, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) | rnl -a | wc -c
>>>/3/
EOF



tap3 '-a on a file, no newlines' <<'EOF'
printf foo > TMP; rnl -a TMP; wc -c <TMP; rm TMP
>>>/3/
EOF

tap3 '-a on a file, one newline' <<'EOF'
printf 'foo\n' > TMP; rnl -a TMP; wc -c <TMP; rm TMP
>>>/3/
EOF

tap3 '-a on a file, two newlines' <<'EOF'
printf 'foo\nbar\n\n' > TMP; rnl -a TMP; wc -c <TMP; rm TMP
>>>/7/
EOF

tap3 '-a on a file, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' > TMP; rnl -a TMP; wc -c <TMP; rm TMP
>>>/8/
EOF

tap3 '-a on a file, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) > TMP; rnl -a TMP; wc -c <TMP; rm TMP
>>>/3/
EOF

tap3 '-a on a biggish file, 9999 newlines' <<'EOF'
( yes 'foo' | sed 10000q; yes '' | sed 10000q ) > TMP; rnl -a TMP; wc -c <TMP; rm TMP
>>>/39999/
EOF
