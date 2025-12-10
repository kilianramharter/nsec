#!/bin/bash

# Enable IP forwarding and apply the changes
# echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
# sysctl -p

# Start NFTables and enable it
systemctl start nftables.service
systemctl enable nftables.service

# Set NTP server and apply the changes
echo "NTP=ts1.univie.ac.at" >> /etc/systemd/timesyncd.conf
systemctl restart systemd-timesyncd.service

# Copy the sysctl.conf file to /etc/sysctl.conf
# Apply the changes
sysctl -p

# Copy the nftables.conf file to /etc/nftables.conf
# Apply the changes
nft -f /etc/nftables.sh
