/// API configuration constants for all backend endpoints.
///
/// Base URLs and endpoint paths are centralised here. In production,
/// [baseUrlAuth] should be injected via `--dart-define` instead of
/// hardcoded, but the paths remain constant.
///
/// Discovered backend topology (from API Contract Report):
/// - Auth server:     suchigoapi.pythonanywhere.com
/// - Location server: suchigo.pythonanywhere.com
/// - Waste server:    clone2026.pythonanywhere.com (partially broken)
abstract final class ApiConstants {
  // ---------------------------------------------------------------------------
  // Base URLs
  // ---------------------------------------------------------------------------

  /// Auth and user management backend.
  /// Override via: `--dart-define=AUTH_BASE_URL=https://...`
  static const String baseUrlAuth = String.fromEnvironment(
    'AUTH_BASE_URL',
    defaultValue: 'https://suchigoapi.pythonanywhere.com',
  );

  /// Collector and location management backend.
  /// Override via: `--dart-define=LOCATION_BASE_URL=https://...`
  static const String baseUrlLocation = String.fromEnvironment(
    'LOCATION_BASE_URL',
    defaultValue: 'https://suchigo.pythonanywhere.com',
  );

  /// Waste entries backend (note: /api/waste-entries/ returned 404 in testing).
  /// Override via: `--dart-define=WASTE_BASE_URL=https://...`
  static const String baseUrlWaste = String.fromEnvironment(
    'WASTE_BASE_URL',
    defaultValue: 'https://clone2026.pythonanywhere.com',
  );

  // ---------------------------------------------------------------------------
  // Auth Endpoints
  // ---------------------------------------------------------------------------

  /// POST — authenticate user, receive token.
  static const String loginPath = '/api/login/';

  /// POST — register new user account.
  static const String registerPath = '/api/register/';

  // ---------------------------------------------------------------------------
  // Location / Collector Endpoints
  // ---------------------------------------------------------------------------

  /// GET — list all collector locations.
  /// POST — create/update a collector location record.
  static const String locationsPath = '/api/locations/';

  // ---------------------------------------------------------------------------
  // Waste Endpoints (partially broken — verify before use)
  // ---------------------------------------------------------------------------

  /// GET — list waste entries. POST — create waste entry.
  static const String wasteEntriesPath = '/api/waste-entries/';

  // ---------------------------------------------------------------------------
  // Future Endpoints (not yet implemented server-side)
  // ---------------------------------------------------------------------------

  /// POST — submit booking. GET — list user's bookings.
  static const String bookingsPath = '/api/bookings/';

  /// GET — list order history.
  static const String ordersPath = '/api/orders/';

  /// GET — list billing records.
  static const String billsPath = '/api/bills/';

  /// GET — fetch user profile. PUT — update user profile.
  static const String profilePath = '/api/profile/';

  /// GET — list available wards.
  static const String wardsPath = '/api/wards/';

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
  // Helpers
  // ---------------------------------------------------------------------------

  /// Constructs a full URL for an auth endpoint.
  static Uri authUri(String path) => Uri.parse('$baseUrlAuth$path');

  /// Constructs a full URL for a location endpoint.
  static Uri locationUri(String path) => Uri.parse('$baseUrlLocation$path');

  /// Constructs a full URL for a waste endpoint.
  static Uri wasteUri(String path) => Uri.parse('$baseUrlWaste$path');
}
