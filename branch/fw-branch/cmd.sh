#enable ip forwarding
echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
#applies new sysctl.conf
sysctl -p

#starts nftables service
systemctl start nftables.service
#ensures nftables is started after reboot
systemctl enable nftables.service

#apply config
nft -f /etc/nftables.conf