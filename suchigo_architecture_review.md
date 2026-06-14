# SuchiGo — Elite Architecture Review Board Report

> **Board Composition:** Principal Software Architect · Distinguished Engineer · Product Architect · Security Architect · Performance Engineer · Scalability Engineer · UX Systems Architect · Infrastructure Architect
>
> **Date:** 2026-06-14 | **Project:** `suchigo_app` v1.0.0+7

---

## PHASE 1 — REQUIREMENT EXTRACTION

### Product

| Field | Value |
|---|---|
| **Product Name** | SuchiGo |
| **Product Category** | Civic-Tech / Municipal Services Platform |
| **Core Purpose** | Digitize the relationship between citizens and municipal waste collection services — scheduling, tracking, and billing in one app |
| **Primary Value Proposition** | Replace phone calls and manual processes with a real-time, self-service waste pickup booking and tracking system |

### Users

| Field | Value |
|---|---|
| **User Types** | Citizens (residents), Municipal Supervisors (admin), Waste Collectors (field workers) |
| **User Roles** | `resident` (primary), `collector` (future), `admin` (future dashboard) |
| **User Count Estimate** | 500–5,000 at launch (ward-scoped rollout) |
| **Growth Expectations** | Moderate-to-High: Municipal contracts expand ward by ward. Each new ward = new user cohort |

### Platform

- **Primary:** Mobile (Android, iOS via Flutter)
- **Secondary:** Web (present in repo but not a priority)
- **Classification:** Mobile-First, Cross-Platform

### Business Domain

- **Primary:** Civic-Tech / GovTech
- **Secondary:** E-Commerce (booking/billing loop), IoT-adjacent (real-time collector tracking)

---

## PHASE 2 — SYSTEM CLASSIFICATION

### Complexity: **Moderate → Advanced**

**Why:** The app has a multi-step booking wizard, real-time geolocation streaming, Firebase Auth, a custom REST backend (`suchigoapi.pythonanywhere.com`), SQLite caching, OTP flows, and billing history. More than a simple CRUD app. The real-time tracking leg alone elevates this above moderate.

---

### Scale: **MVP → Production**

**Current state:** Advanced MVP. Core flows exist but the data layer has critical gaps (no token persistence post-login, Firestore rules expired January 14 2026, no offline queue). The next milestone should be **Production**.

---

### Data Profile

| Dimension | Assessment |
|---|---|
| **Data Volume** | Low-Medium. Bounded by ward size. Booking records + location snapshots |
| **Read Frequency** | Medium. Dashboard, orders, and bill screens read on every mount |
| **Write Frequency** | Low-Medium. Booking submissions, location pings, profile updates |
| **Sync Needs** | HIGH. Collector location must stream to user in near-real-time |
| **Offline Requirements** | Medium. Users must be able to view past bookings and bills offline |

---

### Security Profile

| Dimension | Assessment |
|---|---|
| **Authentication** | Firebase Auth (OTP + email/password) + custom REST JWT |
| **Authorization** | **ABSENT.** No role-based access exists in Firestore rules or the app |
| **Sensitive Data** | PII (name, phone, address, ward), location data |
| **Regulatory** | India PDPB (Personal Data Protection Bill) alignment required for PII |
| **Audit Requirements** | Booking history, billing records — need immutable audit trail |

> [!CAUTION]
> The Firestore rules expired on **2026-01-14**. All Firestore reads/writes are currently **denied in production**. This is a P0 blocker.

---

### Performance Profile

| Dimension | Target |
|---|---|
| **Startup** | Cold start < 2.5s on mid-range Android |
| **Rendering** | Consistent 60fps; 90fps on capable devices |
| **Background Processing** | Location streaming while app is backgrounded |
| **Real-Time** | Collector location update latency < 3 seconds |
| **Battery** | Location polling must use geofencing/interval strategy, not continuous |

---

## PHASE 3 — ARCHITECTURE DECISION MATRIX

### State Management

