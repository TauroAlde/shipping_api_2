# Shipping API Documentation

## Overview

This API integrates with Skydropx to provide shipment quotation, label generation, shipment tracking, and webhook event processing.

The system follows a **service-oriented architecture** where controllers orchestrate requests, services communicate with external APIs, and models persist data.

---

# 1. Main Endpoints

## Create Quotation

Creates a shipment quotation.

**Endpoint**

```
POST /quotations
```

**Description**

Requests shipping rates from Skydropx based on origin, destination, and parcel information.

---

## Create Shipment

Creates a shipping label using a selected rate.

**Endpoint**

```
POST /shipments
```

**Description**

Uses the `rate_id` returned from the quotation to generate a shipment.

---

## List Shipments

```
GET /shipments
```

Returns all shipments stored in the system.

---

## Get Shipment

```
GET /shipments/:id
```

Returns a single shipment with its tracking information.

---

## Download Label

```
GET /shipments/:id/label
```

Redirects to the shipping label URL returned by Skydropx.

---

## Shipment Tracking

```
GET /shipments/:id/tracking
```

Returns the tracking status for a shipment.

Example response:

```json
{
  "carrier": "DHL",
  "tracking_number": "234234234233",
  "status": "in_transit"
}
```

---

## Webhook Endpoint

```
POST /webhooks/skydropx
```

Receives shipment status updates from Skydropx.

Example webhook payload:

```json
{
  "event": "shipment.updated",
  "data": {
    "attributes": {
      "id": "shipment_id",
      "tracking_status": "in_transit"
    }
  }
}
```

The webhook triggers a background job that updates shipment status and stores event history.

---

# 2. Project Architecture

```
app
├── controllers
│   ├── quotations_controller.rb
│   ├── shipments_controller.rb
│   └── webhooks_controller.rb
│
├── services
│   ├── skydropx_auth_service.rb
│   └── skydropx_service.rb
│
├── jobs
│   └── process_skydropx_webhook_job.rb
│
├── models
│   ├── shipment.rb
│   └── shipment_event.rb
```

### Responsibilities

**Controllers**

* Handle HTTP requests
* Validate payloads
* Call services

**Services**

* Handle communication with Skydropx API
* Manage authentication and requests

**Jobs**

* Process webhook events asynchronously

**Models**

* Persist shipments and event history

---

# 3. Shipment Lifecycle

```
Client
   ↓
POST /quotations
   ↓
Skydropx returns shipping rates
   ↓
User selects a rate
   ↓
POST /shipments
   ↓
Shipment created in Skydropx
   ↓
Shipment stored in database
   ↓
Label URL returned
   ↓
Skydropx sends webhook events
   ↓
Webhook updates shipment status
   ↓
Shipment events stored for history
```

---

# 4. Shipment Event History

Each status update from the webhook is stored in `shipment_events`.

Example:

| shipment_id | status     |
| ----------- | ---------- |
| 1           | created    |
| 1           | picked_up  |
| 1           | in_transit |
| 1           | delivered  |

This provides a full tracking timeline.

---

# 5. Error Handling

The API returns structured errors when Skydropx returns an error.

Example:

```json
{
  "error": "Skydropx API error",
  "status": 422,
  "details": {
    "postal_code": ["invalid"]
  }
}
```

HTTP status codes used:

| Code | Meaning               |
| ---- | --------------------- |
| 200  | Success               |
| 201  | Resource created      |
| 422  | Validation error      |
| 500  | Internal server error |

---

# 6. Background Jobs

Webhook processing uses ActiveJob.

Example flow:

```
Webhook received
   ↓
WebhooksController
   ↓
ProcessSkydropxWebhookJob
   ↓
Shipment updated
   ↓
ShipmentEvent created
```

This ensures webhooks are processed asynchronously and safely.

---

# 7. Environment Variables

Required environment variables:

```
SKYDROPX_BASE_URL
SKYDROPX_CLIENT_ID
SKYDROPX_CLIENT_SECRET
```

These are used to authenticate with the Skydropx API.

---

# 8. Future Improvements

Planned enhancements:

* Shipment pagination
* Shipment filtering by status
* Idempotency for shipment creation
* API authentication
* Automated tests
* API documentation (OpenAPI / Swagger)

---
