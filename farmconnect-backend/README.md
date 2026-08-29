# FarmConnect

A digital marketplace connecting farmers directly with buyers (shops, retailers,
wholesalers), based on the project abstract from Group 02.

Because plain Java cannot run natively on iOS, this project is split into two parts,
as agreed:

1. **`farmconnect-backend/`** — Java 17 + Spring Boot REST API. All business logic
   (farmer registration, product listings, orders, assistance requests) lives here.
2. **`farmconnect_app/`** — Flutter app (Dart). One codebase compiles to both a
   native Android APK and a native iOS app, and talks to the Java backend over REST.

## Architecture

```
[ Flutter app ] --HTTP/JSON--> [ Spring Boot API ] --JPA--> [ Database ]
  (Android/iOS)                  (Java 17)                   (H2 for dev,
                                                                MySQL/Postgres
                                                                for production)
```

## 1. Running the backend

Requirements: Java 17+ and Maven.

```bash
cd farmconnect-backend
mvn spring-boot:run
```

The API starts on `http://localhost:8080`. An in-memory H2 database is used by
default (data resets on restart) — swap the datasource in
`src/main/resources/application.properties` for MySQL/Postgres before deploying.

### API endpoints

| Method | Path                              | Purpose                                   |
|--------|-----------------------------------|--------------------------------------------|
| POST   | /api/farmers                      | Register a farmer                          |
| GET    | /api/farmers/{id}                 | Get farmer's public info                   |
| POST   | /api/products                     | List a product (farmer)                    |
| GET    | /api/products                     | Browse catalog (buyer) — no farmer PII     |
| POST   | /api/orders                       | Place an order (buyer)                     |
| PATCH  | /api/orders/{id}/confirm          | Confirm order & deduct stock (farmer)      |
| PATCH  | /api/orders/{id}/reject           | Reject an order (farmer)                   |
| GET    | /api/orders/farmer/{farmerId}     | Orders awaiting a farmer's action          |
| POST   | /api/assistance                   | Submit a cultivation help request          |
| GET    | /api/assistance/farmer/{farmerId} | A farmer's own requests                    |
| GET    | /api/assistance/open              | Open requests (for a support/expert view)  |

Privacy note: `GET /api/products` returns `ProductCatalogDTO`, which deliberately
omits the farmer's name and phone number — only product info, price, and general
location are visible to buyers, per the abstract's privacy requirement.

## 2. Running the Flutter app

Requirements: Flutter SDK installed (`flutter doctor` should pass).

```bash
cd farmconnect_app
flutter pub get
flutter run
```

Before running, check `lib/services/api_service.dart` and set `baseUrl` for your
target:
- Android emulator: `http://10.0.2.2:8080/api` (default — routes to your host machine)
- iOS simulator: `http://localhost:8080/api`
- Physical device: `http://<your-computer's-LAN-IP>:8080/api`

To build real installables:
```bash
flutter build apk          # Android
flutter build ios          # iOS (requires a Mac + Xcode, plus an Apple
                            # developer account to install on a real device)
```

## What's implemented (starter scope)

- Farmer registration
- Product listing (name, quantity, price)
- Buyer catalog browsing with privacy-safe farmer info
- Order placement, confirmation/rejection, and stock deduction
- Cultivation assistance requests

## Suggested next steps

- Add authentication (e.g. Spring Security + JWT) instead of passing farmerId
  around directly — currently there's no login, just a generated ID.
- Push notifications for order confirmations (Firebase Cloud Messaging works
  well with Flutter).
- Image uploads for product listings (multipart upload endpoint + S3/Cloud
  storage).
- Deploy the backend (Render, Railway, AWS, etc.) and point the Flutter app's
  `baseUrl` at the live URL before distributing the app.