| Field | Decision |
|---|---|
| **Decision** | **Migrate from `Provider` → `Riverpod` (code-generated, `@riverpod` annotation style)** |
| **Reason** | Current `Provider` setup with 11+ global `ChangeNotifier`s injected at root causes unnecessary rebuilds of the entire tree. `PickupProvider` holds a `TextEditingController` — a framework anti-pattern. Riverpod's `ref.watch` scoping, `AsyncNotifier`, and auto-dispose solve all of these. |
| **Confidence** | HIGH |
| **Alternatives Rejected** | `Bloc` — excessive boilerplate for this domain size. `Redux` — overkill, adds ceremony without benefit. Staying on `Provider` — fixes immediate bugs but doesn't solve architectural debt. |

---

### Data Architecture

**Decision: Layered — UI → Provider/Notifier → Repository → Data Source**

The current architecture collapses Repository and Service into the Provider (e.g., `LoginProvider` directly calls `http.post`). This creates untestable, tightly coupled code. A formal Repository layer must be introduced.

---

### Repository Layer

**Required: YES**

Reason: API endpoint URL (`suchigoapi.pythonanywhere.com`) is hardcoded in `LoginProvider` and `RegisterProvider`. Swapping backends, adding caching, or unit testing is impossible without a repository abstraction.

---

### Domain Layer

**Required: NO (at current scale)**

Reason: The business logic is not complex enough to warrant separate Use Case classes. Repository + Notifier is sufficient. Re-evaluate if admin/supervisor portals are added.

---

### Dependency Injection

**Required: YES — via Riverpod providers**

Reason: Riverpod's provider tree IS the DI container. No additional package needed. This replaces the manual `MultiProvider` root.

---

### Offline Strategy

**Required: YES**

Reason: Users in areas with poor connectivity need to view their booking history and bills. An offline-first read strategy using SQLite as the local cache with a write queue is required.

**Pattern:** Network-first with local fallback for reads. Write-through with a local queue for booking submissions.

---

### Storage Strategy

**Decision: Three-tier combination**

| Store | Purpose |
|---|---|
| `flutter_secure_storage` | JWT token, Firebase UID — **never** `SharedPreferences` for auth tokens |
| `SQLite (sqflite)` | Bookings, billing history, user profile cache |
| `SharedPreferences` | Non-sensitive UI state: theme, selected ward, onboarding flag |

**Rejected:** Hive/Isar — adds dependency weight without sufficient benefit at this scale. The team is already familiar with SQLite.

---

### API Strategy

**Decision: Hybrid — REST + WebSocket (or Firebase Realtime Database)**

| Channel | Use |
|---|---|
| **REST** (`http`) | Auth, booking submission, billing fetch |
| **WebSocket / Firebase Realtime DB** | Collector real-time location streaming |

**Current problem:** `CollectorProvider` and `LocationProvider` use one-shot `Geolocator.getCurrentPosition()`. Real-time tracking requires a **stream**, not a future. This must be redesigned.

---

### Notification Strategy

**Required: YES**

Firebase Cloud Messaging (FCM) is mandatory for:
- Booking confirmation push notifications
- Collector ETA alerts
- Billing due reminders

**Currently:** Not implemented. `cloud_functions` is listed as a dependency but unused.

---

### Search Strategy

**Required: LOW PRIORITY**

Ward and address selection uses a list. A client-side filter on the ward list is sufficient at this scale.

---

### Analytics Strategy

**Required: YES**

Firebase Analytics (zero-cost, already using Firebase). Track: booking completion rate, drop-off point in the wizard, screen time. No third-party SDK needed.

---

### Feature Flags

**Required: NO (immediate), YES (future)**

Firebase Remote Config is the natural choice when new wards or features are rolled out selectively.

---

### Background Processing

**Required: YES**

`workmanager` for periodic booking status sync. `geolocator` background mode for collector location updates. Requires foreground service notification on Android.

---

### Native Integration

**Required: YES (existing)**

- `geolocator` — location permissions + GPS
- `url_launcher` — external links
- Android foreground service for background location

---

## PHASE 4 — SECURITY REVIEW

### 4.1 Authentication Risks

| Risk | Severity | Impact | Mitigation |
|---|---|---|---|
| JWT token stored in-memory only (lost on restart) | **CRITICAL** | User logged out on every app restart | Store token in `flutter_secure_storage` |
| No token refresh logic | **HIGH** | Sessions expire silently; users see auth errors | Implement refresh token flow |
| OTP screen has no rate limiting on client | **MEDIUM** | Brute-force OTP guessing | Enforce rate limiting server-side; disable submit button for 30s after each attempt |

### 4.2 Authorization Risks

