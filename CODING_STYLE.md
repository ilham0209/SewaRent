# SewaRent — Coding Style & Clean Code Guidelines

> **Purpose:** This document defines the coding style, structure, naming, commenting, and clean-code rules for the SewaRent Mobile application.
>
> The goal is to keep the Flutter/Dart code consistent, readable, maintainable, and easy for both developers and AI coding agents to understand.
>
> This document is inspired by the project's existing .NET coding conventions: feature-oriented organization, thin entry points, clear responsibilities, minimal comments, explicit validation, and avoiding unnecessary abstraction.
>
> Feature folders in this document (`auth`, `property`, `favourite`, `rental_request`, `billing`, `payment_notification`, `dashboard`, `profile`) mirror the domains documented in `README.md` and `INTEGRATION.md`, and correspond to the API's own domains in `SewaRent_Api` (`User`, `Property`, `Favourite`, `RentalRequest`, `Billing`, `Notification`).

---

## 1. Core Principles

SewaRent code should follow these principles:

1. **Keep code simple.**
2. **Prefer readable code over clever code.**
3. **Keep each class/function responsible for one clear task.**
4. **Keep UI code focused on UI.**
5. **Keep API/database concerns outside widgets.**
6. **Do not duplicate logic unnecessarily.**
7. **Avoid premature abstraction.**
8. **Prefer existing project patterns over introducing new patterns.**
9. **Keep comments minimal and useful.**
10. **Do not write comments that simply repeat the code.**
11. **Use meaningful names instead of explanatory comments.**
12. **Follow the existing project structure before creating a new folder or abstraction.**

---

# 2. Dart / Flutter Formatting

Use the standard Dart formatter.

Run:

```bash
dart format .
```

or:

```bash
flutter format .
```

The project should rely on formatter output instead of manually formatting files.

Do not create custom formatting conventions that conflict with Dart's standard formatter.

---

# 3. File Naming

Use `snake_case` for Dart filenames.

Correct:

```text
property_card.dart
property_detail_page.dart
property_repository.dart
api_client.dart
auth_controller.dart
```

Incorrect:

```text
PropertyCard.dart
propertyCard.dart
property-card.dart
```

Use descriptive names.

Avoid abbreviations unless they are universally understood.

Correct:

```text
api_client.dart
```

Avoid:

```text
api_cl.dart
apicl.dart
```

---

# 4. Class Naming

Use `PascalCase`.

```dart
class PropertyCard {}

class PropertyDetailPage {}

class PropertyRepository {}

class ApiClient {}
```

Do not use:

```dart
class propertyCard {}

class property_card {}
```

---

# 5. Variable and Method Naming

Use `camelCase`.

```dart
final propertyName = 'House A';

Future<void> loadProperties() async {}
```

Avoid unclear names:

```dart
final x = ...
final d = ...
final temp = ...
```

Prefer:

```dart
final property = ...
final propertyDetails = ...
final rentalRequest = ...
```

Short names are acceptable for very small scopes:

```dart
for (final item in items) {}
```

---

# 6. Constants

Use constants when a value is genuinely constant and reused or represents a meaningful application value.

```dart
const defaultPageSize = 20;
const maxPropertyImages = 10;
```

Avoid scattering magic numbers:

```dart
if (items.length > 20) {}
```

Prefer:

```dart
if (items.length > defaultPageSize) {}
```

Do not create constants for values that are only used once and have no meaningful name.

---

# 7. Comments

## 7.1 General Rule

**Comments should be minimal.**

Do not comment every line.

Bad:

```dart
// Get the property
final property = getProperty();

// Set the property name
final propertyName = property.name;

// Display the property name
Text(propertyName);
```

This adds no useful information.

Prefer:

```dart
final property = getProperty();

Text(property.name);
```

---

## 7.2 Comment Only When Necessary

A comment is appropriate when it explains:

- Why something is required
- A non-obvious business rule
- A workaround
- An external limitation
- A security consideration
- A temporary implementation decision

Example:

```dart
// API requires the image upload to be multipart/form-data.
await uploadPropertyImage(file);
```

---

## 7.3 Avoid Comments That Repeat Code

Bad:

```dart
// Set loading to true
setState(() {
  isLoading = true;
});
```

Good:

```dart
setState(() {
  isLoading = true;
});
```

---

## 7.4 TODO Comments

Use TODO only when the task is genuinely incomplete.

```dart
// TODO: Replace mock data with API integration.
```

Do not leave vague TODOs:

```dart
// TODO: Fix this
```

Prefer a specific action:

```dart
// TODO: Add pagination when the property API is available.
```

---

## 7.5 Comment Language

Use English for code comments.

Keep comments short.

Avoid large blocks of commentary inside production code.

Architecture explanations belong in:

```text
README.md
INTEGRATION.md
DATABASE.md
CODING_STYLE.md
```

rather than inside source files.

---

# 8. Imports

Keep imports organized and let Dart/IDE tooling format them.

Example:

```dart
import 'package:flutter/material.dart';

import 'package:sewa_rent/features/property/domain/entities/property.dart';
import 'package:sewa_rent/features/property/presentation/widgets/property_card.dart';
```

Separate external/package imports from project imports where appropriate.

Remove unused imports.

Do not leave commented-out imports.

---

# 9. Null Safety

Use Dart null safety properly.

Prefer:

```dart
String? description;
```

when a value can genuinely be null.

Avoid unnecessary nullable values:

```dart
String? propertyName;
```

if the application guarantees that `propertyName` always exists.

Do not use `!` casually.

Avoid:

```dart
final name = property!.name!;
```

Prefer proper handling:

```dart
if (property == null) {
  return const SizedBox.shrink();
}

final name = property.name;
```

Use `!` only when the non-null state is guaranteed by program logic and the guarantee is clear.

---

# 10. Widget Structure

Keep widgets small and focused.

Avoid a single page containing hundreds of lines of widget tree code.

Instead of:

```dart
class PropertyPage extends StatelessWidget {
  // Huge build method
}
```

split reusable sections into widgets:

```text
property_detail_page.dart
property_header.dart
property_image_gallery.dart
property_information.dart
property_action_button.dart
```

However, do not split every two or three lines into a separate widget.

Create a widget when it:

- Has a meaningful responsibility
- Is reused
- Makes the parent easier to read
- Has its own state
- Represents a meaningful UI section

---

# 11. `build()` Method

The `build()` method should primarily describe the UI.

Avoid putting API calls, database logic, or complex business rules directly inside `build()`.

Bad:

```dart
@override
Widget build(BuildContext context) {
  final properties = database.getProperties();
  // Complex business logic...
}
```

Prefer:

```dart
@override
Widget build(BuildContext context) {
  return PropertyList(
    properties: properties,
  );
}
```

Data loading should be handled by the appropriate controller/state/repository layer.

---

# 12. UI and Business Logic Separation

Do not put business logic directly inside widgets.

Bad:

```dart
onPressed: () {
  if (property.monthlyRent < 1000 &&
      property.isAvailable &&
      currentUser.role == 'Tenant') {
    // Submit request
  }
}
```

Prefer:

```dart
onPressed: controller.submitRentalRequest,
```

The controller/use case/service should own the business operation.

---

# 13. Feature-First Structure

Business functionality belongs inside its feature.

Example:

```text
features/
├── property/
│   ├── data/
│   ├── domain/
│   └── presentation/
└── billing/
    ├── data/
    ├── domain/
    └── presentation/
```

Property-specific code should stay inside `property`; invoice/receipt/payment-claim code should stay inside `billing`, not spread across `property` or `rental_request` just because an invoice references a rental request.

Do not move feature-specific classes into `shared` just to make them accessible.

---

# 14. Shared Folder Rule

`shared/` is for genuinely shared functionality.

Good candidates:

```text
shared/
├── models/
├── enums/
└── widgets/
```

Examples:

```text
UserSummary
RentalStatus
AppEmptyState
```

