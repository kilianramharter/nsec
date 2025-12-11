#!/usr/bin/env bash
# update-nft-sets-by-domain.sh — Update multiple nftables IPv4 sets from DNS

TABLE="inet filter"

MAPPINGS=$(cat <<'EOF'
ts1.univie.ac.at ntpServers
debian.org       debianRepositories
EOF
)

# Read each line as "HOST SET"
while read -r HOST SET; do
  # skip empty / comment lines just in case
  [ -z "$HOST" ] && continue
  case "$HOST" in
    \#*) continue ;;
  esac

  # resolve A (IPv4)
  IPS=$(dig +short A "$HOST" | grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -u)

  if [ -z "$IPS" ]; then
    echo "$(date): no IPv4 A records for $HOST — leaving existing set $SET untouched" >&2
    continue
  fi

  ELEMS=$(echo "$IPS" | paste -sd "," -)

  echo "$(date): Updating $SET (for $HOST) → { $ELEMS }"

  nft -f - <<EOF
flush set $TABLE $SET
add element $TABLE $SET { $ELEMS }
EOF

  if [ $? -ne 0 ]; then
    echo "$(date): ERROR updating set $SET" >&2
  fi
done <<< "$MAPPINGS"
