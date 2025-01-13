#!/bin/sh
set -o errexit

# Done separately to ensure exit code is taken into account (we could use pipefail but Debian stable doesn't have it yet)
data="$(curl -s https://geoip.starlinkisp.net/feed.csv)"

#shellcheck disable=SC2016
printf 'geo $starlink_user {\ndefault 0;\n'
printf '%s\n' "$data" | cut -d, -f1 | sed 's/$/ 1;/'
printf '}\n'
