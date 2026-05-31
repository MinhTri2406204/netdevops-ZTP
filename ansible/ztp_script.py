#!/usr/bin/env python

from cli import configure
import cli
import re

print("\n--- Dang kich hoat ZTP Python ---")

show_ip_interface = cli.execute("show ip interface brief GigabitEthernet1")

ip_match = re.search(r'192\.168\.1\.(\d+)', show_ip_interface)

if ip_match:

    last_octet = int(ip_match.group(1))
    router_number = last_octet - 149
    hostname = "R{}".format(router_number)

    print("[INFO] Dat hostname =", hostname)

    configure("""
hostname {}
username admin privilege 15 secret 123

enable secret 123

crypto key generate rsa modulus 2048

ip ssh version 2

line vty 0 4
 login local
 transport input ssh

interface GigabitEthernet1
 description Ket noi voi Management ZTP
 ip address dhcp
 no shutdown

interface Loopback0
 ip address {}.{}.{}.{} 255.255.255.255

router ospf 1
 network 0.0.0.0 255.255.255.255 area 0
""".format(
        hostname,
        router_number,
        router_number,
        router_number,
        router_number
    ))

    cli.execute("write memory")

    print("\n--- ZTP Thanh Cong ---")

else:
    print("\n[ERROR] Khong tim thay IP 192.168.1.x")
