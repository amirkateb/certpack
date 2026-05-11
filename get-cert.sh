#!/bin/bash

set -e

echo "=== CertPack SSL Generator ==="

command -v certbot >/dev/null 2>&1 || {
  echo "Installing certbot..."
  apt update -y
  apt install certbot -y
}

command -v zip >/dev/null 2>&1 || {
  echo "Installing zip..."
  apt install zip -y
}

STOPPED_SERVICES=()

free_port_80() {
  echo "Checking port 80..."

  PORT_USERS=$(ss -tulpn | grep ':80 ' || true)

  if [[ -z "$PORT_USERS" ]]; then
    echo "Port 80 already free"
    return
  fi

  echo "Processes using port 80 detected"

  if systemctl is-active --quiet nginx; then
    echo "Stopping nginx..."
    systemctl stop nginx
    STOPPED_SERVICES+=("nginx")
  fi

  if systemctl is-active --quiet apache2; then
    echo "Stopping apache2..."
    systemctl stop apache2
    STOPPED_SERVICES+=("apache2")
  fi

  if command -v docker >/dev/null 2>&1; then
    CONTAINERS=$(docker ps --format '{{.ID}} {{.Ports}}' | grep '0.0.0.0:80->\|:::80->' | awk '{print $1}' || true)

    for c in $CONTAINERS; do
      echo "Stopping docker container $c ..."
      docker stop $c
      STOPPED_SERVICES+=("docker:$c")
    done
  fi

  REMAINING=$(ss -tulpn | grep ':80 ' || true)

  if [[ -n "$REMAINING" ]]; then
    echo "Force killing remaining processes on port 80..."

    PIDS=$(lsof -t -i:80 || true)

    for pid in $PIDS; do
      kill -9 $pid || true
    done
  fi

  sleep 2

  FINAL_CHECK=$(ss -tulpn | grep ':80 ' || true)

  if [[ -n "$FINAL_CHECK" ]]; then
    echo "Failed to free port 80"
    exit 1
  fi

  echo "Port 80 is now free"
}

restore_services() {
  echo "Restoring stopped services..."

  for svc in "${STOPPED_SERVICES[@]}"; do
    if [[ "$svc" == docker:* ]]; then
      CID=${svc#docker:}
      echo "Starting docker container $CID ..."
      docker start "$CID" || true
    else
      echo "Starting service $svc ..."
      systemctl start "$svc" || true
    fi
  done
}

trap restore_services EXIT

read -p "Enter main domain: " MAIN_DOMAIN
[[ -z "$MAIN_DOMAIN" ]] && echo "Domain required" && exit 1

read -p "Enter email: " EMAIL
[[ -z "$EMAIL" ]] && echo "Email required" && exit 1

read -p "Additional domains? (y/n): " HAS_EXTRA

DOMAINS="-d $MAIN_DOMAIN"

if [[ "$HAS_EXTRA" == "y" ]]; then
  read -p "Enter domains (space separated): " EXTRA

  for d in $EXTRA; do
    DOMAINS="$DOMAINS -d $d"
  done
fi

echo "Select challenge type:"
echo "1) HTTP Standalone"
echo "2) DNS Manual TXT / Wildcard"

read -p "Choice: " CHALLENGE

read -p "Mode? (1 = Patchim, 2 = Normal): " MODE

echo "Starting certificate process..."

if [[ "$CHALLENGE" == "1" ]]; then
  echo "Using HTTP standalone challenge..."

  free_port_80

  certbot certonly \
    --standalone \
    --preferred-challenges http \
    $DOMAINS \
    --non-interactive \
    --agree-tos \
    -m $EMAIL

elif [[ "$CHALLENGE" == "2" ]]; then
  echo "Using DNS challenge..."

  certbot certonly \
    --manual \
    --preferred-challenges dns \
    $DOMAINS \
    --agree-tos \
    -m $EMAIL

else
  echo "Invalid option"
  exit 1
fi

BASE_PATH="/etc/letsencrypt/live/$MAIN_DOMAIN"

if [[ ! -d "$BASE_PATH" ]]; then
  echo "Certificate not found!"
  exit 1
fi

OUTPUT_DIR="/root/cert-output"

mkdir -p "$OUTPUT_DIR"

if [[ "$MODE" == "1" ]]; then
  echo "Patchim mode..."

  cat "$BASE_PATH/fullchain.pem" > "$OUTPUT_DIR/server.crt"
  cat "$BASE_PATH/privkey.pem" > "$OUTPUT_DIR/server.key"

  cd "$OUTPUT_DIR"

  zip -o cert-patchim.zip server.crt server.key

  echo "Created:"
  echo "$OUTPUT_DIR/cert-patchim.zip"

else
  echo "Normal mode..."

  cd "$BASE_PATH"

  zip -o "$OUTPUT_DIR/cert-normal.zip" \
    fullchain.pem \
    privkey.pem \
    cert.pem \
    chain.pem

  echo "Created:"
  echo "$OUTPUT_DIR/cert-normal.zip"
fi

echo "Done."
