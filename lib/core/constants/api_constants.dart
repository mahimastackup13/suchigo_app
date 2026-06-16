/// API configuration constants for all backend endpoints.
///
/// Base URLs and endpoint paths are centralised here. In production,
/// [baseUrlAuth] should be injected via `--dart-define` instead of
/// hardcoded, but the paths remain constant.
///
/// Verified backend topology (from Postman API collection):
/// - Primary API:     suchigoapi.pythonanywhere.com
/// - Location server: suchigo.pythonanywhere.com
/// - Collector:       separate local instance
abstract final class ApiConstants {
  // ---------------------------------------------------------------------------
  // Base URLs
  // ---------------------------------------------------------------------------

  /// Primary API backend (auth, profile, bills, pickups, addresses, settings).
  static const String baseUrlAuth = String.fromEnvironment(
    'AUTH_BASE_URL',
    defaultValue: 'https://suchigoapi.pythonanywhere.com',
  );

  /// Collector and location management backend.
  static const String baseUrlLocation = String.fromEnvironment(
    'LOCATION_BASE_URL',
    defaultValue: 'https://suchigo.pythonanywhere.com',
  );

  // ---------------------------------------------------------------------------
  // Auth Endpoints (no authentication required)
  // ---------------------------------------------------------------------------

  /// POST — authenticate user, receive token.
  static const String loginPath = '/api/login/';

  /// POST — register new user account.
  /// Body: username, email, password, first_name, last_name
  static const String registerPath = '/api/register/';

  // ---------------------------------------------------------------------------
  // User Endpoints (require Token auth)
  // ---------------------------------------------------------------------------

  /// GET — fetch authenticated user profile.
  static const String profilePath = '/api/profile/';

  /// GET — home dashboard data.
  static const String homePath = '/api/home/';

  /// GET — user application settings.
  static const String settingsPath = '/api/settings/';

  // ---------------------------------------------------------------------------
  // Bills Endpoints (require Token auth)
  // ---------------------------------------------------------------------------

  /// GET — list all bills. POST — create a new bill.
  static const String billsPath = '/api/bills/';

  // ---------------------------------------------------------------------------
  // Pickups Endpoints (require Token auth)
  // ---------------------------------------------------------------------------

  /// GET — list all scheduled pickups. POST — schedule a new pickup.
  static const String pickupsPath = '/api/pickups/';

  // ---------------------------------------------------------------------------
  // Addresses Endpoints (require Token auth)
  // ---------------------------------------------------------------------------

  /// GET — list saved addresses. POST — add a new address.
  static const String addressesPath = '/api/addresses/';

  // ---------------------------------------------------------------------------
  // Collector / Location Endpoints
  // ---------------------------------------------------------------------------

  /// GET — list all collector locations.
  static const String locationsPath = '/api/locations/';

  /// GET/POST — waste entries (separate collector backend).
  static const String wasteEntriesPath = '/api/waste-entries/';

  // ---------------------------------------------------------------------------
  // Timeouts
  // ---------------------------------------------------------------------------

  /// Default request timeout for all HTTP calls.
  static const Duration requestTimeout = Duration(seconds: 15);

  // ---------------------------------------------------------------------------
  // Headers
  // ---------------------------------------------------------------------------

  /// Standard JSON content type header.
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // ---------------------------------------------------------------------------
  // URI Builders
  // ---------------------------------------------------------------------------

  /// Constructs a full [Uri] for the primary API backend.
  static Uri authUri(String path) => Uri.parse('$baseUrlAuth$path');

  /// Constructs a full [Uri] for the location/collector backend.
  static Uri locationUri(String path) => Uri.parse('$baseUrlLocation$path');
}
