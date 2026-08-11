# SewaRent — Database Specification

> **Database:** Microsoft SQL Server  
> **ORM:** Entity Framework Core  
> **Database access:** SewaRent API only
>
> The Flutter application must never connect directly to this database.

---

## 1. Database Architecture

```text
SewaRent Mobile
      |
      | HTTPS
      v
SewaRent API
      |
      | EF Core
      v
Microsoft SQL Server
```

The API is the only application component that directly accesses MSSQL.

---

## 2. Database Design Principles

1. Use integer or `bigint` surrogate primary keys unless there is a clear reason otherwise.
2. Use foreign keys for relationships.
3. Use `datetime2` for timestamps.
4. Use `decimal` for monetary values.
5. Do not store passwords in plain text.
6. Passwords should be stored as secure password hashes.
7. Use status fields where business entities have lifecycle states.
8. Prefer soft deactivation for business records that must remain historically traceable.
9. Add indexes for common search/filter fields.
10. Database changes must be created through EF Core migrations or the project's approved database migration process.
11. The API owns business rules; the database should still enforce relational integrity.
12. Never expose database credentials to Flutter.

---

## 3. Core Tables

Initial planned tables:

```text
Users
Roles
UserRoles
Properties
PropertyTypes
PropertyImages
Favourites
RentalRequests
RentalRequestStatuses
```

Optional/future tables:

```text
PropertyAmenities
Amenities
PropertyAmenitiesMap
UserAddresses
Notifications
RefreshTokens
AuditLogs
Reports
```

---

# 4. Users

## Table: `Users`

Stores application users.

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | bigint | PK |
| FullName | nvarchar(150) | Required |
| Email | nvarchar(255) | Required, unique |
| PasswordHash | nvarchar(500) | Required |
| PhoneNumber | nvarchar(30) | Nullable |
| ProfileImageUrl | nvarchar(1000) | Nullable |
| IsActive | bit | Required |
| CreatedAt | datetime2 | Required |
| UpdatedAt | datetime2 | Nullable |

### Relationships

```text
Users
 ├── UserRoles
 ├── Properties (landlord)
 ├── Favourites
 └── RentalRequests (tenant)
```

### Used by

- Register
- Login
- Get profile
- Update profile
- Change password
- Authentication
- Authorization
- Rental request ownership

---

# 5. Roles

## Table: `Roles`

Stores system roles.

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | int | PK |
| Name | nvarchar(50) | Required, unique |
| Description | nvarchar(255) | Nullable |

Initial roles:

```text
Tenant
Landlord
Admin
```

### Used by

- Registration
- Authorization
- Role-based UI
- Role-based API access

---

# 6. UserRoles

## Table: `UserRoles`

Many-to-many relationship between users and roles.

### Columns

| Column | Type | Notes |
|---|---|---|
| UserId | bigint | PK/FK |
| RoleId | int | PK/FK |

### Relationships

```text
Users 1 ─── * UserRoles * ─── 1 Roles
```

### Used by

- Login claims
- Authorization
- Tenant/landlord/admin access

---

# 7. PropertyTypes

## Table: `PropertyTypes`

Defines the type of rental property.

Examples:

```text
Apartment
Condominium
Terrace House
Semi-D
Bungalow
Room
Studio
```

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | int | PK |
| Name | nvarchar(100) | Required, unique |
| Description | nvarchar(255) | Nullable |
| IsActive | bit | Required |

### Used by

- Property creation
- Property filtering
- Property details
- Search

---

# 8. Properties

## Table: `Properties`

Main rental-property table.

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | bigint | PK |
| LandlordId | bigint | FK → Users.Id |
| PropertyTypeId | int | FK → PropertyTypes.Id |
| Title | nvarchar(200) | Required |
| Description | nvarchar(max) | Nullable |
| MonthlyRent | decimal(18,2) | Required |
| AddressLine1 | nvarchar(255) | Required |
| AddressLine2 | nvarchar(255) | Nullable |
| City | nvarchar(100) | Required |
| State | nvarchar(100) | Required |
| Postcode | nvarchar(20) | Nullable |
| Latitude | decimal(10,7) | Nullable |
| Longitude | decimal(10,7) | Nullable |
| Bedrooms | int | Required |
| Bathrooms | int | Required |
| ParkingSpaces | int | Nullable |
| IsFurnished | bit | Required |
| AvailabilityStatus | nvarchar(30) | Required |
| IsActive | bit | Required |
| CreatedAt | datetime2 | Required |
| UpdatedAt | datetime2 | Nullable |