| Risk | Severity | Impact | Mitigation |
|---|---|---|---|
| No role enforcement in app | **HIGH** | Any user can construct API calls to admin endpoints | Validate role claim from JWT on every protected screen |
| Firestore rules allow all (now expired/denying) | **CRITICAL** | Data fully exposed / fully broken | Write proper role-based Firestore rules immediately |

### 4.3 Data Exposure Risks

| Risk | Severity | Impact | Mitigation |
|---|---|---|---|
| `print()` statements log user credentials and API responses | **HIGH** | Credentials in device logs, visible to other apps on debug builds | Replace all `print()` with a logger that strips PII and is disabled in release |
| Raw API error bodies shown to users | **MEDIUM** | Internal server details leaked | Sanitize error messages before displaying |

### 4.4 Local Storage Risks

| Risk | Severity | Impact | Mitigation |
|---|---|---|---|
| SQLite database is unencrypted | **MEDIUM** | Device theft exposes booking/billing history | Use `sqflite_cipher` or encrypt sensitive columns |

### 4.5 API Risks

| Risk | Severity | Impact | Mitigation |
|---|---|---|---|
| API URL hardcoded in provider classes | **MEDIUM** | Accidental exposure in version control | Move to `--dart-define` build environment variables |
| No certificate pinning | **MEDIUM** | MitM attack on REST calls | Implement certificate pinning for production build |
| No request timeout configured | **LOW** | Hung requests with no user feedback | Add 15s timeout to all `http` calls |

### 4.6 Logging Risks

| Risk | Severity | Impact | Mitigation |
|---|---|---|---|
| `print('Login Successful: $responseBody')` in `LoginProvider` | **HIGH** | Token/user data logged in plaintext | Remove immediately. Use structured, level-based logging |

---

## PHASE 5 — SCALABILITY REVIEW

### User Growth Projection

```
100 users    → Current state handles fine
1,000 users  → API server (PythonAnywhere free tier) becomes bottleneck
10,000 users → SQLite local cache strategy must be solid; REST API needs scaling
100,000 users → Firestore sharding needed; background job queue required
1M users     → Architecture redesign needed (microservices, CDN, load balancer)
```

### Bottleneck Analysis

| Component | Risk | Mitigation |
|---|---|---|
| `suchigoapi.pythonanywhere.com` | **CRITICAL** — Free/shared tier, limited concurrency | Migrate to a scalable backend (Cloud Run, Railway, Fly.io) |
| 11 global `ChangeNotifier`s | **HIGH** — all initialized at app start regardless of usage | Riverpod auto-dispose; lazy initialization |
| Single `waste_model.dart` | **MEDIUM** — no separation of domain models | Formal model layer with JSON serialization (`json_serializable`) |
| Firestore (if adopted) | **LOW** — scales natively | Shard by ward ID for large deployments |
| `Geolocator.getCurrentPosition()` | **HIGH** — one-shot, not streaming | Replace with `Geolocator.getPositionStream()` |

---

## PHASE 6 — PERFORMANCE REVIEW

### Performance Budgets

| Metric | Target | Current Estimate | Status |
|---|---|---|---|
| Cold Start Time | < 2,500ms | ~2,000ms (Firebase init adds ~500ms) | ✅ Acceptable |
| Target FPS | 60fps sustained | Likely 60fps but untested | ⚠️ Unverified |
| Memory Usage | < 150MB | Unknown | ⚠️ Unverified |
| APK Size | < 25MB | Unknown | ⚠️ Unverified |
| Network per booking flow | < 50KB | Unknown | ⚠️ Unverified |
| Location update interval | Every 5–10s | Continuous (drain risk) | ❌ Fix required |
| Background CPU | < 3% avg | Unknown | ⚠️ Unverified |

### Key Performance Actions

1. **Profile with Flutter DevTools** before any production release
2. **Lazy-load screens** — avoid importing all screens into `main.dart`
3. **Image asset optimization** — `background.jpg` and PNG assets need compression
4. **Replace polling with streaming** for collector location
5. **Add `const` constructors** across all stateless widgets

---

## PHASE 7 — DESIGN SYSTEM STRATEGY

### Brand Analysis

