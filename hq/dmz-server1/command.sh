#!/bin/bash
systemctl start nftables.service
systemctl enable nftables.service

#applies ruleset
nft -f /etc/nftables.conf