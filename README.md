# SuchiGo

SuchiGo is a comprehensive waste management and eco-friendly utility tracking application designed to streamline garbage collection, scheduling, and billing for local residents. By integrating real-time tracking, seamless scheduling, and local ward management, SuchiGo modernizes the relationship between citizens and municipal collection services.

## Project Status

- **Current Version:** 1.0.0+7
- **Environment SDK:** Flutter SDK ^3.9.0
- **Development State:** Advanced MVP / Fully Functional Application

## Key Features

- **Seamless Authentication:** Secure login, registration, and OTP verification via Firebase Auth.
- **Waste Management & Pickup:** Intuitive categorization of waste and easy scheduling for pickup services.
- **Real-Time Tracking:** Integration with Geolocator to track waste collector locations and pickup statuses.
- **Ward & Address Selection:** Localized management system allowing users to easily configure their ward and precise collection address.
- **Billing & History:** Comprehensive access to past orders, collection history, and associated billing statements.

## Technology Stack & Dependencies

- **Framework:** Flutter (Dart) for high-performance, cross-platform mobile development.
- **UI & Design:** `cupertino_icons`, `flutter_svg`, `lottie`, `google_fonts`, `gap`, `percent_indicator`, and `material_symbols_icons` to construct a premium, dynamic, and highly responsive visual aesthetic.
- **State Management:** `provider` for robust, scalable state distribution and logic separation across screens.
- **Data & Backend Layer:** `firebase_core`, `firebase_auth`, and `cloud_functions` for backend authentication and cloud functions; `sqflite` for structured local caching; `http` for REST API integrations.
- **Utilities:** `geolocator` for real-time location services, `intl` for complex date/time formatting, and `url_launcher` for securely handling external links.

## Folder Structure

```text
lib/
├── Screens.dart/           # Flat directory containing all UI Screens and Views
│   ├── (auth screens)      # login_screen.dart, register_screen.dart, otp_screen.dart, etc.
│   ├── (dashboard)         # home_screen.dart, mainNav_screen.dart
│   ├── (booking/pickup)    # pickup_screen.dart, waste_screen.dart, select_ward_screen.dart
│   ├── (tracking)          # track_screen.dart, collector_screen.dart
│   ├── (history/billing)   # orders_screen.dart, bill_screen.dart, order_history_screen.dart
│   └── (profile/settings)  # profile_screen.dart, account_screen.dart, settings_screen.dart
├── provider/               # Granular State Management Notifiers (11+ ChangeNotifiers)
├── widgets/                # Reusable UI Components (e.g., custom_bottom_nav.dart)
├── waste_model.dart        # Core Application Data Models
├── firebase_options.dart   # Firebase Environment Configuration
└── main.dart               # Application Entry Point (Theme & MultiProvider setup)
```

## Detailed UI & Screens Breakdown

- **Onboarding & Authentication (Welcome, Login, Register, OTP):** 
  The app entry point begins at the `WelcomeScreen`, establishing the brand identity with the **Poppins** font family. The authentication flow incorporates smooth transitions, clear text-field validation, and instantaneous OTP verification to provide a frictionless login experience, maintaining user trust and engagement from the first click. A Splash Screen (`spalsh_screen.dart`) is also available for initialization loading.
- **Dashboard (Home, MainNav):** 
  The central hub of the application. It features a custom bottom navigation bar, personalized greetings, and interactive cards for quick access to booking, tracking, and account management. Engaging micro-animations provide tactile feedback and create an interface that feels alive.
- **Booking Flow (Waste, Pickup, Ward Selection):** 
  An intuitive step-by-step wizard. Users select their specific ward, categorize their waste visually using interactive icons, and schedule a pickup. The layout is optimized for clarity, utilizing spacing and typography to reduce cognitive load and guide the user naturally to submission.
- **Tracking & Collector Info (Track, Collector):** 
  A highly interactive map and status screen leveraging geolocation. Users receive real-time visual updates on their collector's ETA, with dynamic progress indicators and clear profile cards for the collector, ensuring complete transparency and peace of mind.
- **History & Billing (Orders, Bill, History):** 
  Clean, tabular, and list-based layouts presenting past collections and associated costs. Financial and historical data is elegantly formatted using the `intl` package, providing users with a comprehensive and easy-to-read overview without visual clutter.
