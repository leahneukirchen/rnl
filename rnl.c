/* rnl - remove final newlines */

#include <sys/stat.h>
#include <sys/types.h>

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char *argv[])
{
	int c;
	int i;
	int mode = -1;
	char nl = '\n';

	while ((c = getopt(argc, argv, "0aso")) != -1)
		switch (c) {
		case '0': nl = '\0'; break;
		case 'a': mode = 0; break;
		case 's': mode = -1; break;
		case 'o': mode = 1; break;
		default:
			fprintf(stderr,
"Usage: %s [-0aso] < INPUT           writes to stdout\n"
"       %s [-0aso] INPUT...          modifies files in-place!\n"
"  -0  strip NUL bytes instead of newlines\n"
"  -a  strip all newlines at end\n"
"  -s  default: strip all but one newline at end\n"
"  -o  strip one newline at end\n",
			    argv[0], argv[0]);
			exit(1);
		}

	if (optind == argc) {
		/* pipe mode stdin -> stdout */
		off_t n = 0;

		while ((c = getchar()) != EOF) {
			if (c == nl) {
				n++;
				continue;
			}
			for (i = 0; i < n; i++)
				putchar(nl);
			n = 0;
			putchar(c);
		}
		if (mode == 1)
			for (i = 0; i < n - 1; i++)
				putchar(nl);
		else if (mode == -1 && n > 0)
			putchar(nl);
		/* else (mode == 0) ; noop */

		return 0;
	}

	/* in-place mode */
	for (i = optind; i < argc; i++) {
		int fd = open(argv[i], O_RDWR);
		if (fd < 0)
			perror("rnl: open");

		off_t pos = lseek(fd, 0, SEEK_END);

		if (mode == 1) {
			if (pos > 0) {
				char buf;
				if (pread(fd, &buf, 1, pos - 1) != 1)
					perror("rnl: pread");
				if (buf == nl)
					if (ftruncate(fd, pos - 1) < 0)
						perror("rnl: ftruncate");

			}
		} else {
			char buf[1024];
			off_t n = 0;

			off_t endpos = pos;
			ssize_t rd;
			do {
				off_t l = sizeof buf;
				if (pos > l)
					pos -= l;
				else {
					l = pos;
					pos = 0;
				}
				rd = pread(fd, buf, l, pos);
				while (rd > 0 && buf[--rd] == nl)
					n++;
			} while (rd == 0 && n > 0 && pos > 0);

			if (rd < 0)
				perror("rnl: pread");

			if (mode == -1 && n > 0)
				n--;

			if (n > 0)
				if (ftruncate(fd, endpos - n) < 0)
					perror("rnl: ftruncate");
		}

		close(fd);
	}

	return 0;
}
