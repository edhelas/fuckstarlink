#!/bin/sh
# This script creates starlink_user_v4 and starlink_user_v6 ipsets.
# They can be used in firewall rules, for example with iptables:
#       iptables -I INPUT -m set --match-set starlink_user_v4 src,dst -j DROP
# will ignore all traffic coming from starlink IPv4 addresses.
# Inspired by https://wiki.gentoo.org/wiki/IPSet
set -o errexit

data="$(curl -s https://geoip.starlinkisp.net/feed.csv)"

ipv4s="$(printf '%s\n' "$data" | cut -d, -f1 | grep -Ex '((1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])(/([1-2]?[0-9]|3[0-2]))?')"
ipv6s="$(printf '%s\n' "$data" | cut -d, -f1 | grep -F :)"

set +o errexit

exitstatus=0

ipset create starlink_user_v4_tmp hash:net --hashsize 64
printf '%s\n' "$ipv4s" | while read -r ipv4
do
	ipset add starlink_user_v4_tmp "$ipv4"
done
(ipset create -exist starlink_user_v4 hash:net --hashsize 64 &&
ipset swap starlink_user_v4_tmp starlink_user_v4 &&
ipset destroy starlink_user_v4_tmp) || exitstatus=1

ipset create starlink_user_v6_tmp hash:net family inet6 --hashsize 64
printf '%s\n' "$ipv6s" | while read -r ipv6
do
	ipset add starlink_user_v6_tmp "$ipv6"
done
(ipset create -exist starlink_user_v6 hash:net family inet6 --hashsize 64 &&
ipset swap starlink_user_v6_tmp starlink_user_v6 &&
ipset destroy starlink_user_v6_tmp) || exitstatus=1

exit "$exitstatus"
