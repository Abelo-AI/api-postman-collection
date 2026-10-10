// Send a Viber message using Abelo API with Enterprise HMAC-SHA256 request signing
// Requires Node.js 18+ (native fetch support)
const crypto = require("crypto");

const API_KEY_ID = process.env.ABELO_KEY_ID || "YOUR_API_KEY_ID";
const HMAC_SECRET = process.env.ABELO_HMAC_SECRET || "YOUR_HMAC_SECRET";

async function sendMessage() {
  const path = "/v1/messages/send";
  const method = "POST";
  const timestamp = Math.floor(Date.now() / 1000).toString();

  const payload = {
    campaign_id: process.env.ABELO_CAMPAIGN_ID || "YOUR_CAMPAIGN_ID",
    // Recipient can be identified by phone_number, email, or public_id:
    // 1. Phone number: { type: "phone_number", value: "+306912345678" }
    // 2. Email:        { type: "email", value: "customer@example.com" }
    // 3. Public ID:    { type: "public_id", value: "prf_..." }
    recipient: {
      type: "phone_number",
      value: process.env.RECIPIENT_PHONE || "+306912345678"
    },
    params: {
      first_name: "Elena",
      pin: "441920"
    },
    client_reference: "auth-otp-441920"
  };

  const rawBody = JSON.stringify(payload);
  const bodyHash = crypto.createHash("sha256").update(rawBody).digest("hex");

  // Canonical string-to-sign: {timestamp}\n{method}\n{path}\n{body_hash}
  const stringToSign = `${timestamp}\n${method}\n${path}\n${bodyHash}`;
  const signature = crypto.createHmac("sha256", HMAC_SECRET).update(stringToSign).digest("hex");

  const response = await fetch(`https://api.abelo.ai${path}`, {
    method: "POST",
    headers: {
      "X-Abelo-Key-Id": API_KEY_ID,
      "X-Abelo-Timestamp": timestamp,
      "X-Abelo-Signature": signature,
      "Content-Type": "application/json"
    },
    body: rawBody
  });

  const data = await response.json();
  console.log("Status:", response.status);
  console.log("Response:", data);
}

sendMessage().catch(console.error);
