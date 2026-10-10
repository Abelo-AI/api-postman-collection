#!/usr/bin/env bash
# Test Webhook URL with a signed test payload via Abelo API using Bearer Authentication
# Endpoint: POST /v1/webhooks/test (Returns 202 Accepted)
#
# Note: "webhook_id" and "url" are mutually exclusive:
# 1. Provide "webhook_id" to test against a registered webhook (signed with webhook's secret)
# 2. Provide "url" to test a standalone endpoint (signed with API key's webhook signing secret)

API_KEY_ID="${ABELO_KEY_ID:-YOUR_API_KEY_ID}"
API_KEY_SECRET="${ABELO_KEY_SECRET:-YOUR_API_KEY_SECRET}"
WEBHOOK_ID="${ABELO_WEBHOOK_ID:-}"
TARGET_URL="${WEBHOOK_TARGET_URL:-https://api.yourdomain.com/webhooks/abelo}"

if [ -n "$WEBHOOK_ID" ]; then
  # Test registered webhook by ID
  PAYLOAD='{
    "webhook_id": "'"${WEBHOOK_ID}"'",
    "body": {
      "event": "test_event",
      "message": "Testing registered webhook delivery endpoint"
    }
  }'
else
  # Test custom standalone URL
  PAYLOAD='{
    "url": "'"${TARGET_URL}"'",
    "body": {
      "event": "test_event",
      "message": "Testing custom webhook delivery endpoint"
    }
  }'
fi

curl -X POST "https://api.abelo.ai/v1/webhooks/test" \
  -H "Authorization: Bearer ${API_KEY_ID}:${API_KEY_SECRET}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD"
