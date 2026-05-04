#!/bin/bash

set -e

echo "=== SSL Certificate Setup Script ==="

read -p "Enter main domain (e.g. example.com): " MAIN_DOMAIN

if [[ -z "$MAIN_DOMAIN" ]]; then
  echo "Main domain is required"
  exit 1
fi

read -p "Enter email for Let's Encrypt: " EMAIL

if [[ -z "$EMAIL" ]]; then
  echo "Email is required"
  exit 1
fi

read -p "Do you have additional domains? (y/n): " HAS_EXTRA

DOMAINS="-d $MAIN_DOMAIN"

if [[ "$HAS_EXTRA" == "y" ]]; then
  read -p "Enter additional domains (space separated): " EXTRA_DOMAINS
  for d in $EXTRA_DOMAINS; do
    DOMAINS="$DOMAINS -d $d"
  done
fi

read -p "Mode? (1 = Patchim, 2 = Normal): " MODE

echo "Installing dependencies..."
apt update -y
apt install certbot python3-certbot-nginx zip -y

echo "Obtaining certificate..."
certbot --nginx $DOMAINS --non-interactive --agree-tos -m $EMAIL --redirect

BASE_PATH="/etc/letsencrypt/live/$MAIN_DOMAIN"
OUTPUT_DIR="/root/cert-output"

mkdir -p $OUTPUT_DIR

if [[ "$MODE" == "1" ]]; then
  echo "Patchim mode selected"

  cat $BASE_PATH/fullchain.pem > $OUTPUT_DIR/server.crt
  cat $BASE_PATH/privkey.pem > $OUTPUT_DIR/server.key

  cd $OUTPUT_DIR
  zip cert-patchim.zip server.crt server.key

  echo "Patchim certificate created:"
  echo "$OUTPUT_DIR/cert-patchim.zip"

else
  echo "Normal mode selected"

  cd $BASE_PATH
  zip $OUTPUT_DIR/cert-normal.zip fullchain.pem privkey.pem cert.pem chain.pem

  echo "Normal certificate created:"
  echo "$OUTPUT_DIR/cert-normal.zip"
fi

echo "Done."