| Attribute | Assessment |
|---|---|
| **Brand Personality** | Trustworthy, Eco-conscious, Modern Civic |
| **Visual Direction** | Clean, nature-inspired greens with high contrast for accessibility |
| **Primary Brand Color** | `#1E713D` (Forest Green) — identified in `PickupProvider` |
| **Font** | Poppins — already established, appropriate for civic/consumer |

### Design Token Strategy

Define a formal `AppColors`, `AppTypography`, and `AppSpacing` class. Currently, `Color(0xFF1E713D)` is hardcoded in provider classes — a category error (UI constants belong in the design layer, not business logic).

### Color Strategy

| Role | Token | Value |
|---|---|---|
| Primary | `AppColors.primary` | `#1E713D` |
| Primary Light | `AppColors.primaryLight` | `#D4EDDA` |
| Surface | `AppColors.surface` | `#FFFFFF` |
| Background | `AppColors.background` | `#F5F7F5` |
| Error | `AppColors.error` | `#D32F2F` |
| Text Primary | `AppColors.textPrimary` | `#1A1A1A` |
| Text Secondary | `AppColors.textSecondary` | `#6B6B6B` |

### Typography Strategy

Use `google_fonts` Poppins (already listed). Define scale:
- `Display`: 28sp / Bold
- `Headline`: 22sp / SemiBold
- `Body`: 16sp / Regular
- `Caption`: 12sp / Regular
- `Label`: 14sp / Medium

### Motion Strategy

- Screen transitions: Cupertino-style slide (right→left) for forward navigation
- Card entries: Fade + slide-up (200ms, `Curves.easeOut`)
- Loading states: Lottie animation (already a dependency — use it consistently)
- CTA buttons: Scale-down on press (`0.97x`, 100ms)

### Accessibility Requirements

- Minimum touch target: 48×48dp (Material standard)
- Color contrast ratio: ≥ 4.5:1 for all text
- All interactive elements must have `Semantics` labels
- Support system font size scaling

---

## PHASE 8 — RISK ANALYSIS

### Risk Register

| Risk | Category | Severity | Mitigation |
|---|---|---|---|
| Firestore rules expired — production data denied | Technical | **CRITICAL** | Rewrite rules today. Ward-scoped user access only |
| JWT token not persisted — users re-login every session | Technical | **CRITICAL** | Implement `flutter_secure_storage` persistence immediately |
| API server on free PythonAnywhere tier | Infrastructure | **HIGH** | Migrate to a scalable host before go-live |
| `print()` leaks PII and tokens in logs | Security | **HIGH** | Audit and replace all `print()` calls before release |
| No automated tests exist | Maintenance | **HIGH** | Add widget tests for booking wizard; unit tests for providers |
| Provider holds `TextEditingController` | Technical | **MEDIUM** | Move controllers to `StatefulWidget` or a dedicated form state |
| Real-time tracking is a one-shot future, not a stream | Technical | **HIGH** | Redesign `LocationProvider` and `CollectorProvider` |
| `waste_model.dart` placed inside `Screens.dart/` folder | Maintenance | **MEDIUM** | Move to `lib/models/`. Models must not live in the screen directory |
| Inconsistent naming (`AddOrder_Screen`, `spalsh_screen`) | Maintenance | **LOW** | Establish and enforce `snake_case` for all files |
| No error boundary / global error handler | Technical | **MEDIUM** | Add `FlutterError.onError` and `PlatformDispatcher.onError` handlers |
| Commented-out code (50%+ of `register_provider.dart`) | Maintenance | **LOW** | Delete dead code; use Git for history |

---

## PHASE 9 — FOUNDATION BLUEPRINT

### Recommended Architecture

**MVVM + Repository Pattern with Riverpod**

```
UI (View) → Riverpod Notifier (ViewModel) → Repository → Data Source (REST / Firebase / SQLite)
```

