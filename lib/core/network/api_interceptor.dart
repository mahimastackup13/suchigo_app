import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/core/storage/secure_storage.dart';
import 'package:suchigo_app/core/utils/app_logger.dart';

/// Handles cross-cutting authentication concerns for the network layer.
///
/// Responsibilities:
/// - Attach `Authorization: Token <jwt>` header to outbound requests.
/// - Detect 401 responses and trigger session cleanup.
/// - Prevent calling protected endpoints with no stored token.
///
/// Separated from [ApiClient] so it can be unit-tested in isolation and
/// swapped at the DI layer (e.g., for OAuth2 in a future iteration).
class ApiInterceptor {
  final SecureStorage _secureStorage;

  /// Callback invoked when a 401 is received and the session must be cleared.
  ///
  /// In Stage 4, this will be wired to `AuthNotifier.invalidateSession()`.
  /// For Stage 3, it defaults to a no-op log, so the network layer compiles
  /// independently without requiring the auth notifier.
  final void Function()? onSessionExpired;

  ApiInterceptor({
    // ignore: prefer_initializing_formals — field is private, cannot use initializing formal
    required SecureStorage secureStorage,
    this.onSessionExpired,
  }) : _secureStorage = secureStorage;

  // ---------------------------------------------------------------------------
  // Outbound: JWT injection
  // ---------------------------------------------------------------------------

  /// Retrieves the stored JWT and adds it to [headers] in-place.
  ///
  /// Returns [Success(null)] if the header was attached.
  /// Returns [Failure(TokenNotFoundError)] if no token exists, signalling that
  /// the request should be short-circuited before it reaches the network.
  ///
  /// DRF `TokenAuthentication` format: `Authorization: Token <jwt>`
  Future<Result<void>> attachAuthHeader(Map<String, String> headers) async {
    final tokenResult = await _secureStorage.getToken();

    switch (tokenResult) {
      case Success(:final data):
        headers['Authorization'] = 'Token $data';
        AppLogger.debug('Auth header attached.');
        return const Success(null);
      case Failure(:final error):
        AppLogger.warning('No token found. Cannot attach auth header.');
        return Failure(error);
    }
  }

  // ---------------------------------------------------------------------------
  // Inbound: 401 handling
  // ---------------------------------------------------------------------------

  /// Handles a 401 Unauthorized response from the server.
  ///
  /// Clears the stored token and user ID, then notifies the application
  /// layer via [onSessionExpired] to transition UI to the login screen.
  Future<void> handle401() async {
    AppLogger.warning('401 received — clearing session credentials.');
    await _secureStorage.clearAll();

    if (onSessionExpired != null) {
      onSessionExpired!();
    } else {
      AppLogger.warning(
        'onSessionExpired not wired. UI will not redirect automatically.',
      );
    }
  }
}