- **User Profile & Settings (Profile, Account, Address, Settings):** 
  A dedicated hub for user preferences. Features high-quality avatar placeholders, smooth form editing for address and ward updates, and easily accessible support options (Contact Us). The layout uses logical grouping and subtle dividers to maintain a structured, premium look.

## State Management & Data Layer

- **State Management:** The application utilizes the `provider` package to manage application state predictably. The root `main.dart` injects a highly granular `MultiProvider` containing over 11 specific `ChangeNotifierProviders` (e.g., `LoginProvider`, `PickupProvider`, `LocationProvider`, `BillProvider`). This strict separation of concerns ensures the UI remains declarative, clean, and reactive to specific domain changes without rebuilding unrelated widgets.
- **Data Layer:** Authentication is fully managed by **Firebase Auth**, providing secure, persistent token management. Local, structured data (such as cached user preferences, session data, or offline queues) is efficiently managed via **SQLite** (`sqflite`). External data fetching and integration with third-party municipal systems are handled via RESTful calls using the `http` package.
- **Next Steps:** Future iterations will focus on migrating core user and transactional data entirely to a robust real-time cloud database (like Firebase Firestore or Supabase) to enable seamless cross-device syncing and real-time administrative dashboards for municipal supervisors.

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd suchigo_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:** 
   Ensure you have configured the project via the Firebase CLI. You must have a valid `firebase_options.dart` file correctly linked to your active Firebase project for authentication features to function.

4. **Run the application:**
   ```bash
   flutter run
   ```

## System Architecture & Application Flow (AI Context)

This section provides a strictly mapped overview of the application's flow and state logic, structured specifically for LLMs, AI coding assistants, and automated parsers to instantly understand the repository's context.

### 1. App Navigation Flow

- **Entry Point:** `main.dart` initializes Firebase and injects 11+ ChangeNotifiers via `MultiProvider`. Routes initially to `WelcomeScreen`.
- **Auth Journey:** `WelcomeScreen` -> `LoginScreen` / `RegisterScreen` / `SignInScreen` / `OtpScreen`. Handles Firebase Auth via `LoginProvider` / `RegisterProvider`. Upon success, routes to the core dashboard.
- **Core Navigation (`mainNav_screen.dart`):** Controls the primary Bottom Navigation View routing to: `HomeScreen` (Dashboard), `OrdersScreen`/History, `BillScreen`, and `ProfileScreen`/Account.
- **Booking Flow Journey:** Initiated from `HomeScreen` -> `SelectWardScreen` -> `WasteScreen` (waste categorization) -> `PickupScreen` (scheduling date/time) -> `AddOrder_Screen` -> `BookingConfirmation_Screen` -> `SubmitScreen`.
- **Tracking Journey:** `HomeScreen` -> `TrackScreen` -> Integrates with `CollectorScreen` and `LocationProvider` for real-time map updates.

### 2. State Management Architecture

The app uses a highly decoupled `Provider` pattern. State is strictly segregated by domain:
- **Authentication/User:** `LoginProvider`, `RegisterProvider`, `ProfileProvider`, `SettingsProvider`. Maps directly to `firebase_auth` and secure local storage.
- **Booking Wizard / Core Business:** `WasteProvider`, `PickupProvider`, `AddressDetailsProvider`, `AddressProvider`. These hold the ephemeral state of a user's booking wizard before final submission to the database.
- **Tracking/Geolocation:** `LocationProvider`, `CollectorProvider`. Handles real-time GPS coordinates, `geolocator` streams, and collector metadata.
- **Transactions:** `BillProvider`, `HomeProvider`. Manages fetching and displaying historical transactions and home dashboard metrics.

### 3. Data Flow Pattern

- **UI Layer (`lib/Screens.dart/`):** Exclusively declarative. Listens to Providers via `Consumer` or `context.watch()`. Does NOT hold complex business logic.
- **Provider Layer (`lib/provider/`):** Acts as the Controller/ViewModel. Handles all API calls, SQLite queries (`sqflite`), and Firebase interactions. Updates state and triggers UI rebuilds via `notifyListeners()`.
- **Service/Model Layer:** Interacts with `firebase_core`, `cloud_functions`, and HTTP endpoints, marshaling raw JSON or local DB rows into Dart objects (e.g., `waste_model.dart`).