### Recommended Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_strings.dart
│   ├── errors/
│   │   └── app_exceptions.dart
│   ├── network/
│   │   └── api_client.dart          # Central http client with timeout, headers, interceptors
│   ├── storage/
│   │   ├── secure_storage.dart
│   │   └── local_db.dart
│   └── utils/
│       ├── logger.dart
│       └── validators.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── auth_remote_datasource.dart
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   └── presentation/
│   │       ├── notifiers/
│   │       │   └── auth_notifier.dart
│   │       └── screens/
│   │           ├── welcome_screen.dart
│   │           ├── login_screen.dart
│   │           ├── register_screen.dart
│   │           └── otp_screen.dart
│   ├── booking/
│   │   ├── data/
│   │   │   └── booking_repository.dart
│   │   ├── models/
│   │   │   ├── waste_model.dart
│   │   │   └── booking_model.dart
│   │   └── presentation/
│   │       ├── notifiers/
│   │       │   └── booking_notifier.dart
│   │       └── screens/
│   │           ├── select_ward_screen.dart
│   │           ├── waste_screen.dart
│   │           ├── pickup_screen.dart
│   │           └── booking_confirmation_screen.dart
│   ├── tracking/
│   │   ├── data/
│   │   │   └── tracking_repository.dart
│   │   └── presentation/
│   │       ├── notifiers/
│   │       │   └── tracking_notifier.dart
│   │       └── screens/
│   │           ├── track_screen.dart
│   │           └── collector_screen.dart
│   ├── history/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── orders_screen.dart
│   │           ├── order_history_screen.dart
│   │           └── bill_screen.dart
│   └── profile/
│       └── presentation/
│           └── screens/
│               ├── profile_screen.dart
│               ├── account_screen.dart
│               └── settings_screen.dart
├── shared/
│   └── widgets/
│       ├── custom_bottom_nav.dart
│       ├── loading_overlay.dart
│       └── error_snackbar.dart
├── routing/
│   └── app_router.dart              # GoRouter or auto_route
├── firebase_options.dart
└── main.dart
```

### Recommended Technology Stack

| Layer | Technology | Reason |
|---|---|---|
| Framework | Flutter 3.9+ (Dart 3) | Existing; correct choice |
| State Management | **Riverpod 2.x** (code-gen) | Replaces Provider |
| Navigation | **GoRouter** | Type-safe, deep-link ready, replaces `MaterialApp.routes` |
| Networking | `http` + central `ApiClient` wrapper | Existing package; needs abstraction |
| Auth Backend | Firebase Auth | Existing; keep |
| App Backend | `suchigoapi.pythonanywhere.com` | Keep short-term; plan migration |
| Real-time | Firebase Realtime Database or WebSocket | Replace one-shot location fetch |
| Local Cache | `sqflite` + migrations | Existing; add migrations |
| Secure Storage | `flutter_secure_storage` | New; for JWT/token storage |
| Code Generation | `json_serializable` + `build_runner` | Formal model serialization |
| Background Tasks | `workmanager` | Booking status sync |
| Push Notifications | `firebase_messaging` | New dependency required |
| Analytics | `firebase_analytics` | Zero-cost; already on Firebase |
| Logging | `logger` package | Replaces all `print()` calls |

### Recommended Dependencies to Add

```yaml
# State
flutter_riverpod: ^2.5.x
riverpod_annotation: ^2.3.x

# Navigation
go_router: ^13.x.x

# Secure Storage
flutter_secure_storage: ^9.x.x

# Code Generation
json_serializable: ^6.x.x
json_annotation: ^4.x.x

# Push Notifications
firebase_messaging: ^15.x.x
firebase_analytics: ^11.x.x

# Background
workmanager: ^0.5.x

# Logging
logger: ^2.x.x

# dev_dependencies
build_runner: ^2.x.x
riverpod_generator: ^2.x.x
custom_lint: ^0.6.x
riverpod_lint: ^2.x.x
```

### Recommended Development Order

```
Sprint 0 — CRITICAL FIXES (Do before anything else)
  1. Fix Firestore security rules (P0 — currently broken)
  2. Implement flutter_secure_storage for JWT persistence (P0)
  3. Remove all print() PII leaks (P0)
  4. Add request timeouts to all http calls

Sprint 1 — ARCHITECTURAL FOUNDATION
  5. Introduce folder structure (feature-first)
  6. Create ApiClient with base URL, headers, timeout
  7. Create AppColors, AppTypography constants
  8. Migrate to GoRouter

Sprint 2 — RIVERPOD MIGRATION
  9. Migrate auth providers (LoginProvider, RegisterProvider)
  10. Migrate booking wizard providers
  11. Add json_serializable to all models

Sprint 3 — REAL-TIME & NOTIFICATIONS
  12. Replace one-shot location fetch with stream
  13. Implement FCM push notifications
  14. Add Firebase Analytics events

