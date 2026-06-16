import 'package:suchigo_app/core/utils/app_logger.dart';

/// Centralised analytics event tracking for SuchiGo.
///
/// Currently backed by [AppLogger] for development. In production, swap
/// the [_send] implementation to use Firebase Analytics or Mixpanel.
///
/// No PII (Personally Identifiable Information) is sent in any event.
/// User IDs are never included. All params are behaviour-level metadata only.
abstract final class AppAnalytics {
  // ---------------------------------------------------------------------------
  // Authentication Events
  // ---------------------------------------------------------------------------

  static void loginSuccess() => _send('login_success');

  static void loginFailure({required String reason}) =>
      _send('login_failure', params: {'reason': reason});

  static void logout() => _send('logout');

  static void registerSuccess() => _send('register_success');

  static void sessionRestored() => _send('session_restored');

  // ---------------------------------------------------------------------------
  // Navigation Events
  // ---------------------------------------------------------------------------

  static void screenView(String screenName) =>
      _send('screen_view', params: {'screen_name': screenName});

  // ---------------------------------------------------------------------------
  // Feature Events
  // ---------------------------------------------------------------------------

  static void pickupCreated() => _send('pickup_created');

  static void billViewed() => _send('bill_viewed');

  static void addressAdded() => _send('address_added');

  static void profileViewed() => _send('profile_viewed');

  // ---------------------------------------------------------------------------
  // Error Events
  // ---------------------------------------------------------------------------

  static void apiFailure({required String endpoint, required int? statusCode}) =>
      _send('api_failure', params: {
        'endpoint': endpoint,
        'status_code': statusCode?.toString() ?? 'unknown',
      });

  static void storageFailure({required String operation}) =>
      _send('storage_failure', params: {'operation': operation});

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------

  /// Logs the event via [AppLogger]. Replace body with SDK call in production.
  static void _send(String event, {Map<String, String>? params}) {
    final paramsStr =
        params != null ? ' | ${params.entries.map((e) => '${e.key}=${e.value}').join(', ')}' : '';
    AppLogger.info('[Analytics] $event$paramsStr');
  }
}
