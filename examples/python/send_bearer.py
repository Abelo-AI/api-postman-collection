#!/usr/bin/env python3
"""
Send a message (Viber or SMS) using Abelo API with Bearer token authentication.

Prerequisites:
    pip install requests
"""
import os
import requests

API_KEY_ID = os.getenv("ABELO_KEY_ID", "YOUR_API_KEY_ID")
API_KEY_SECRET = os.getenv("ABELO_KEY_SECRET", "YOUR_API_KEY_SECRET")
BASE_URL = "https://api.abelo.ai/v1"

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
        "order_number": "ORD-8491",
        "tracking_code": "TR-8491"
    },
    "client_reference": "order-8491"
}

headers = {
    "Authorization": f"Bearer {API_KEY_ID}:{API_KEY_SECRET}",
    "Content-Type": "application/json"
}

response = requests.post(f"{BASE_URL}/messages/send", json=payload, headers=headers)
print("Status Code:", response.status_code)
print("Response Body:", response.json())
