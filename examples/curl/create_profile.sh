#!/usr/bin/env bash
# Create a customer profile and channel consent via Abelo API using Bearer Authentication
# Endpoint: POST /v1/profiles (Returns 201 Created)

API_KEY_ID="${ABELO_KEY_ID:-YOUR_API_KEY_ID}"
API_KEY_SECRET="${ABELO_KEY_SECRET:-YOUR_API_KEY_SECRET}"
RECIPIENT_PHONE="${RECIPIENT_PHONE:-+306912345678}"

curl -X POST "https://api.abelo.ai/v1/profiles" \
  -H "Authorization: Bearer ${API_KEY_ID}:${API_KEY_SECRET}" \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "'"${RECIPIENT_PHONE}"'",
    "email": "customer@example.com",
    "first_name": "Eleni",
    "last_name": "Papadopoulou",
    "viber_marketing_consent": true,
    "sms_marketing_consent": false
  }'
