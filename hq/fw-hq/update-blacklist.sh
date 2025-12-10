#!/usr/bin/env bash
# usage: ./update-blacklist.sh file1.txt [file2.txt ... fileN.txt]
set -e
[[ $# -lt 1 ]] && { echo "Usage: $0 file1 [file2 ...]"; exit 1; }
TMP="/tmp/blacklist.$$"
# Merge + filter IPv4 OR IPv4/CIDR + dedup
cat "$@" \
  | tr -d '\r' \
  | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?' \
  | awk -F'[./]' '$1<=255&&$2<=255&&$3<=255&&$4<=255&&($5==""||$5<=32)' \
  | sort -Vu > "$TMP"
COUNT=$(wc -l < "$TMP")
echo "Loading $COUNT elements into nft set blacklist_ips..."
# Create atomic nft transaction
{
    echo "flush set netdev filter blacklist_ips"
    echo "add element netdev filter blacklist_ips {"
    sed 's/$/,/' "$TMP"
    echo "}"
} | nft -f -
rm -f "$TMP" # cleanup
