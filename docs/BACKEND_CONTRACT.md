# Original Stock - Backend API Contract

This document outlines the API specifications required for the "Original Stock" mobile application. The Flutter frontend uses a clean repository layer (`lib/repositories/`) where all network operations are routed through `ApiProductRepository` and `ApiOrderRepository` using Dio.

Switching between local demo data and live backend is controlled by **a single boolean flag** in [`lib/core/service_locator.dart`](file:///d:/Pro/Flutter/Projects/Original-Stock/lib/core/service_locator.dart):
```dart
const bool useMockData = false; // set to false to use live backend
```

Environment variables and endpoint paths are centralized in [`lib/core/env.dart`](file:///d:/Pro/Flutter/Projects/Original-Stock/lib/core/env.dart).

---

## 1. General Standards

- **Base URL:** `https://api.originalstock.com/v1` (configured via `Env.baseUrl`)
- **Content-Type:** `application/json`
- **Authentication:** Bearer token in HTTP header `Authorization: Bearer <token>`
- **Egyptian Currency:** All numeric prices are returned in Egyptian Pounds (EGP) as double/number values. The app formats prices client-side using `egp()`.
- **Egyptian Mobile Numbers:** Egyptian mobile numbers normalized to 11 digits starting with `010`, `011`, `012`, or `015` (e.g. `01012345678`).

---

## 2. Product Endpoints

### 2.1. List Products (Paginated)

Fetches a paginated catalog of products.

- **Method:** `GET`
- **Path:** `/products`
- **Query Parameters:**
  - `page` (optional, integer, default: `1`): The page number.

#### Response (200 OK)
```json
{
  "data": [
    {
      "id": "prod-001",
      "name": "Minimalist Oxford Shirt",
      "image": "https://assets.originalstock.com/products/oxford_shirt_1.jpg",
      "images": [
        "https://assets.originalstock.com/products/oxford_shirt_1.jpg",
        "https://assets.originalstock.com/products/oxford_shirt_2.jpg"
      ],
      "price": 450.0,
      "oldPrice": 600.0,
      "rating": 4.8,
      "category": "Shirts",
      "description": "Crisp Egyptian cotton tailored shirt with modern mandarin collar.",
      "sizes": ["S", "M", "L", "XL", "XXL"],
      "colors": ["Off White", "Heather Grey", "Midnight Black", "Deep Navy"]
    }
  ],
  "meta": {
    "currentPage": 1,
    "totalPages": 5,
    "totalCount": 40
  }
}
```
*(Note: The client also accepts a raw JSON array `[...]` or an object containing `{"data": [...]}` or `{"products": [...]}`.)*

---

### 2.2. Search Products

Searches products by keyword (matches title, description, or category).

- **Method:** `GET`
- **Path:** `/products/search`
- **Query Parameters:**
  - `q` (required, string): Search keyword (e.g. `jacket`, `linen`).

#### Response (200 OK)
```json
{
  "data": [
    {
      "id": "prod-003",
      "name": "Tokyo Winter Jacket",
      "image": "https://assets.originalstock.com/products/jacket_1.jpg",
      "images": [
        "https://assets.originalstock.com/products/jacket_1.jpg"
      ],
      "price": 590.0,
      "oldPrice": 850.0,
      "rating": 4.9,
      "category": "Outerwear",
      "description": "Insulated heavyweight minimalist coat with water-resistant finish.",
      "sizes": ["M", "L", "XL"],
      "colors": ["Midnight Black", "Deep Navy"]
    }
  ]
}
```

---

### 2.3. Get Product Categories

Retrieves available catalog category filter tags.

- **Method:** `GET`
- **Path:** `/categories`

#### Response (200 OK)
```json
{
  "data": [
    "All",
    "Shirts",
    "Outerwear",
    "Knitwear",
    "Shoes",
    "Jeans"
  ]
}
```
*(Note: The client accepts a direct JSON array `["All", "Shirts", ...]` or wrapped under `{"data": [...]}` / `{"categories": [...]}`.)*

---

## 3. Order & Authentication Endpoints

> **Note on Authentication:** The app has **no login/password** accounts. Customers checkout as guests using their WhatsApp mobile number verified via OTP.

### 3.1. Request WhatsApp OTP

Dispatches a 6-digit one-time verification password to the customer's WhatsApp mobile number.

- **Method:** `POST`
- **Path:** `/auth/otp/request`

#### Request Body
```json
{
  "phone": "01012345678"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "OTP verification code sent via WhatsApp."
}
```

---

### 3.2. Verify WhatsApp OTP

Verifies the 6-digit code entered by the user.

- **Method:** `POST`
- **Path:** `/auth/otp/verify`

#### Request Body
```json
{
  "phone": "01012345678",
  "code": "492018"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "verified": true
}
```

#### Error Response (400 Bad Request)
```json
{
  "success": false,
  "message": "Invalid or expired OTP code."
}
```

---

### 3.3. Place Order

Finalizes checkout and submits the order draft.

- **Method:** `POST`
- **Path:** `/orders`

#### Request Body
```json
{
  "items": [
    {
      "productId": "prod-001",
      "productName": "Minimalist Oxford Shirt",
      "productImage": "https://assets.originalstock.com/products/oxford_shirt_1.jpg",
      "size": "L",
      "color": "Off White",
      "quantity": 2,
      "unitPrice": 450.0,
      "totalPrice": 900.0
    }
  ],
  "subtotal": 900.0,
  "delivery": 0.0,
  "total": 900.0,
  "customer": {
    "name": "Omar El-Sayed",
    "phone": "01012345678",
    "address": "14 Gezira St, Zamalek, Cairo, Floor 3, Apt 6",
    "email": "omar@example.com"
  }
}
```

#### Response (201 Created or 200 OK)
```json
{
  "data": {
    "id": "ord-9812401",
    "orderNumber": "#OS-74291",
    "items": [
      {
        "productId": "prod-001",
        "productName": "Minimalist Oxford Shirt",
        "productImage": "https://assets.originalstock.com/products/oxford_shirt_1.jpg",
        "size": "L",
        "color": "Off White",
        "quantity": 2,
        "unitPrice": 450.0,
        "totalPrice": 900.0
      }
    ],
    "subtotal": 900.0,
    "delivery": 0.0,
    "total": 900.0,
    "customer": {
      "name": "Omar El-Sayed",
      "phone": "01012345678",
      "address": "14 Gezira St, Zamalek, Cairo, Floor 3, Apt 6",
      "email": "omar@example.com"
    },
    "status": "Confirmed",
    "createdAt": "2026-11-09T02:40:00.000Z"
  }
}
```

---

### 3.4. Get Orders for Customer

Retrieves the list of previous orders matching a customer's phone number to populate the **Profile -> My orders** view.

- **Method:** `GET`
- **Path:** `/orders`
- **Query Parameters:**
  - `phone` (optional, string): The customer's normalized Egyptian mobile number (e.g. `01012345678`).

#### Response (200 OK)
```json
{
  "data": [
    {
      "id": "ord-9812401",
      "orderNumber": "#OS-74291",
      "items": [
        {
          "productId": "prod-001",
          "productName": "Minimalist Oxford Shirt",
          "productImage": "https://assets.originalstock.com/products/oxford_shirt_1.jpg",
          "size": "L",
          "color": "Off White",
          "quantity": 2,
          "unitPrice": 450.0,
          "totalPrice": 900.0
        }
      ],
      "subtotal": 900.0,
      "delivery": 0.0,
      "total": 900.0,
      "customer": {
        "name": "Omar El-Sayed",
        "phone": "01012345678",
        "address": "14 Gezira St, Zamalek, Cairo, Floor 3, Apt 6",
        "email": "omar@example.com"
      },
      "status": "Shipped",
      "createdAt": "2026-11-08T18:30:00.000Z"
    }
  ]
}
```

---

## 4. Status Values

The frontend supports the following standard order status strings:
- `"Confirmed"`
- `"Processing"`
- `"Shipped"`
- `"Delivered"`
- `"Cancelled"`

