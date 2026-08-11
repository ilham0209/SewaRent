# SewaRent — Mobile Application

> **SewaRent** is a rental-property mobile application built with Flutter and Dart.
>
> This document is the main project reference for the **mobile application (Mobile Ver)**. It describes the product scope, features, architecture, file structure, conventions, integration boundaries, and development roadmap.

---

## 1. Project Overview

SewaRent allows tenants to discover rental properties, view property details, save favourites, submit rental requests, and manage their profile.

Landlords can manage rental properties and review rental requests.

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
| Backend | ASP.NET Core Web API |
| Backend Version | .NET 10 |
| ORM | Entity Framework Core |
| Database | Microsoft SQL Server |
| Database Tool | SQL Server Management Studio (SSMS) |
| Authentication | JWT Bearer |
| API Format | REST + JSON |
| API Transport | HTTPS |
| Mobile Architecture | Feature-first + lightweight Clean Architecture |
| Source Control | Git / GitHub |

---

## 3. User Roles

### Tenant

A tenant can:

- Register
- Login
- Browse properties
- Search properties
- Filter properties
- View property details
- View property images
- Save/unsave favourites
- Submit rental requests
- View rental request status
- Cancel eligible rental requests
- Manage profile

### Landlord

A landlord can:

- Register
- Login
- Manage their properties
- Add property
- Edit property
- Remove/deactivate property
- Upload property images
- View rental requests
- Accept/reject rental requests
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
- Recommended properties
- Recently viewed properties (planned)
- Popular properties (planned)
- Property categories
- Quick access to favourites

---

### 4.3 Property Search

Users can search rental properties using:

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

### 4.9 Profile

Users can:

- View profile
- Edit profile
- Update phone number
- Update profile image (planned)
- Change password
- Logout

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

Profile
 ├── Edit Profile
 ├── Change Password
 └── Logout
```

Suggested bottom navigation:

```text
[ Home ] [ Favourites ] [ Requests ] [ Profile ]
```

Landlord navigation may later use:

```text
[ Dashboard ] [ Properties ] [ Requests ] [ Profile ]
```

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
│   │   ├── auth/
│   │   ├── home/
│   │   ├── property/
│   │   ├── favourite/
│   │   ├── rental_request/
│   │   └── profile/
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

- [ ] Create SewaRent API
- [ ] Configure MSSQL
- [ ] Configure EF Core
- [ ] Create database schema
- [ ] Implement authentication
- [ ] Implement property APIs
- [ ] Implement favourite APIs
- [ ] Implement rental request APIs

### Phase 4 — API Integration

- [ ] Configure API client
- [ ] Connect authentication
- [ ] Connect property listing
- [ ] Connect property details
- [ ] Connect favourites
- [ ] Connect rental requests
- [ ] Connect profile

### Phase 5 — Advanced Features

- [ ] Image upload
- [ ] Maps/location
- [ ] Notifications
- [ ] Landlord dashboard
- [ ] Reporting
- [ ] Analytics
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
| `DATABASE.md` | Database tables and feature-to-table mapping |

These documents should be kept updated as the system evolves.

---

## 16. AI Agent Development Rules

AI coding agents working on SewaRent should:

1. Read `README.md` before changing architecture.
2. Read `INTEGRATION.md` before changing API-related code.
3. Read `DATABASE.md` before proposing database-related changes.
4. Never make Flutter connect directly to MSSQL.
5. Never invent API endpoints if they are not documented.
6. Never invent database columns when implementing API integration.
7. Keep feature-specific code inside the relevant feature folder.
8. Avoid moving files unless there is a clear architectural reason.
9. Preserve existing naming conventions.
10. Update documentation when adding or changing features, endpoints, or database relationships.
11. Do not introduce a new package when existing project functionality is sufficient.
12. Do not perform broad refactors unrelated to the requested task.

---

## 17. Current Status

**Project:** SewaRent  
**Platform:** Mobile  
**Framework:** Flutter  
**Language:** Dart  
**Backend:** Planned ASP.NET Core Web API .NET 10  
**Database:** Planned Microsoft SQL Server  
**Current Stage:** Phase 1 — Flutter Foundation

---

## 18. Future Repository Structure

The complete solution is expected to become:

```text
SewaRent/
│
├── SewaRent.Mobile/
│   └── Flutter application
│
├── SewaRent.API/
│   └── ASP.NET Core Web API
│
├── SewaRent.Database/
│   └── SQL/database scripts (if required)
│
└── docs/
    ├── README.md
    ├── INTEGRATION.md
    └── DATABASE.md
```

The mobile application remains independently deployable from the backend.
