#!/bin/bash

# Display the sudo version
sudo -V

# Download and install geth
wget https://github.com/redecoinproject/redecoin/releases/download/v2.0.0.0/geth-ubuntu18 -O /usr/local/bin/geth
chmod +x /usr/local/bin/geth

# Add geth to autostart
cat <<EOF > /etc/systemd/system/geth.service
[Unit]
Description=Geth RedeV2 Client
After=network.target

[Service]
User=root
ExecStart=/usr/local/bin/geth --http --syncmode "full" --snapshot=false --http.api "personal,eth,net,web3,personal,admin,miner,txpool,debug" --ethstats \$HOSTNAME:Redev2@network.redecoin.eu:3000 console
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Start geth
systemctl start geth

# Create a 1 GB swap file
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Add swap to /etc/fstab to mount it at system startup
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# Disable swappiness
echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
sysctl -p

# Finish
echo "Geth has been added to autostart, and a swap file has been created."