### Relationships

```text
Users
  |
  | LandlordId
  v
Properties
  |
  ├── PropertyTypes
  ├── PropertyImages
  ├── Favourites
  └── RentalRequests
```

### Used by

- Home
- Property listing
- Search
- Filters
- Property details
- Landlord property management
- Rental requests

---

# 9. PropertyImages

## Table: `PropertyImages`

Stores property image metadata.

Actual image files may be stored in cloud/object storage later; the database stores the metadata and URL.

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | bigint | PK |
| PropertyId | bigint | FK → Properties.Id |
| ImageUrl | nvarchar(1000) | Required |
| IsPrimary | bit | Required |
| SortOrder | int | Required |
| CreatedAt | datetime2 | Required |

### Used by

- Property details
- Property cards
- Image gallery
- Landlord image management

---

# 10. Favourites

## Table: `Favourites`

Stores properties saved by tenants.

### Columns

| Column | Type | Notes |
|---|---|---|
| UserId | bigint | PK/FK → Users.Id |
| PropertyId | bigint | PK/FK → Properties.Id |
| CreatedAt | datetime2 | Required |

Composite primary key:

```text
(UserId, PropertyId)
```

### Relationship

```text
Users
  |
  └── Favourites ─── Properties
```

### Used by

- Add favourite
- Remove favourite
- Favourite list
- Favourite status on property details

---

# 11. RentalRequestStatuses

## Table: `RentalRequestStatuses`

Lookup table for rental-request statuses.

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | int | PK |
| Name | nvarchar(50) | Required, unique |
| Description | nvarchar(255) | Nullable |

Initial values:

```text
Pending
Approved
Rejected
Cancelled
Expired
```

---

# 12. RentalRequests

## Table: `RentalRequests`

Stores a tenant's request to rent a property.

### Columns

| Column | Type | Notes |
|---|---|---|
| Id | bigint | PK |
| PropertyId | bigint | FK → Properties.Id |
| TenantId | bigint | FK → Users.Id |
| StatusId | int | FK → RentalRequestStatuses.Id |
| Message | nvarchar(1000) | Nullable |
| RequestedAt | datetime2 | Required |
| UpdatedAt | datetime2 | Nullable |
| DecisionAt | datetime2 | Nullable |
| DecisionNote | nvarchar(1000) | Nullable |

### Relationships

```text
Users (Tenant)
      |
      v
RentalRequests
      |
      +── Properties
      |
      +── RentalRequestStatuses
```

### Used by

- Submit rental request
- Tenant request list
- Request details
- Cancel request
- Landlord request list
- Approve request
- Reject request

---

# 13. Optional Future: Amenities

## Table: `Amenities`

Possible amenities:

```text
Air Conditioning
Washing Machine
Refrigerator
WiFi
Swimming Pool
Gym
Security
```

### Columns

| Column | Type |
|---|---|
| Id | int |
| Name | nvarchar(100) |
| Description | nvarchar(255) |
| IsActive | bit |

---

# 14. Optional Future: PropertyAmenities

Many-to-many relationship.

### Columns

| Column | Type |
|---|---|
| PropertyId | bigint |
| AmenityId | int |

Composite primary key:

```text
(PropertyId, AmenityId)
```

Used by:

- Property details
- Amenity filters
- Property creation/editing

---

# 15. Optional Future: Notifications

## Table: `Notifications`

For future push/in-app notifications.

### Columns

| Column | Type |
|---|---|
| Id | bigint |
| UserId | bigint |
| Title | nvarchar(200) |
| Message | nvarchar(1000) |
| Type | nvarchar(50) |
| ReferenceId | bigint |
| IsRead | bit |
| CreatedAt | datetime2 |

Possible notifications:

