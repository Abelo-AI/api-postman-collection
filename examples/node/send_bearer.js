// Send a Viber message using Abelo API with Bearer token authentication
// Requires Node.js 18+ (native fetch support)
const API_KEY_ID = process.env.ABELO_KEY_ID || "YOUR_API_KEY_ID";
const API_KEY_SECRET = process.env.ABELO_KEY_SECRET || "YOUR_API_KEY_SECRET";

async function sendMessage() {
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
      order_number: "ORD-7712",
      tracking_code: "TR-7712"
    },
    client_reference: "order-7712"
  };

  const response = await fetch("https://api.abelo.ai/v1/messages/send", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${API_KEY_ID}:${API_KEY_SECRET}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  const data = await response.json();
  console.log("Status:", response.status);
  console.log("Response:", data);
}

sendMessage().catch(console.error);