Sprint 4 — OFFLINE & POLISH
  15. Implement SQLite read-cache for orders/billing
  16. Add workmanager background sync
  17. Performance profiling + DevTools audit
```

### Future Expansion Paths

| Path | Trigger | Technology |
|---|---|---|
| Admin/Supervisor Web Dashboard | Municipal contract expansion | Flutter Web or Next.js |
| Collector Mobile App | Field worker onboarding | Separate Flutter app, shared models package |
| Real-time Fleet Tracking | Multi-collector wards | Firebase Realtime DB + Google Maps SDK |
| Payment Integration | Billing goes digital | Razorpay / Stripe Flutter SDK |
| Multi-language Support | Non-English ward rollout | `flutter_localizations` + ARB files |
| Backend Migration | PythonAnywhere scaling ceiling hit | Cloud Run (Django) or Railway |

---

## PHASE 10 — EXECUTIVE SUMMARY

### Scores

| Dimension | Score | Rationale |
|---|---|---|
| **Architecture** | **42 / 100** | MVP-level. No repository layer. Provider anti-patterns. Critical security gaps. |
| **Complexity** | **61 / 100** | Appropriately complex for domain. But complexity is unmanaged. |
| **Scalability** | **35 / 100** | Free-tier backend. Global provider tree. No offline strategy. |
| **Security** | **28 / 100** | Expired Firestore rules. No token persistence. PII in logs. |
| **Maintainability** | **38 / 100** | No tests. Dead code. Models inside screen folder. Inconsistent naming. |

---

### Recommended Architecture

**Feature-First MVVM with Riverpod + Repository Pattern**

Each feature is a self-contained module. Data flows strictly downward: Screen → Notifier → Repository → DataSource. Riverpod manages all DI and state lifecycle.

---

### Why This Architecture Was Chosen

1. **Riverpod over Provider** — Solves the global rebuild problem, enables auto-dispose, and provides compile-time safety that `ChangeNotifier` cannot offer.
2. **Feature-first over layer-first** — The current `Screens.dart/` + `provider/` split forces cross-feature coupling. Feature modules enforce clear ownership boundaries.
3. **Repository layer** — The API URL must never live in a notifier. The repository is the single, testable contract between business logic and data.
4. **GoRouter** — The current `MaterialApp.routes` map cannot handle deep links, auth guards, or nested navigation needed for the tracking and booking sub-flows.

---

### What Was Rejected

| Option | Reason |
|---|---|
| **Bloc** | Excessive boilerplate for this team size and feature complexity |
| **Isar / Hive** | `sqflite` is already integrated and well-understood. Switching adds risk with low return |
| **Domain/Use Case layer** | Premature abstraction. Business logic is not complex enough to justify it yet |
| **Full Firestore migration** | The existing custom REST API (`suchigoapi.pythonanywhere.com`) is an asset — do not abandon it. Firestore should complement, not replace |
| **Redux** | Catastrophic overkill. Rejected without deliberation |

---

### Risks (Top 5)

| # | Risk | Action |
|---|---|---|
| 1 | Firestore rules expired — production broken | **Fix today** |
| 2 | JWT not persisted — UX broken on restart | **Fix this sprint** |
| 3 | API backend on free hosting tier | Plan migration to Cloud Run |
| 4 | PII printed in logs | Audit and remove before TestFlight/Play testing |
| 5 | Zero test coverage | Add tests for booking wizard and auth flows |

---

### Next Actions

> [!IMPORTANT]
> **Before writing a single line of feature code, complete Sprint 0 critical fixes.** The app has a security hole (expired Firestore rules) and a UX hole (no token persistence) that invalidate all other work.

1. ✅ **Approve this architecture document**
2. 🔴 **Fix Firestore security rules** (write ward-scoped rules)
3. 🔴 **Implement `flutter_secure_storage`** for token persistence
4. 🔴 **Audit all `print()` calls** — remove or replace with `logger`
5. 🟡 **Begin folder restructure** (feature-first layout)
6. 🟡 **Introduce `ApiClient`** wrapper class
7. 🟡 **Migrate to Riverpod**
8. 🟡 **Introduce `GoRouter`**

---

*STOP. No code has been generated. This document contains architecture decisions only. Await explicit approval before implementation begins.*