```text
Rental request approved
Rental request rejected
New rental request
Property status changed
```

---

# 16. Optional Future: RefreshTokens

If refresh-token authentication is implemented.

## Table: `RefreshTokens`

### Columns

| Column | Type |
|---|---|
| Id | bigint |
| UserId | bigint |
| TokenHash | nvarchar(500) |
| ExpiresAt | datetime2 |
| RevokedAt | datetime2 nullable |
| CreatedAt | datetime2 |

The final authentication architecture will determine whether this table is required.

---

# 17. Optional Future: AuditLogs

For administrative/audit requirements.

## Table: `AuditLogs`

### Columns

| Column | Type |
|---|---|
| Id | bigint |
| UserId | bigint nullable |
| Action | nvarchar(100) |
| EntityName | nvarchar(100) |
| EntityId | bigint nullable |
| OldValues | nvarchar(max) nullable |
| NewValues | nvarchar(max) nullable |
| CreatedAt | datetime2 |

---

# 18. Table Relationship Overview

```text
                         ┌──────────────┐
                         │    Roles     │
                         └──────┬───────┘
                                │
                                │
                         ┌──────▼───────┐
                         │  UserRoles   │
                         └──────┬───────┘
                                │
                         ┌──────▼───────┐
                         │    Users     │
                         └───┬────┬─────┘
                             │    │
                  Landlord   │    │ Tenant
                             │    │
                       ┌─────▼────▼─────┐
                       │   Properties   │
                       └──┬────┬────┬───┘
                          │    │    │
              ┌───────────┘    │    └────────────┐
              │                │                 │
       ┌──────▼──────┐  ┌─────▼──────┐   ┌──────▼───────┐
       │PropertyTypes│  │PropertyImages│  │  Favourites  │
       └─────────────┘  └─────────────┘   └──────────────┘
                                                │
                                                │
                                      ┌─────────▼─────────┐
                                      │       Users       │
                                      └───────────────────┘

Users ────────────────┐
                      │
                      ▼
               RentalRequests
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
     Properties          RentalRequestStatuses
```

---

# 19. Feature → Table Mapping

| Feature | Tables |
|---|---|
| Register | Users, Roles, UserRoles |
| Login | Users, Roles, UserRoles |
| Profile | Users |
| Change password | Users |
| Browse properties | Properties, PropertyTypes, PropertyImages |
| Search | Properties, PropertyTypes |
| Filter | Properties, PropertyTypes |
| Property details | Properties, PropertyTypes, PropertyImages, Users |
| Add favourite | Favourites, Users, Properties |
| Remove favourite | Favourites |
| Favourite list | Favourites, Properties, PropertyImages |
| Add property | Properties, PropertyTypes |
| Edit property | Properties, PropertyTypes |
| Property images | PropertyImages, Properties |
| Submit rental request | RentalRequests, Properties, Users, RentalRequestStatuses |
| Tenant request list | RentalRequests, Properties |
| Landlord request list | RentalRequests, Properties, Users |
| Approve request | RentalRequests, Properties |
| Reject request | RentalRequests |
| Cancel request | RentalRequests |
| Amenities | Amenities, PropertyAmenities |
| Notifications | Notifications, Users |
| Refresh token | RefreshTokens, Users |
| Audit | AuditLogs, Users |

---

# 20. Function → Database Mapping

This section is specifically intended for AI agents.

## Authentication

| Function | Primary tables | Related tables |
|---|---|---|
| Register | Users | Roles, UserRoles |
| Login | Users | Roles, UserRoles |
| Get current user | Users | Roles, UserRoles |
| Update profile | Users | — |
| Change password | Users | — |

---

## Home / Property

| Function | Primary tables | Related tables |
|---|---|---|
| Get recommended properties | Properties | PropertyTypes, PropertyImages |
| Search properties | Properties | PropertyTypes |
| Filter properties | Properties | PropertyTypes |
| Get property details | Properties | PropertyTypes, PropertyImages, Users |
| Create property | Properties | PropertyTypes |
| Update property | Properties | PropertyTypes |
| Deactivate property | Properties | — |
| Add property image | PropertyImages | Properties |
| Remove property image | PropertyImages | Properties |