Do not use `shared/` as a dumping ground.

Bad:

```text
shared/
├── random_helper.dart
├── property_helper.dart
├── temporary_service.dart
├── test_code.dart
└── misc.dart
```

If code belongs to one feature, keep it in that feature.

---

# 15. Core Folder Rule

`core/` contains application-wide technical concerns.

Examples:

```text
core/
├── constants/
├── network/
├── storage/
├── utils/
└── widgets/
```

Good examples:

```text
api_client.dart
secure_storage.dart
app_constants.dart
date_formatter.dart
```

Feature-specific business logic should not be placed in `core`.

---

# 16. Models and Entities

Keep domain concepts separate from API response models when the architecture requires the distinction.

Example:

```text
domain/
└── entities/
    └── property.dart

data/
└── models/
    └── property_model.dart
```

A model is responsible for translating external/API data.

An entity represents the application's business concept.

Do not automatically create an entity/model/repository/use case for every small object if the feature does not need that level of separation.

Use the simplest structure that remains maintainable.

---

# 17. API Calls

Widgets should not call HTTP clients directly.

Bad:

```dart
onPressed: () async {
  final response = await http.get(
    Uri.parse('$baseUrl/properties'),
  );
};
```

Prefer:

```text
Widget
  ↓
Controller / State
  ↓
Repository
  ↓
Remote Data Source
  ↓
ApiClient
```

This keeps API implementation details away from the UI.

---

# 18. API Client

`ApiClient` should handle common HTTP concerns:

- Base URL
- Headers
- Authorization
- JSON encoding
- JSON decoding
- Timeouts
- Common HTTP error handling

Feature repositories should not duplicate these concerns.

Bad:

```text
PropertyRepository
 ├── manually adds auth header
 ├── manually handles timeout
 └── manually decodes every response

FavouriteRepository
 ├── manually adds auth header
 ├── manually handles timeout
 └── manually decodes every response
```

Prefer:

```text
PropertyRepository ──┐
FavouriteRepository ─┼──> ApiClient
AuthRepository ──────┘
```

---

# 19. Error Handling

Do not expose raw technical errors directly to users.

Bad:

```dart
Text(exception.toString())
```

Prefer a user-friendly message:

```dart
Text(state.errorMessage)
```

The application should distinguish:

```text
Network error
Unauthorized
Forbidden
Not found
Validation error
Server error
Unknown error
```

Detailed technical errors may be logged for debugging, but should not normally be displayed to users.

---

# 20. Loading and Empty States

Every API-driven screen should consider:

```text
Loading
Success
Empty
Error
```

Example:

```dart
if (state.isLoading) {
  return const CircularProgressIndicator();
}

if (state.hasError) {
  return ErrorState(message: state.errorMessage);
}

if (state.items.isEmpty) {
  return const EmptyState();
}

return PropertyList(properties: state.items);
```

Do not assume the API always returns data.

---

# 21. Async Code

Use `async` / `await` for asynchronous operations.

Prefer:

```dart
final properties = await repository.getProperties();
```

over deeply nested callbacks.

Always consider error handling:

```dart
try {
  final properties = await repository.getProperties();
} catch (e) {
  // Handle or propagate the error.
}
```

Do not silently swallow exceptions.

Avoid:

```dart
try {
  await repository.getProperties();
} catch (_) {}
```

unless intentionally ignoring the error is documented and appropriate.

---

# 22. Controllers / State Classes

A controller/state class should coordinate UI state and application actions.

It should not become a replacement for every other layer.

Avoid a giant controller:

```text
PropertyController
 ├── API calls
 ├── JSON parsing
 ├── database logic
 ├── navigation
 ├── UI construction
 ├── validation
 └── business rules
```

Prefer clear responsibilities:

```text
Controller
    ↓
Use Case
    ↓
Repository
    ↓
Data Source
    ↓
API Client
```

The exact state-management implementation will follow the library selected for the project.

---

# 23. Navigation

Navigation configuration belongs in:

```text
app/router.dart
```

