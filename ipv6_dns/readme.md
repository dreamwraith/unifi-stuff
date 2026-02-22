# UniFi DNSMasq IPv6 Patcher

## Overview
This script resolves a common issue on UniFi gateways (UXG, UDM, UGC) where IPv6 clients do not register hostnames in DNS. It automatically injects `ra-names` and `domain` directives into the generated `dnsmasq` configuration, enabling full FQDN resolution (e.g., `host.myhome.internal`) for IPv6 devices.

## Prerequisites
1. **UniFi Network Settings:**
   - IPv6 Interface Type: **Static** or **Prefix Delegation**
   - DHCPv6: **Enabled**
   - IPv6 RA: **Enabled** (SLAAC)
2. **System Access:** SSH access to the gateway.

## Installation
1. Save the script to a persistent location (e.g., `/volume1/custom_scripts/patch_dnsmasq_ipv6_dhcpv6_dns.sh`).
2. Make it executable:
   ```sh
   chmod +x /volume1/custom_scripts/patch_dnsmasq_ipv6_dhcpv6_dns.sh


## Crontab Example

```bash
# Run every minute
# Syntax: /path/to/script <CONFIG_FILE> <DOMAIN_NAME>

# 1. Main Network (Default domain myhome.internal)
* * * * * /volume1/custom_scripts/patch_dnsmasq_ipv6_dhcpv6_dns.sh /run/dnsmasq.dhcp.conf.d/dhcp.dhcpServers-net_Main_IPV6.conf myhome.internal

# 2. IoT Network (Custom domain iot.myhome.internal)
* * * * * /volume1/custom_scripts/patch_dnsmasq_ipv6_dhcpv6_dns.sh /run/dnsmasq.dhcp.conf.d/dhcp.dhcpServers-net_IoT_IPV6.conf iot.myhome.internal

# 3. Guest Network (Custom domain guest.myhome.internal)
* * * * * /volume1/custom_scripts/patch_dnsmasq_ipv6_dhcpv6_dns.sh /run/dnsmasq.dhcp.conf.d/dhcp.dhcpServers-net_Guest_IPV6.conf guest.myhome.internal
```
