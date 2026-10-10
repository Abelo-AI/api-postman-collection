# Abelo REST API — Official Postman Collection & Quickstart

[![Official Rakuten Viber Partner](https://img.shields.io/badge/Rakuten%20Viber-Official%20Messaging%20Partner-7360F2?style=flat&logo=viber&logoColor=white)](https://www.forbusiness.viber.com/en/messaging-partners/partner/abelo/)
[![OpenAPI 3.1](https://img.shields.io/badge/OpenAPI-3.1-6BA539?style=flat&logo=openapi-initiative&logoColor=white)](./openapi_v1.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Run in Postman](https://img.shields.io/badge/Postman-Run%20in%20Postman-FF6C37?style=flat&logo=postman&logoColor=white)](https://www.postman.com/abelo-ai/abelo-public-api)

The official Postman collection, OpenAPI 3.1 specification, and quickstart guides for the **[Abelo](https://abelo.ai)** REST API.

**Abelo** is an intelligent business messaging platform and an **Official Rakuten Viber Messaging Partner**. Businesses use Abelo to deliver transactional alerts (OTPs, order tracking, shipping notices), promotional campaigns, and eCommerce automations across **Viber**, **WhatsApp**, and **SMS** with automatic failover, profile synchronization, and 100% verified ROI tracking.

Explore our collection directly in the [Official Postman Public Workspace](https://www.postman.com/abelo-ai/abelo-public-api).

---

## Key Features

- **Direct Viber Business Messaging**: Built and delivered directly via official Rakuten Viber Business API infrastructure with a verified branded sender ID.
- **Automatic SMS Failover**: If a recipient cannot receive a Viber or WhatsApp message, Abelo automatically falls back to SMS with zero configuration required.
- **Dual Authentication**:
  - **Basic Bearer Token** (`key_id:key_secret`) for frictionless developer onboarding.
  - **Enterprise HMAC-SHA256 Request Signing** for banking, fintech, and mission-critical OTPs.
- **eCommerce & System Integrations**: Native connectors for Shopify, WooCommerce, and Magento, plus a high-throughput REST API for custom back-offices and CRMs.
- **Real-Time Webhooks**: HMAC-SHA256 signed delivery receipts (`sent`, `delivered`, `seen`, `clicked`, `expired`, `failed`).

---

## Quickstart with Postman

You can get started either by opening the official Postman public workspace or by importing the collection files manually.

### Option A: Open in Postman Public Workspace (Recommended)
1. Navigate to the **[Abelo Public API Workspace](https://www.postman.com/abelo-ai/abelo-public-api)** on Postman.
2. Select the **Abelo REST API** collection and click **Fork** to add it to your own Postman workspace.
3. Select the **Abelo API (Production)** environment.

### Option B: Manual File Import
1. Clone this repository or download the files from [`postman/`](./postman/):
   - [`postman/Abelo_API.postman_collection.json`](./postman/Abelo_API.postman_collection.json)
   - [`postman/Abelo_Environment.postman_environment.json`](./postman/Abelo_Environment.postman_environment.json)
2. Open Postman and click **Import** to load both files.
3. Select the **Abelo API (Production)** environment.

### Configure Your Credentials
In your Postman Environment, fill in your credentials obtained from the [Abelo Management Console](https://abelo.ai):
- `baseUrl`: `https://api.abelo.ai/v1`
- `authMethod`: `bearer` (default) or `hmac`
- `apiKeyId`: Your API Key ID (`key_live_...`)
- `apiKeySecret`: Your API Key Secret (for `bearer` mode)
- `hmacSecret`: Your HMAC Secret (only needed if `authMethod` is set to `hmac`)
- `campaignId`: Your Target API Campaign ID
- `testPhoneNumber`: E.164 phone number (e.g. `+306912345678`)
- `testProfileId`: Sample profile public ID (e.g. `prf_live_sample123`)
- `testWebhookId`: Sample webhook configuration ID (e.g. `whk_sample123`)

> **Note**: The collection includes an automatic **Pre-request Script** that signs requests using HMAC-SHA256 when `authMethod` is set to `hmac`, or formats the `Authorization: Bearer` header when set to `bearer`.

---

## Authentication Schemes

Abelo supports two authentication mechanisms:

### 1. Basic Bearer Token (Recommended for Standard Integrations)
Header:
```http
Authorization: Bearer <key_id>:<key_secret>
```

#### Example cURL:
```bash
curl -X POST "https://api.abelo.ai/v1/messages/send" \
  -H "Authorization: Bearer key_live_abc123:sec_live_xyz789" \
  -H "Content-Type: application/json" \
  -d '{
    "campaign_id": "cmp_order_updates",
    "recipient": {
      "type": "phone_number",
      "value": "+306912345678"
    },
    "params": {
      "first_name": "Nikos",
      "order_number": "ORD-5512",
      "tracking_code": "ORD-5512"
    },
    "client_reference": "order-5512"
  }'
```

### 2. Enterprise HMAC-SHA256 Request Signing
For environments requiring request tamper-proofing and replay defense (such as banking and fintech OTPs).

Headers:
- `X-Abelo-Key-Id`: Your API Key ID
- `X-Abelo-Timestamp`: Current UNIX timestamp (must be within +/- 60 seconds of server time)
- `X-Abelo-Signature`: HMAC-SHA256 hex digest

#### String-to-Sign:
```text
{timestamp}\n{HTTP_METHOD}\n{PATH}\n{SHA256_BODY_HEX}
```

See [`examples/curl/send_viber_hmac.sh`](./examples/curl/send_viber_hmac.sh), [`examples/python/send_hmac.py`](./examples/python/send_hmac.py), or [`examples/node/send_hmac.js`](./examples/node/send_hmac.js) for full code examples.

---

## API Endpoints Overview

### Messages
| Method | Endpoint | Status | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/v1/messages/send` | `200 OK` | Trigger an API message. Recipient lookup supports `phone_number`, `email`, or `public_id`. |

### Profiles
| Method | Endpoint | Status | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/v1/profiles` | `201 Created` | Create a customer profile with channel marketing consent flags |
| `GET` | `/v1/profiles` | `200 OK` | List profiles with pagination and mutually exclusive `phone_number` or `email` search |
| `GET` | `/v1/profiles/{public_id}` | `200 OK` | Retrieve profile details and messaging channel consent |
| `PATCH` | `/v1/profiles/{public_id}` | `200 OK` | Update profile contact details or consent settings |
| `DELETE` | `/v1/profiles/{public_id}` | `204 No Content` | Permanently delete a profile |

### Webhooks
| Method | Endpoint | Status | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/v1/webhooks` | `201 Created` | Create a webhook subscription (signing secret returned once; max 5 active webhooks) |
| `GET` | `/v1/webhooks` | `200 OK` | List all registered webhooks |
| `GET` | `/v1/webhooks/{webhook_id}` | `200 OK` | Retrieve webhook details |
| `PATCH` | `/v1/webhooks/{webhook_id}` | `200 OK` | Update webhook URL, subscribed topics, or active status |
| `DELETE` | `/v1/webhooks/{webhook_id}` | `204 No Content` | Permanently delete a webhook |
| `POST` | `/v1/webhooks/{webhook_id}/rotate-secret` | `200 OK` | Rotate HMAC webhook signing secret (old secret invalidated immediately) |
| `POST` | `/v1/webhooks/test` | `202 Accepted` | Dispatch a signed mock test payload (by `webhook_id` or custom `url`) |

> **Global Webhook Rules**:
> - An organization can have a maximum of **5 active webhooks** at any time.
> - Active webhooks cannot subscribe to overlapping topics.
> - Inactive webhooks do not count toward the limit and are exempt from topic overlap validation.

### System
| Method | Endpoint | Status | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/v1/healthcheck` | `200 OK` | Authenticated health ping returning caller identity |
| `POST` | `/v1/healthcheck` | `200 OK` | Authenticated health ping echoing body value |

---

## Code Examples

Check the [`examples/`](./examples/) folder for complete scripts:
- **cURL**: [`examples/curl/`](./examples/curl/)
- **Python**: [`examples/python/`](./examples/python/)
- **Node.js**: [`examples/node/`](./examples/node/)

---

## OpenAPI Specification

The authoritative OpenAPI 3.1 specification is available in this repository:
- JSON format: [`openapi_v1.json`](./openapi_v1.json)

You can import this file directly into Swagger UI, Redoc, Postman, Insomnia, or code-generation tools (`openapi-generator`, `fern`, etc.).

---

## Official Links & Resources

- **Website**: [https://abelo.ai](https://abelo.ai)
- **Developer Documentation**: [https://docs.abelo.ai](https://docs.abelo.ai)
- **Postman Public Workspace**: [https://www.postman.com/abelo-ai/abelo-public-api](https://www.postman.com/abelo-ai/abelo-public-api)
- **Official Rakuten Viber Partner Directory**: [Abelo Partner Listing](https://www.forbusiness.viber.com/en/messaging-partners/partner/abelo/)
- **Parent Company**: [TREBBBLE S.A.](https://www.trebbble.co)

---

## License

This repository and collection are licensed under the [MIT License](./LICENSE).  
Copyright © 2026 TREBBBLE S.A.
