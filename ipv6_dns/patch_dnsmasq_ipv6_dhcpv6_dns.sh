#!/bin/sh

# PREREQUISITES: Interface must have DHCPv6 and SLAAC enabled.
# FUNCTION: Injects 'ra-names' and 'domain' directives to enable IPv6 FQDN resolution.
# BEHAVIOR: Idempotent. Checks for missing settings and only restarts dnsmasq if a patch is applied.
# USAGE: Designed for a 1-minute cron job. Auto-heals configuration after reboots or provisioning.

# 1. Parse Arguments
# $1 = The target config file path (Required)
# $2 = The local domain (Optional, defaults to 'myhome.local')

TARGET="$1"
DOMAIN="${2:-myhome.local}" 
NEEDS_RESTART=0

# 2. Validation: Ensure a target file was provided
if [ -z "$TARGET" ]; then
    # Only echo to stderr if running manually to avoid cron log spam
    if [ -t 1 ]; then echo "Usage: $0 <path_to_config> [domain]"; fi
    exit 1
fi

# 3. Safety Check: If file doesn't exist (interface down?), exit silently.
if [ ! -f "$TARGET" ]; then
    exit 0
fi

# 4. Check & Apply: RA-NAMES
# We check specifically for the 'slaac' definition in THIS file.
if grep -q "slaac" "$TARGET" && ! grep -q "ra-names" "$TARGET"; then
    sed -i 's/slaac/slaac,ra-names/' "$TARGET"
    NEEDS_RESTART=1
fi

# 5. Check & Apply: FQDN Settings
# We check if the specific domain string exists in THIS file.
if ! grep -q "domain=$DOMAIN" "$TARGET"; then
    echo "" >> "$TARGET"
    echo "# FQDN Injection" >> "$TARGET"
    echo "domain=$DOMAIN" >> "$TARGET"
    echo "expand-hosts" >> "$TARGET"
    NEEDS_RESTART=1
fi

# 6. Restart Service (Only if we touched the file)
if [ $NEEDS_RESTART -eq 1 ]; then
    logger -t dnsmasq-patch "Patched $TARGET for domain $DOMAIN. Restarting dnsmasq."
    pkill -9 dnsmasq
fi