Do not scatter route definitions throughout feature files.

Feature pages should define their UI; application routing should define how screens are reached.

---

# 24. Theme

Global visual configuration belongs in:

```text
app/theme.dart
```

Avoid repeating global styling throughout the application.

Bad:

```dart
color: Colors.blue
```

everywhere.

Prefer application theme values when the color represents a global design decision.

Feature-specific visual values may remain local when appropriate.

---

# 25. Magic Strings

Avoid repeating important business strings throughout the application.

Bad:

```dart
if (status == 'Approved') {}
```

Prefer an enum or centralized representation when appropriate:

```dart
if (status == RentalStatus.approved) {}
```

This reduces spelling mistakes and makes refactoring easier.

---

# 26. Enums

Use enums for finite application states.

Example:

```dart
enum RentalStatus {
  pending,
  approved,
  rejected,
  cancelled,
  expired,
}

enum InvoiceStatus {
  unpaid,
  paymentClaimed,
  paid,
}

enum PaymentNotificationType {
  scheduled,
  manual,
  overdue,
}
```

These mirror the API's `Status`/`NotificationType` string fields documented in `DATABASE.md` §14 and §17 — keep the enum values and the API's string values in sync via the data-layer mapping, not by comparing raw strings throughout the UI.

Avoid string comparisons everywhere when the value represents a fixed set of states.

---

# 27. Constructors

Use required named parameters for important values.

Prefer:

```dart
const PropertyCard({
  super.key,
  required this.property,
});
```

Avoid long positional constructors that are difficult to read:

```dart
PropertyCard(property, image, title, rent, location, type);
```

---

# 28. `const`

Use `const` where Flutter can benefit from immutable widgets.

Prefer:

```dart
const SizedBox(height: 16);
```

and:

```dart
const Text('Properties');
```

when applicable.

Do not force `const` where it makes the code harder to understand.

---

# 29. Immutability

Prefer immutable data where practical.

Use:

```dart
final
```

by default.

Example:

```dart
final String title;
final double monthlyRent;
```

Only use mutable state where the application actually needs it.

---

# 30. Functions

Keep functions short and focused.

Bad:

```dart
Future<void> submitRentalRequest() async {
  // validate form
  // build request
  // call API
  // parse response
  // update multiple UI states
  // navigate
  // show snackbar
  // refresh properties
  // ...
}
```

If a function becomes difficult to understand, separate responsibilities into appropriate layers.

Do not split functions merely to make them short; split when the extracted operation has a meaningful responsibility.

---

# 31. Avoid Overengineering

Do not introduce abstractions without a reason.

Avoid creating:

```text
IPropertyFactory
IPropertyBuilder
IPropertyManager
IPropertyCoordinator
IPropertyService
```

when a simple repository/controller is sufficient.

Every abstraction should solve a real problem.

---

# 32. Dependency Injection

Use the project's selected dependency-injection/state-management approach consistently.

Do not instantiate major infrastructure dependencies directly inside widgets.

Avoid:

```dart
final apiClient = ApiClient();
```

inside every page.

Dependencies should be configured centrally and injected into the appropriate layer.

---

# 33. Security

Never store:

```text
MSSQL username
MSSQL password
JWT secret
API private key
```

inside Flutter.

Never connect:

```text
Flutter → MSSQL
```

Authentication should use the API.

Sensitive tokens should use secure storage.

Never log:

```text
password
JWT
refresh token
database credentials
```

---

# 34. Logging

Logs should be useful and minimal.

Good:

```text
Failed to load properties.
```

Avoid dumping entire API responses or sensitive data.

Never log authentication credentials or tokens.

Production logging should avoid unnecessary personal information.

---

# 35. Testing

Tests should follow the feature structure where practical.

Example:

```text
test/
└── features/
    └── property/
        ├── property_repository_test.dart
        ├── property_controller_test.dart
        └── property_page_test.dart
```

Test:

- Business logic
- Data conversion
- Important state transitions
- Validation
- Error handling
- Critical UI behavior

