#!/bin/bash

# Usage commands:
# ./addport.sh 8545 tcp   # To open TCP only
# ./addport.sh 8545 udp   # To open UDP only
# ./addport.sh 30304 tcp   # To open TCP only
# ./addport.sh 30304 udp   # To open UDP only
# ./addport.sh 30304 both  # To open both TCP and UDP

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 PORT [tcp|udp|both]"
    exit 1
fi

PORT=$1
PROTOCOL=$2

# Add iptables rules based on the protocol
case $PROTOCOL in
    tcp)
        sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport $PORT -j ACCEPT
        ;;
    udp)
        sudo iptables -A INPUT -p udp -m state --state NEW -m udp --dport $PORT -j ACCEPT
        ;;
    both)
        sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport $PORT -j ACCEPT
        sudo iptables -A INPUT -p udp -m state --state NEW -m udp --dport $PORT -j ACCEPT
        ;;
    *)
        echo "Invalid protocol: $PROTOCOL. Choose 'tcp', 'udp' or 'both'."
        exit 1
        ;;
esac

# Save the current rules to the file
sudo iptables-save > /etc/iptables/rules.v4

# Verify if the rules were added
echo "Current iptables rules for port $PORT:"
sudo iptables -L | grep $PORT

