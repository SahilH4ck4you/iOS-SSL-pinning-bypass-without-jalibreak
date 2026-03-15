#!/bin/bash
# Check if IP address argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide an IP address"
    echo "Usage: $0 <IP_ADDRESS>"
    echo "Example: $0 192.168.1.100"
    exit 1
fi

IP_ADDRESS="$1"

# Validate IP address format (basic validation)
if ! [[ $IP_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid IP address format"
    echo "Please use format: xxx.xxx.xxx.xxx"
    exit 1
fi

echo "Setting up iptables rules for IP: $IP_ADDRESS"

# Add PREROUTING rules for port 80 and 443
echo "Adding PREROUTING rules for tun0 interface..."

sudo iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 80 -j REDIRECT --to-port 8080
if [ $? -eq 0 ]; then
    echo "✓ Rule added: Redirect port 80 to 8080"
else
    echo "✗ Failed to add rule for port 80"
fi

sudo iptables -t nat -A PREROUTING -i tun0 -p tcp --dport 443 -j REDIRECT --to-port 8080
if [ $? -eq 0 ]; then
    echo "✓ Rule added: Redirect port 443 to 8080"
else
    echo "✗ Failed to add rule for port 443"
fi

# Add POSTROUTING rule with provided IP
echo "Adding POSTROUTING MASQUERADE rule for IP: $IP_ADDRESS/24..."

sudo iptables -t nat -A POSTROUTING -s "$IP_ADDRESS/24" -o eth0 -j MASQUERADE
if [ $? -eq 0 ]; then
    echo "✓ Rule added: MASQUERADE for $IP_ADDRESS/24 on eth0"
else
    echo "✗ Failed to add MASQUERADE rule"
fi

# Display current rules
echo -e "\nCurrent NAT table rules:"
sudo iptables -t nat -L -n -v

echo -e "\nSetup complete!"
