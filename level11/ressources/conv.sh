#!/bin/sh

# Encode tout caractère non alphanumérique en %HH
string="$1"
output=""

i=0
len=${#string}

while [ $i -lt $len ]; do
    c=$(printf '%s' "$string" | cut -c $((i+1)))
    case "$c" in
        [a-zA-Z0-9.~_-] )
            output="$output$c"
            ;;
        * )
            hex=$(printf '%02X' "'$c")
            output="$output%$hex"
            ;;
    esac
    i=$((i+1))
done

printf '%s\n' "$output"