Do not write tests simply to increase test count.

---

# 36. Test Naming

Use descriptive names.

Good:

```dart
test('returns properties when API request succeeds', () {});
```

```dart
test('shows error when property request fails', () {});
```

Avoid:

```dart
test('test1', () {});
```

---

# 37. Generated Code

If a package generates Dart code, do not manually edit generated files.

Examples may include:

```text
*.g.dart
*.freezed.dart
```

Modify the source file and regenerate.

---

# 38. Package Dependencies

Before adding a package:

1. Check whether Flutter/Dart already provides the functionality.
2. Check whether an existing project dependency can solve it.
3. Add a package only when it provides meaningful value.
4. Avoid adding multiple packages that solve the same problem.
5. Document important architectural dependencies.

Do not add packages simply because they are popular.

---

# 39. AI Coding Agent Rules

AI agents working on SewaRent must follow these rules:

1. Read `README.md` before making architectural changes.
2. Read `INTEGRATION.md` before changing API integration.
3. Read `DATABASE.md` before making database-related assumptions.
4. Read `CODING_STYLE.md` before generating significant Flutter code.
5. Follow existing code patterns before introducing new patterns.
6. Keep comments minimal.
7. Do not add comments that repeat obvious code.
8. Do not create unnecessary abstractions.
9. Do not move files without a clear reason.
10. Do not introduce a new dependency without justification.
11. Do not put API calls directly inside widgets.
12. Do not connect Flutter directly to MSSQL.
13. Do not invent API endpoints.
14. Do not invent database fields.
15. Do not silently change existing behavior outside the requested task.
16. Keep changes focused.
17. Run formatting after modifying Dart files.
18. Fix analyzer warnings introduced by the change.
19. Update documentation when architecture or integration contracts change.
20. Preserve existing naming conventions.
21. Never send a raw `landlordId` from the client for landlord linking — always submit the human-entered `landlordCode` (see `INTEGRATION.md` §13).
22. Always render an invoice's own snapshot fields (`bankName`/`bankAccountNumber`) rather than the landlord's live profile values (see `DATABASE.md` §14).
23. Require a non-empty reason before allowing a landlord to submit a payment rejection — the API enforces this server-side, but the UI should not allow submitting an incomplete request.
24. If this document appears to disagree with `SewaRent_Api`'s `CODING_STYLE.md` on a shared convention (naming, response envelope, status enums), treat the API repository as authoritative and flag the mismatch.

---

# 40. Before Creating a New File

Before creating a new file, ask:

```text
Does this code have a clear responsibility?
Does an existing file already have the correct responsibility?
Does this belong to a feature?
Is this genuinely shared?
Is the abstraction necessary?
```

Prefer:

```text
One clear file
```

over:

```text
Many tiny files with no meaningful separation
```

---

# 41. Before Finishing a Change

Check:

```text
[ ] Code is formatted
[ ] No unused imports
[ ] No unnecessary comments
[ ] No debug prints
[ ] No sensitive information in logs
[ ] No unnecessary abstractions
[ ] API calls remain outside widgets
[ ] Naming follows project conventions
[ ] Loading/error/empty states are handled where applicable
[ ] Tests added/updated where appropriate
[ ] Documentation updated if required
```

---

# 42. Comment Standard — Quick Reference

### Avoid

```dart
// Create a new property
final property = Property();
```

### Prefer

```dart
final property = Property();
```

### Use when needed

```dart
// API requires the property ID in the request body.
final request = CreateRentalRequest(propertyId: property.id);
```

### Principle

> **Code explains what. Comments explain why.**

Keep comments short.

---

# 43. Final Coding Philosophy

SewaRent should prioritize:

```text
Readable
   ↓
Simple
   ↓
Consistent
   ↓
Testable
   ↓
Maintainable
```

Not:

```text
Complex
   ↓
Over-engineered
   ↓
Hard to understand
```

The best code is not the code with the most architecture.

The best code is code where another developer—or an AI coding agent—can understand the intent quickly and safely make the next change.