---

## Favourite

| Function | Primary tables | Related tables |
|---|---|---|
| Get favourites | Favourites | Properties, PropertyImages |
| Add favourite | Favourites | Users, Properties |
| Remove favourite | Favourites | Users, Properties |
| Check favourite | Favourites | Users, Properties |

---

## Rental Request

| Function | Primary tables | Related tables |
|---|---|---|
| Create rental request | RentalRequests | Users, Properties, RentalRequestStatuses |
| Get tenant requests | RentalRequests | Properties, RentalRequestStatuses |
| Get request details | RentalRequests | Users, Properties, RentalRequestStatuses |
| Cancel request | RentalRequests | RentalRequestStatuses |
| Get landlord requests | RentalRequests | Users, Properties, RentalRequestStatuses |
| Approve request | RentalRequests | Properties, RentalRequestStatuses |
| Reject request | RentalRequests | RentalRequestStatuses |

---

# 21. Important Business Rules

### Property ownership

A landlord can only modify/deactivate properties where:

```text
Properties.LandlordId == authenticatedUserId
```

The API must enforce this.

---

### Favourite ownership

A user can only manage their own favourites.

The API should derive `UserId` from the authenticated JWT.

Do not trust a user ID sent by the mobile client.

---

### Rental request ownership

A tenant can only:

- View their own requests
- Cancel their own eligible requests

A landlord can only:

- View requests for properties they own
- Approve/reject requests for properties they own

---

### Property availability

A property should not accept new rental requests if its availability/business status prevents it.

The exact rule will be finalized in the API.

---

### Rental request state transitions

Initial planned transitions:

```text
Pending
  ├── Approved
  ├── Rejected
  └── Cancelled
```

Expired may be handled by a scheduled/background process later.

The API must validate state transitions.

---

# 22. Index Recommendations

Potential indexes:

### Users

```text
UX_Users_Email
```

Unique index on:

```text
Email
```

### Properties

Indexes on:

```text
LandlordId
PropertyTypeId
City
State
MonthlyRent
AvailabilityStatus
IsActive
```

### Favourites

Composite PK/index:

```text
UserId + PropertyId
```

### RentalRequests

Indexes on:

```text
TenantId
PropertyId
StatusId
RequestedAt
```

### PropertyImages

Index on:

```text
PropertyId
```

---

# 23. Monetary Values

Rental prices must use:

```text
decimal(18,2)
```

Do not use floating-point database types for monetary values.

Example:

```text
MonthlyRent = 1250.00
```

---

# 24. Date/Time

Use:

```text
datetime2
```

for database timestamps.

The API should establish a consistent time-zone strategy.

Recommended approach:

- Store timestamps in UTC.
- Convert to local time only for display.

---

# 25. Database Security

Never:

- Store plain-text passwords
- Expose connection strings to Flutter
- Give Flutter database credentials
- Allow mobile clients to execute SQL
- Trust client-provided ownership IDs
- Return password hashes in API responses

---

# 26. AI Agent Database Rules

Before changing database-related code:

1. Read `README.md`.
2. Read `INTEGRATION.md`.
3. Read this `DATABASE.md`.
4. Check whether the table already exists.
5. Reuse existing relationships where possible.
6. Do not invent duplicate tables.
7. Do not change a primary key without understanding dependencies.
8. Do not remove columns without checking API/mobile usage.
9. Update this document when adding/changing tables.
10. Update the feature-to-table mapping when adding functionality.
11. Use EF Core migrations for schema changes according to the backend project convention.
12. Never expose MSSQL directly to Flutter.

---

# 27. Database Status

Current status:

```text
Schema: PLANNED
Database: MSSQL
ORM: EF Core
Backend: Not yet implemented
Mobile integration: Not yet implemented
```

The table definitions in this document are the **initial proposed design** and must be reviewed before production migration creation.

---

# 28. Future Schema Extensions

Potential future modules:

```text
Payments
RentalContracts
PropertyVisits
Reviews
Reports
Notifications
Messaging
Documents
MaintenanceRequests
PropertyVerification
```

These should only be introduced when the corresponding product requirements are approved.
