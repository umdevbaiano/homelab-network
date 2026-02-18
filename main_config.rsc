# Virtual HomeLab Prototype - MikroTik RouterOS v7.13.3
# Autor: Samuel de Jesus Miranda

/interface vlan
add interface=ether5 name=vlan10-IA vlan-id=10
add interface=ether5 name=vlan20-MGMT vlan-id=20
add interface=ether5 name=vlan30-IOT vlan-id=30
add interface=ether5 name=vlan40-FAM vlan-id=40

/interface list
add name=LAN

/ip pool
add name=pool-IA ranges=10.10.10.10-10.10.10.250
add name=pool-FAM ranges=192.168.100.10-192.168.100.250

/ip dhcp-server
add address-pool=pool-IA interface=vlan10-IA name=srv-IA disabled=no
add address-pool=pool-FAM interface=vlan40-FAM name=srv-FAM disabled=no

/routing table
add fib name=to_WAN1
add fib name=to_WAN2
add fib name=to_WAN3
add fib name=to_WAN4

/interface list member
add interface=vlan10-IA list=LAN
add interface=vlan20-MGMT list=LAN
add interface=vlan30-IOT list=LAN
add interface=vlan40-FAM list=LAN

/ip address
add address=10.10.10.1/24 interface=vlan10-IA network=10.10.10.0
add address=10.20.20.1/24 interface=vlan20-MGMT network=10.20.20.0
add address=10.30.30.1/24 interface=vlan30-IOT network=10.30.30.0
add address=192.168.100.1/24 interface=vlan40-FAM network=192.168.100.0

/ip dhcp-client
add comment=WAN1_JT interface=ether1
add comment=WAN2_HE interface=ether2
add comment=WAN3_OI interface=ether3
add comment=WAN4_SL interface=ether4

/ip dhcp-server network
add address=10.10.10.0/24 comment="Rede IA" dns-server=8.8.8.8 gateway=10.10.10.1
add address=192.168.100.0/24 comment="Rede Familia" dns-server=8.8.8.8 gateway=192.168.100.1

/ip firewall filter
add action=drop chain=forward comment="Bloqueia acesso da Familia ao Cluster IA" dst-address=10.10.10.0/24 src-address=192.168.100.0/24

/ip firewall mangle
add action=mark-connection chain=prerouting dst-address-type=!local in-interface-list=LAN new-connection-mark=WAN1_conn passthrough=yes per-connection-classifier=both-addresses-and-ports:4/0
add action=mark-routing chain=prerouting connection-mark=WAN1_conn in-interface-list=LAN new-routing-mark=to_WAN1 passthrough=no
add action=mark-connection chain=prerouting dst-address-type=!local in-interface-list=LAN new-connection-mark=WAN2_conn passthrough=yes per-connection-classifier=both-addresses-and-ports:4/1
add action=mark-routing chain=prerouting connection-mark=WAN2_conn in-interface-list=LAN new-routing-mark=to_WAN2 passthrough=no
add action=mark-connection chain=prerouting dst-address-type=!local in-interface-list=LAN new-connection-mark=WAN3_conn passthrough=yes per-connection-classifier=both-addresses-and-ports:4/2
add action=mark-routing chain=prerouting connection-mark=WAN3_conn in-interface-list=LAN new-routing-mark=to_WAN3 passthrough=no
add action=mark-connection chain=prerouting dst-address-type=!local in-interface-list=LAN new-connection-mark=WAN4_conn passthrough=yes per-connection-classifier=both-addresses-and-ports:4/3
add action=mark-routing chain=prerouting connection-mark=WAN4_conn in-interface-list=LAN new-routing-mark=to_WAN4 passthrough=no

/ip firewall nat
add action=masquerade chain=srcnat comment="NAT WAN1 - JT" out-interface=ether1
add action=masquerade chain=srcnat comment="NAT WAN2 - HE" out-interface=ether2
add action=masquerade chain=srcnat comment="NAT WAN3 - OI" out-interface=ether3
add action=masquerade chain=srcnat comment="NAT WAN4 - SL" out-interface=ether4

/ip route
add check-gateway=ping dst-address=0.0.0.0/0 gateway=192.168.122.1 routing-table=to_WAN1
add check-gateway=ping dst-address=0.0.0.0/0 gateway=192.168.122.1 routing-table=to_WAN2
add check-gateway=ping dst-address=0.0.0.0/0 gateway=192.168.122.1 routing-table=to_WAN3
add check-gateway=ping dst-address=0.0.0.0/0 gateway=192.168.122.1 routing-table=to_WAN4
add check-gateway=ping distance=1 dst-address=0.0.0.0/0 gateway=192.168.122.1
