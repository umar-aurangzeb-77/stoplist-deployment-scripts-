#!/bin/bash

# ======================================================================================
#   This script generates a self-signed SSL certificate for the Nginx service.
#   This is intended for internal servers where a public domain and CA-signed
#   certificates (like Let's Encrypt) are not available.
#
#   Run this script once before the first deployment.
# ======================================================================================

# --- Configuration ---
SSL_DIR="./nginx/ssl"
KEY_FILE="$SSL_DIR/selfsigned.key"
CERT_FILE="$SSL_DIR/selfsigned.crt"
DAYS_VALID=365

# --- Check if certificate already exists ---
if [ -f "$CERT_FILE" ]; then
  echo "--> Self-signed certificate already exists at $CERT_FILE. Skipping generation."
  exit 0
fi

echo "### Generating Self-Signed SSL Certificate for Stoplist ###"

# --- Create SSL directory ---
echo "--> Creating directory for SSL certificates at $SSL_DIR..."
mkdir -p $SSL_DIR

# --- Generate the certificate ---
echo "--> Generating key and certificate..."
openssl req -x509 -nodes -newkey rsa:4096 -days $DAYS_VALID \
    -keyout "$KEY_FILE" \
    -out "$CERT_FILE" \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

echo ""
echo "#####################################################################"
echo "### Self-signed SSL certificate has been successfully generated. ###"
echo "#####################################################################"
echo ""
