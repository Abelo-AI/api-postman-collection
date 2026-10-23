#!/usr/bin/env bash
# Send an SMS Message via Abelo API using Enterprise HMAC-SHA256 Request Signing
# Recipient supports 3 resolution types: "phone_number", "email", or "public_id"

API_KEY_ID="${ABELO_KEY_ID:-YOUR_API_KEY_ID}"
HMAC_SECRET="${ABELO_HMAC_SECRET:-YOUR_HMAC_SECRET}"
CAMPAIGN_ID="${ABELO_SMS_CAMPAIGN_ID:-${ABELO_CAMPAIGN_ID:-YOUR_SMS_CAMPAIGN_ID}}"
RECIPIENT_PHONE="${RECIPIENT_PHONE:-+306912345678}"

METHOD="POST"
PATH_URL="/v1/messages/send"
TIMESTAMP=$(date +%s)

BODY='{
  "campaign_id": "'"${CAMPAIGN_ID}"'",
  "recipient": {
    "type": "phone_number",
    "value": "'"${RECIPIENT_PHONE}"'"
  },
  "params": {
    "first_name": "Alex",
    "order_number": "ORD-10023",
    "tracking_code": "TRK-10023"
  },
  "client_reference": "sms-order-10023"
}'

# SHA256 hash of the request body
BODY_HASH=$(printf "%s" "$BODY" | openssl dgst -sha256 | awk '{print $NF}')

# Canonical string-to-sign: {timestamp}\n{METHOD}\n{path}\n{body_hash}
STRING_TO_SIGN=$(printf "%s\n%s\n%s\n%s" "$TIMESTAMP" "$METHOD" "$PATH_URL" "$BODY_HASH")

# HMAC-SHA256 signature
SIGNATURE=$(printf "%s" "$STRING_TO_SIGN" | openssl dgst -sha256 -hmac "$HMAC_SECRET" | awk '{print $NF}')

curl -X POST "https://api.abelo.ai${PATH_URL}" \
  -H "X-Abelo-Key-Id: ${API_KEY_ID}" \
  -H "X-Abelo-Timestamp: ${TIMESTAMP}" \
  -H "X-Abelo-Signature: ${SIGNATURE}" \
  -H "Content-Type: application/json" \
  -d "$BODY"
