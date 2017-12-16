#!/bin/sh
# rnl - remove final newlines

tr1='\012 '
tr2=' \012'
pat='$s/ *$/ /'

while getopts 0aso opt; do
	case "$opt" in
		0) tr1='\0 '; tr2=' \0';;
		a) pat='$s/ *$//';;
		s) pat='$s/ *$/ /';;
		o) pat='$s/ $//';;
		'?') exit 1;;
	esac
done

tr "$tr1" "$tr2" | sed "$pat" | tr "$tr2" "$tr1"
