# SewaRent — Mobile Application

> **SewaRent** is a rental-property mobile application built with Flutter and Dart.
>
> This document is the main project reference for the **mobile application (Mobile Ver)**. It describes the product scope, features, architecture, file structure, conventions, integration boundaries, and development roadmap.

---

## 1. Project Overview

SewaRent allows tenants to discover rental properties, view property details, save favourites, submit rental requests, view/pay invoices, and manage their profile.

Landlords can manage rental properties, review rental requests, invoice tenants, verify payments, and send payment reminders.

**Business model:** SewaRent is a landlord-managed tenant system, not an open cross-landlord marketplace. Each tenant links to exactly one landlord (via a landlord-shared **landlord code**) and only ever sees that landlord's properties. Landlords use the system to manage their own tenants end-to-end, including monthly rent invoicing, payment reminders, and payment verification. This is a foundational rule the mobile app must reflect in UI/UX (e.g. an unlinked tenant sees a "link to your landlord" prompt instead of a property list).

### Main principle

The Flutter mobile application **never connects directly to MSSQL**.

```text
Flutter Mobile
      |
      | HTTPS / REST / JSON
      v
SewaRent API
      |
      | EF Core
      v
Microsoft SQL Server
```

The API is responsible for authentication, authorization, business rules, database access, and data validation.

---

## 2. Technology Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter |
| Language | Dart |
| Android IDE | Android Studio |
| Backend | ASP.NET Core Web API (`SewaRent_Api` repository) |
| Backend Version | .NET 10 |
| ORM | Entity Framework Core |
| Database | Microsoft SQL Server — single database `SewaRent` |
| Database Tool | SQL Server Management Studio (SSMS) |
| Authentication | JWT Bearer |
| API Format | REST + JSON |
| API Transport | HTTPS |
| API Response Envelope | `{ success, message, data }` — see `INTEGRATION.md` §12 |
| Mobile Architecture | Feature-first + lightweight Clean Architecture |
| Source Control | Git / GitHub |

> The backend lives in a separate repository (`SewaRent_Api`) with its own `README.md` / `INTEGRATION.md` / `DATABASE.md` / `CODING_STYLE.md`. This mobile repository's documentation must stay consistent with the API's documented contract — see §16 AI Agent Development Rules.

---

## 3. User Roles

### Tenant

A tenant can:

- Register
- Login
- Link to a landlord using the landlord's shared **landlord code**
- Browse, search, and filter properties **belonging only to their linked landlord** (SewaRent is a landlord-managed tenant system, not an open cross-landlord marketplace)
- View property details and images
- Save/unsave favourites
- Submit rental requests
- View rental request status
- Cancel eligible rental requests
- View invoices and mark "Payment Already Made"
- View/download payment receipts
- View own payment dashboard (current invoice, history)
- Manage profile

### Landlord

A landlord can:

- Register
- Login
- Receive an auto-generated, unique **landlord code** (shown on their profile) to share with tenants
- Set/update bank details (bank name, account number) used for rent transfer
- Manage their properties (add, edit, deactivate, upload images)
- View incoming rental requests
- Accept/reject rental requests
- Configure a monthly scheduled payment reminder (auto-generates an invoice) per tenant
- Send manual payment reminders at any time (no invoice generated)
- Review and accept/reject a tenant's payment claim (reject requires a reason)
- View a dashboard summarising payment status across all tenants
- Manage profile

### Administrator

Administrator functionality is planned for the backend/admin side.

Possible responsibilities:

- Manage users
- Manage properties
- Manage property categories/types
- Review reported content
- Manage rental requests
- View system statistics
- Manage system configuration

---

## 4. Mobile Features

### 4.1 Authentication

- Splash screen
- Login
- Registration
- Logout
- JWT token handling
- Session persistence
- Authentication error handling
- Role-aware navigation
- Unauthorized-session handling

Planned screens:

```text
Splash
Login
Register
```

---

### 4.2 Home

The Home screen is the main tenant entry point.

Features:

- Greeting
- Search
- Recommended properties (scoped to the tenant's linked landlord)
- Recently viewed properties (planned)
- Popular properties (planned)
- Property categories
- Quick access to favourites

**Unlinked-tenant state:** if the authenticated tenant has no linked landlord yet (`landlordId == null`), Home must show a "link to your landlord" empty state prompting for the landlord code instead of an empty property grid — see §4.2a.

---

### 4.2a Landlord Linking

Tenant-only, part of onboarding (alongside Login/Register).

Features:

- Prompt for landlord code after registration if not yet linked
- Submit landlord code to link account
- Show friendly error if the code is invalid/not found
- Re-prompt from a persistent empty state anywhere property data would otherwise show, until linked

Landlord-only (shown on the landlord's own Profile screen):

- Display the landlord's own auto-generated landlord code with a share/copy action

---

### 4.3 Property Search

Properties are always scoped to the tenant's linked landlord — this is not an open cross-landlord marketplace. Users can search rental properties using:

- Keyword
- Location
- Minimum rent
- Maximum rent
- Property type
- Number of bedrooms
- Number of bathrooms
- Furnished/unfurnished
- Availability

Sorting:

- Lowest rent
- Highest rent
- Newest
- Most relevant

---

### 4.4 Property Details

Property details should display:

- Property title
- Description
- Monthly rental
- Location
- Address
- Property type
- Bedrooms
- Bathrooms
- Parking spaces
- Furnishing status
- Availability status
- Property images
- Landlord information
- Favourite status
- Rental request action

---

### 4.5 Favourites

Tenants can:

- Add property to favourites
- Remove property from favourites
- View all favourite properties
- Open property details from favourites

---

### 4.6 Rental Requests

Tenants can:

- Submit a rental request
- View submitted requests
- View request details
- View status
- Cancel eligible requests

Possible statuses:

```text
Pending
Approved
Rejected
Cancelled
Expired
```

---

### 4.7 Landlord Property Management

Landlords can:

- View their properties
- Add property
- Edit property
- Deactivate property
- Add/remove property images
- View property status

---

### 4.8 Landlord Rental Requests

Landlords can:

- View incoming rental requests
- View tenant details
- View requested property
- Accept request
- Reject request

---

### 4.9 Billing & Invoices

Invoices are only ever generated by the landlord's scheduled payment reminder — there is no online payment gateway; tenants pay via manual bank transfer and landlords verify manually.

Tenant can:

- View current invoice and invoice history
- View invoice details (rent + optional utility line items, total, due date, landlord's bank details)
- Mark an invoice "Payment Already Made" (no proof-of-payment upload required at this stage)
- View/download an invoice PDF
- View/download a receipt PDF once payment is accepted

Landlord can:

- View invoices across all tenants
- Accept a tenant's payment claim (auto-generates a receipt)
- Reject a tenant's payment claim with a mandatory reason (invoice reverts to `Unpaid`; same invoice is reused, no duplicate is generated)
- View/download invoice and receipt PDFs

Possible invoice statuses:

```text
Unpaid
PaymentClaimed
Paid
```

---

### 4.10 Payment Notifications

Landlord can:

- Configure a monthly scheduled reminder (day of month) per tenant/rental request — this auto-generates an invoice when it fires
- Send a manual reminder at any time (does not generate an invoice)
- Receive an overdue notice when an invoice passes its due date unpaid

Tenant can:

- View reminders sent by their landlord (Scheduled / Manual)

Possible notification types:

```text
Scheduled  (tenant, auto-generates an invoice)
Manual     (tenant, no invoice generated)
Overdue    (landlord, sent when an invoice passes its due date unpaid)
```

---

### 4.11 Dashboard

Tenant dashboard:

- Current invoice summary (status, total, due date)
- Payment history with links to receipts

Landlord dashboard:

- Collections summary for the current period
- Overdue invoice count
- Per-tenant payment status list

---

### 4.12 Profile

Users can:

- View profile
- Edit profile
- Update phone number
- Update profile image (planned)
- Change password
- Logout

Tenant additionally:

- Link to a landlord via landlord code (if not already linked)

Landlord additionally:

- View their own landlord code (to share with tenants)
- Set/update bank details (bank name, account number) used for rent transfer

---

## 5. Navigation

Tenant navigation:

```text
Home
 ├── Search
 ├── Property Details
 └── Favourites

Requests
 └── Request Details

Invoices
 └── Invoice Details

Profile
 ├── Edit Profile
 ├── Change Password
 ├── Link to Landlord
 └── Logout
```

Suggested bottom navigation (tenant):

```text
[ Home ] [ Favourites ] [ Requests ] [ Invoices ] [ Profile ]
```

Landlord navigation:

```text
[ Dashboard ] [ Properties ] [ Requests ] [ Invoices ] [ Profile ]
```

Landlord `Profile` additionally surfaces the landlord code and bank details; landlord `Invoices` additionally surfaces payment-claim accept/reject actions and reminder configuration.

---

## 6. Initial Mobile File Structure

```text
sewa_rent/
│
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── theme.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── utils/
│   │   └── widgets/
│   │
│   ├── features/
│   │   ├── auth/               # register, login, logout, link_landlord
│   │   ├── home/
│   │   ├── property/
│   │   ├── favourite/
│   │   ├── rental_request/
│   │   ├── billing/            # invoices, payment claim, receipts
│   │   ├── payment_notification/  # scheduled/manual reminders, overdue notices
│   │   ├── dashboard/          # tenant + landlord dashboard summaries
│   │   └── profile/            # incl. bank details (landlord)
│   │
│   └── shared/
│       ├── models/
│       ├── enums/
│       └── widgets/
│
├── test/
│
├── integration_test/
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

### Feature structure

When a feature becomes sufficiently complex, use:

```text
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── pages/
    ├── widgets/
    └── controllers/
```

Do not create every subfolder prematurely. Add them when the feature needs them.

---

## 7. Folder Responsibilities

### `main.dart`

Application entry point only.

### `app/`

Application-level configuration:

- App root
- Routing
- Theme

### `core/`

Cross-feature technical functionality:

- API client
- Storage
- Constants
- Utility functions
- Generic reusable widgets

### `features/`

Business features.

Examples:

```text
features/auth
features/property
features/favourite
features/rental_request
features/billing
features/payment_notification
features/dashboard
```

### `shared/`

Reusable business-neutral models, enums, and widgets.

Do not put feature-specific components here unless they are genuinely shared.

### `assets/`

Static application assets.

---

## 8. Naming Conventions

Use Dart/Flutter conventions.

### Files

Use `snake_case`:

```text
property_card.dart
property_detail_page.dart
api_client.dart
```

### Classes

Use `PascalCase`:

```dart
class PropertyCard {}
class PropertyDetailPage {}
class ApiClient {}
```

### Variables and methods

Use `camelCase`:

```dart
final propertyName = 'House A';

Future<void> loadProperties() async {}
```

### Constants

Prefer descriptive `camelCase` constants or project conventions:

```dart
const apiBaseUrl = '...';
```

---

## 9. State Management

The exact state-management package will be selected before implementation of complex features.

Requirements:

- Clear separation between UI and state
- Testable business logic
- Avoid excessive global state
- Avoid putting API calls directly inside widgets
- Keep feature state close to its feature

The selected state-management approach must be documented in this README once finalized.

---

## 10. API Integration Principle

Flutter communicates only with the SewaRent API.

Example:

```text
PropertyPage
      |
      v
PropertyController
      |
      v
PropertyRepository
      |
      v
PropertyRemoteDataSource
      |
      v
ApiClient
      |
      | HTTPS
      v
SewaRent.API
```

The API then communicates with MSSQL.

---

## 11. Error Handling

The mobile application should handle:

- No internet
- Request timeout
- HTTP 400
- HTTP 401
- HTTP 403
- HTTP 404
- HTTP 409
- HTTP 422
- HTTP 500
- Unexpected API response
- Invalid JSON
- Token expiration

User-facing messages should be friendly and should not expose internal server/database errors.

---

## 12. Security Rules

Never:

- Store MSSQL credentials in Flutter
- Connect directly to MSSQL from Flutter
- Hard-code JWT secrets
- Store sensitive credentials in source control
- Log passwords
- Log JWT tokens
- Trust role information from the UI alone

The API must enforce authorization.

Flutter only controls what UI is shown; the backend remains the security boundary.

---

## 13. Development Roadmap

### Phase 1 — Flutter Foundation

- [x] Create Flutter project
- [ ] Create project file structure
- [ ] Create app root
- [ ] Configure theme
- [ ] Configure routing
- [ ] Create initial navigation
- [ ] Build Home UI
- [ ] Build property card
- [ ] Build property details UI

### Phase 2 — Mock Data

- [ ] Property model
- [ ] Mock property list
- [ ] Search
- [ ] Filters
- [ ] Favourites
- [ ] Rental request mock flow

### Phase 3 — Backend

> Tracked in the `SewaRent_Api` repository. As of this document, the API is at **Phase 1/2 — Foundation + domain scaffolding**: project/EF Core/migrations/CORS/OpenAPI configured; domain entities (User, Property, Favourite, RentalRequest, Billing, Notification) are being scaffolded. No endpoint is implemented yet — all endpoints in `INTEGRATION.md` are `[PLANNED]` until the API repo says otherwise.

- [ ] Create SewaRent API
- [ ] Configure MSSQL
- [ ] Configure EF Core
- [ ] Create database schema
- [ ] Implement authentication
- [ ] Implement landlord-code generation and tenant linking
- [ ] Implement property APIs (scoped to linked landlord)
- [ ] Implement favourite APIs
- [ ] Implement rental request APIs
- [ ] Implement billing/invoice APIs
- [ ] Implement payment notification APIs
- [ ] Implement dashboard APIs

### Phase 4 — API Integration

- [ ] Configure API client
- [ ] Connect authentication
- [ ] Connect landlord linking (landlord code)
- [ ] Connect property listing (landlord-scoped)
- [ ] Connect property details
- [ ] Connect favourites
- [ ] Connect rental requests
- [ ] Connect profile (incl. bank details for landlord)
- [ ] Connect billing/invoices
- [ ] Connect payment notifications
- [ ] Connect dashboard

### Phase 5 — Advanced Features

- [ ] Image upload
- [ ] Maps/location
- [ ] Generic in-app notifications (distinct from payment reminders)
- [ ] Reporting
- [ ] Analytics
- [ ] Online payment gateway (future — current design assumes manual bank transfer)
- [ ] Production deployment

---

## 14. Environment Configuration

Different environments should be supported:

```text
Development
Testing
Production
```

The API base URL must not be duplicated throughout the application.

Example concept:

```text
Development:
https://localhost:xxxx

Testing:
https://sewarent-api-test.example.com

Production:
https://sewarent-api.example.com
```

Actual URLs will be configured later.

---

## 15. Documentation

The project documentation is split into:

| Document | Purpose |
|---|---|
| `README.md` | Mobile project overview and architecture |
| `INTEGRATION.md` | Mobile ↔ API integration contract |
| `DATABASE.md` | Database tables and feature-to-table mapping (reference only — mobile never accesses the database directly) |
| `CODING_STYLE.md` | Dart/Flutter coding style and clean-code rules |

These documents should be kept updated as the system evolves, and should be kept consistent with the equivalent documents in the `SewaRent_Api` repository.

---

## 16. AI Agent Development Rules

AI coding agents working on SewaRent should:

1. Read `README.md` before changing architecture.
2. Read `INTEGRATION.md` before changing API-related code.
3. Read `DATABASE.md` before proposing database-related changes.
4. Read `CODING_STYLE.md` before generating significant Flutter code.
5. Never make Flutter connect directly to MSSQL.
6. Never invent API endpoints if they are not documented in `INTEGRATION.md`.
7. Never invent database columns when implementing API integration.
8. Keep feature-specific code inside the relevant feature folder.
9. Avoid moving files unless there is a clear architectural reason.
10. Preserve existing naming conventions.
11. Update documentation when adding or changing features, endpoints, or database relationships.
12. Do not introduce a new package when existing project functionality is sufficient.
13. Do not perform broad refactors unrelated to the requested task.
14. Never derive a tenant's `landlordId` locally or send a raw `landlordId` to the API — always submit the landlord's `landlordCode` and let the API resolve it server-side (see `INTEGRATION.md` §13).
15. Treat an invoice's snapshotted bank details (`bankName`/`bankAccountNumber` on the invoice response) as authoritative for that invoice, even if the landlord's live profile bank details later change — never substitute the profile's live values on an already-issued invoice.
16. This document must stay consistent with the API's own `README.md`/`INTEGRATION.md`/`DATABASE.md` in the `SewaRent_Api` repository — if the two disagree, treat the API repo as the source of truth for what's actually implemented, and flag the mismatch rather than guessing.

---

## 17. Current Status

**Project:** SewaRent  
**Platform:** Mobile  
**Framework:** Flutter  
**Language:** Dart  
**Backend:** `SewaRent_Api` — ASP.NET Core Web API .NET 10, currently Phase 1/2 (foundation + domain scaffolding; no endpoints implemented yet)  
**Database:** Microsoft SQL Server — single database `SewaRent` (planned schema, not yet migrated)  
**Current Stage:** Phase 1 — Flutter Foundation (building UI against the documented API contract ahead of backend implementation; treat all endpoints as `[PLANNED]` per `INTEGRATION.md` §22 until confirmed otherwise)

---

## 18. Future Repository Structure

The complete solution is expected to become:

```text
SewaRent/
│
├── SewaRent.Mobile/
│   └── Flutter application (this repository)
│
├── SewaRent_Api/
│   └── ASP.NET Core Web API
│
├── SewaRent.Database/
│   └── SQL/database scripts (if required)
│
└── docs/
    ├── README.md
    ├── INTEGRATION.md
    ├── DATABASE.md
    └── CODING_STYLE.md
```

The mobile application remains independently deployable from the backend.