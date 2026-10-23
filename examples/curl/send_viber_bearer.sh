#!/usr/bin/env bash
# Send a Viber Business Message via Abelo API using Basic Bearer Authentication
# Recipient supports 3 resolution types: "phone_number", "email", or "public_id"

API_KEY_ID="${ABELO_KEY_ID:-YOUR_API_KEY_ID}"
API_KEY_SECRET="${ABELO_KEY_SECRET:-YOUR_API_KEY_SECRET}"
CAMPAIGN_ID="${ABELO_VIBER_CAMPAIGN_ID:-${ABELO_CAMPAIGN_ID:-YOUR_VIBER_CAMPAIGN_ID}}"
RECIPIENT_PHONE="${RECIPIENT_PHONE:-+306912345678}"

curl -X POST "https://api.abelo.ai/v1/messages/send" \
  -H "Authorization: Bearer ${API_KEY_ID}:${API_KEY_SECRET}" \
  -H "Content-Type: application/json" \
  -d '{
    "campaign_id": "'"${CAMPAIGN_ID}"'",
    "recipient": {
      "type": "phone_number",
      "value": "'"${RECIPIENT_PHONE}"'"
    },
    "params": {
      "first_name": "Alex",
      "order_number": "ORD-10023",
      "tracking_code": "TR-10023"
    },
    "client_reference": "order-10023"
  }'
