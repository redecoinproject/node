#!/bin/bash

# Download and install geth
wget https://github.com/redecoinproject/redecoin/releases/download/v2.2.0.0/geth-ubuntu22 -O /usr/local/bin/geth
chmod +x /usr/local/bin/geth

# Add geth to autostart
cat <<EOF > /etc/systemd/system/geth.service
[Unit]
Description=Geth RedeV2 Client
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/start-geth.sh
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Create a script to start geth with the desired parameters
cat <<EOF > /usr/local/bin/start-geth.sh
#!/bin/bash

HOSTNAME=\$(hostname)
/usr/local/bin/geth --port 30304 --http --syncmode "full" --snapshot=false --http.api "personal,eth,net,web3,personal,admin,miner,txpool,debug" --ethstats "\$HOSTNAME:Redev2@network.redecoin.eu:3000"
EOF

# Make the start-geth.sh script executable
chmod +x /usr/local/bin/start-geth.sh

# Reload systemd
systemctl daemon-reload

# Start geth
systemctl start geth

# status
systemctl status geth

# Finish
echo "Geth has been added to autostart."
echo "node redev2 install done"
