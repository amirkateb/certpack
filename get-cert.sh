#!/bin/bash

set -e

echo "=== CertPack SSL Generator ==="

read -p "Enter main domain (e.g. example.com): " MAIN_DOMAIN
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
echo "1) HTTP (Nginx)"
echo "2) DNS (Wildcard supported)"
read -p "Choice: " CHALLENGE

read -p "Mode? (1 = Patchim, 2 = Normal): " MODE

echo "Installing dependencies..."
apt update -y
apt install certbot python3-certbot-nginx zip -y

OUTPUT_DIR="/root/cert-output"
mkdir -p $OUTPUT_DIR

if [[ "$CHALLENGE" == "1" ]]; then
  echo "Using HTTP challenge..."
  certbot --nginx $DOMAINS --non-interactive --agree-tos -m $EMAIL --redirect

elif [[ "$CHALLENGE" == "2" ]]; then
  echo "Using DNS challenge (manual)..."
  certbot certonly --manual --preferred-challenges dns $DOMAINS --agree-tos -m $EMAIL

else
  echo "Invalid challenge type"
  exit 1
fi

BASE_PATH="/etc/letsencrypt/live/$MAIN_DOMAIN"

if [[ ! -d "$BASE_PATH" ]]; then
  echo "Certificate path not found"
  exit 1
fi

if [[ "$MODE" == "1" ]]; then
  echo "Patchim mode..."

  cat $BASE_PATH/fullchain.pem > $OUTPUT_DIR/server.crt
  cat $BASE_PATH/privkey.pem > $OUTPUT_DIR/server.key

  cd $OUTPUT_DIR
  zip cert-patchim.zip server.crt server.key

  echo "Output:"
  echo "$OUTPUT_DIR/cert-patchim.zip"

else
  echo "Normal mode..."

  cd $BASE_PATH
  zip $OUTPUT_DIR/cert-normal.zip fullchain.pem privkey.pem cert.pem chain.pem

  echo "Output:"
  echo "$OUTPUT_DIR/cert-normal.zip"
fi

echo "Done."
