echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sysctl -p

systemctl start nftables.service
systemctl enable nftables.service