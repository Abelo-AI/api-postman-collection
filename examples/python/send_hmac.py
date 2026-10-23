#!/usr/bin/env python3
"""
Send a message (Viber or SMS) using Abelo API with Enterprise HMAC-SHA256 request signing.

Prerequisites:
    pip install requests
"""
import hashlib
import hmac
import json
import os
import time
import requests

API_KEY_ID = os.getenv("ABELO_KEY_ID", "YOUR_API_KEY_ID")
HMAC_SECRET = os.getenv("ABELO_HMAC_SECRET", "YOUR_HMAC_SECRET")
BASE_URL = "https://api.abelo.ai"
PATH = "/v1/messages/send"

payload = {
    "campaign_id": os.getenv("ABELO_CAMPAIGN_ID", "YOUR_CAMPAIGN_ID"),
    # Recipient can be identified by phone_number, email, or public_id:
    # 1. Phone number: {"type": "phone_number", "value": "+306912345678"}
    # 2. Email:        {"type": "email", "value": "customer@example.com"}
    # 3. Public ID:    {"type": "public_id", "value": "prf_..."}
    "recipient": {
        "type": "phone_number",
        "value": os.getenv("RECIPIENT_PHONE", "+306912345678")
    },
    "params": {
        "first_name": "Dimitris",
        "pin": "938214"
    },
    "client_reference": "otp-req-938214"
}

body_bytes = json.dumps(payload, separators=(',', ':')).encode("utf-8")
body_hash = hashlib.sha256(body_bytes).hexdigest()
timestamp = str(int(time.time()))
method = "POST"

# Canonical string-to-sign: {timestamp}\n{method}\n{path}\n{body_hash}
string_to_sign = f"{timestamp}\n{method}\n{PATH}\n{body_hash}".encode("utf-8")

signature = hmac.new(
    key=HMAC_SECRET.encode("utf-8"),
    msg=string_to_sign,
    digestmod=hashlib.sha256
).hexdigest()

headers = {
    "X-Abelo-Key-Id": API_KEY_ID,
    "X-Abelo-Timestamp": timestamp,
    "X-Abelo-Signature": signature,
    "Content-Type": "application/json"
}

response = requests.post(f"{BASE_URL}{PATH}", data=body_bytes, headers=headers)
print("Status Code:", response.status_code)
print("Response Body:", response.json())
