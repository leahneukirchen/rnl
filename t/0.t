#!/bin/sh

export "PATH=.:$PATH"

printf '1..11\n'
printf '# error handling\n'

tap3 '-0 on a pipe, no newlines' <<'EOF'
printf foo | rnl -0 | wc -c
>>>/3/
EOF

tap3 '-0 on a pipe, one newline' <<'EOF'
printf 'foo\n' | rnl -0 | wc -c
>>>/3/
EOF

tap3 '-0 on a pipe, two newlines' <<'EOF'
printf 'foo\nbar\n\n' | rnl -0 | wc -c
>>>/7/
EOF

tap3 '-0 on a pipe, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' | rnl -0 | wc -c
>>>/8/
EOF

tap3 '-0 on a pipe, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) | rnl -0 | wc -c
>>>/3/
EOF



tap3 '-0 on a file, no newlines' <<'EOF'
printf foo > TMP; rnl -0 TMP; wc -c <TMP; rm TMP
>>>/3/
EOF

tap3 '-0 on a file, one newline' <<'EOF'
printf 'foo\n' > TMP; rnl -0 TMP; wc -c <TMP; rm TMP
>>>/3/
EOF

tap3 '-0 on a file, two newlines' <<'EOF'
printf 'foo\nbar\n\n' > TMP; rnl -0 TMP; wc -c <TMP; rm TMP
>>>/7/
EOF

tap3 '-0 on a file, three newlines' <<'EOF'
printf 'foo\n\nbar\n\n\n' > TMP; rnl -0 TMP; wc -c <TMP; rm TMP
>>>/8/
EOF

tap3 '-0 on a file, 9999 newlines' <<'EOF'
( printf 'foo'; yes '' | sed 10000q ) > TMP; rnl -0 TMP; wc -c <TMP; rm TMP
>>>/3/
EOF

tap3 '-0 on a biggish file, 9999 newlines' <<'EOF'
( yes 'foo' | sed 10000q; yes '' | sed 10000q ) > TMP; rnl -0 TMP; wc -c <TMP; rm TMP
>>>/39999/
EOF
