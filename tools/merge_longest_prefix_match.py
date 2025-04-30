#!/usr/bin/env python
import sys
import ipaddress

def parse_from_input(file):
    with open(file) as file_handle:
        return [line.rstrip('\n') for line in file_handle]

def parse_subnets(raw):
    return [ipaddress.ip_network(cidr) for cidr in raw]

def longest_prefix_matches(subnets):
    size = len(subnets)
    previous_size = len(subnets) + 1
    while size < previous_size:
        for net in subnets:
            super_net = net.supernet()
            if all((subnet in subnets) for subnet in super_net.subnets()):
                for subnet in super_net.subnets():
                    subnets.remove(subnet)
                subnets.append(super_net)
        previous_size = size
        size = len(subnets)
    return subnets

def sort_and_print(subnets, fmt):
    subnets_v4 = sorted([net for net in subnets if net.version == 4])
    subnets_v6 = sorted([net for net in subnets if net.version == 6])
    for cidr_range in subnets_v4:
        print(fmt.format(cidr_range))
    for cidr_range in subnets_v6:
        print(fmt.format(cidr_range))

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc < 2:
        print("Please specify a file as parameter to load ip ranges in cidr notation from")
        exit(1)
    file_to_load = sys.argv[1]
    custom_format = sys.argv[2] if argc >= 3 else "{}"
    raw_subnets = parse_from_input(file_to_load)
    subnets = parse_subnets(raw_subnets)
    reduced = longest_prefix_matches(subnets)
    sort_and_print(reduced, custom_format)
