// provider/profile_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:suchigo_app/services/api_client.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';

class ProfileProvider extends ChangeNotifier {
  String _displayName = "";
  String _username = "";
  String _phoneNumber = "";
  String _email = "";
  String _profileImagePath = "";
  bool _isLoading = false;

  /// What screens should actually render. Falls back gracefully so the UI
  /// never shows a raw empty string or gets stuck on a hardcoded
  /// placeholder once we have anything real to show.
  String get username {
    if (_displayName.isNotEmpty) return _displayName;
    if (_username.isNotEmpty) return _username;
    return "User";
  }

  String get displayName => _displayName;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get profileImagePath => _profileImagePath;
  bool get isLoading => _isLoading;

  void setUsername(String name) {
    if (name.isNotEmpty) {
      _username = name;
      notifyListeners();
    }
  }

  int _selectedIndex = 3;
  int get selectedIndex => _selectedIndex;

  ProfileProvider({String? profileImagePath})
    : _profileImagePath = profileImagePath ?? "" {
    // Deliberately NOT calling _hydrateProfile() here.
    //
    // This provider is constructed once at app startup by the root
    // MultiProvider in main.dart -- i.e. before anyone has logged in and
    // before there is any token in storage. Auto-hydrating from the
    // constructor means GET /api/profile/ fires unauthenticated on every
    // cold start, races against whatever SplashScreenAuth is doing to
    // decide if the user is logged in, and can trigger a spurious
    // logout/redirect before the splash screen even finishes its own
    // check.
    //
    // Instead, call `refresh()` explicitly from exactly two places:
    //   1. SplashScreenAuth, only if it finds a saved token and is routing
    //      straight to HomeScreen.
    //   2. LoginScreen, right after loginProvider.login() returns true,
    //      before navigating to HomeScreen.
    //
    // Still load whatever's in local cache (no network call) so a
    // returning user with a valid cached display name doesn't flash
    // "User" before refresh() resolves.
    _loadFromCacheOnly();
  }

  Future<void> _loadFromCacheOnly() async {
    final localDisplayName = await SecureStorageService.getDisplayName();
    final localUsername = await SecureStorageService.getUsername();
    final localPhone = await SecureStorageService.getPhoneNumber();
    final localEmail = await SecureStorageService.getEmail();

    bool changed = false;
    if (localDisplayName != null && localDisplayName.isNotEmpty) {
      _displayName = localDisplayName;
      changed = true;
    }
    if (localUsername != null && localUsername.isNotEmpty) {
      _username = localUsername;
      changed = true;
    }
    if (localPhone != null && localPhone.isNotEmpty) {
      _phoneNumber = localPhone;
      changed = true;
    }
    if (localEmail != null && localEmail.isNotEmpty) {
      _email = localEmail;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  /// Call this right after a successful login (e.g. from LoginScreen, right
  /// after `loginProvider.login()` returns true and before navigating to
  /// HomeScreen) and from SplashScreenAuth when a saved token is found, so
  /// the real name is fetched from the backend exactly when we know a
  /// token actually exists.
  Future<void> refresh() => _hydrateProfile();

  Future<void> _hydrateProfile() async {
    // 1. Optimistic UI: make sure cached values are loaded (cheap, local-
    // only; harmless to re-run even though the constructor already did
    // this once).
    await _loadFromCacheOnly();

    // 2. Background sync with the real source of truth: GET /api/profile/.
    // This was previously commented out because it 401'd and triggered a
    // global logout. Both halves of that are now fixed:
    //   - ApiClient now sends "Token <key>" instead of "Bearer <key>", so
    //     this call should actually succeed against TokenAuthentication.
    //   - skipAuthRedirect: true means that even if it somehow still 401s
    //     (e.g. the token genuinely expired), this background sync will
    //     NOT force-navigate the user to /login out from under them. It
    //     just logs and keeps showing the last good cached value. The
    //     global redirect-on-401 behavior still applies normally to
    //     all your other authenticated calls (addresses/, pickups/, etc.)
    //     that don't pass this flag.
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient.instance.get(
        'profile/',
        options: Options(extra: {'skipAuthRedirect': true}),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map<String, dynamic>;

        // Confirmed: your backend uses a single `display_name` field.
        final String? apiDisplayName = data['display_name'] as String?;
        final String? apiUsername = data['username'] as String?;
        final String? apiPhone =
            (data['phone_number'] ?? data['phone']) as String?;
        final String? apiEmail = data['email'] as String?;

        if (apiDisplayName != null && apiDisplayName.isNotEmpty) {
          _displayName = apiDisplayName;
          await SecureStorageService.saveDisplayName(apiDisplayName);
        }
        if (apiUsername != null && apiUsername.isNotEmpty) {
          _username = apiUsername;
          await SecureStorageService.saveUsername(apiUsername);
        }
        if (apiPhone != null && apiPhone.isNotEmpty) {
          _phoneNumber = apiPhone;
          await SecureStorageService.savePhoneNumber(apiPhone);
        }
        if (apiEmail != null && apiEmail.isNotEmpty) {
          _email = apiEmail;
          await SecureStorageService.saveEmail(apiEmail);
        }

        notifyListeners();
      }
    } on DioException catch (e) {
      // Don't blow away good cached data because of a transient or still-
      // misconfigured-endpoint error -- just log it. If this keeps firing,
      // curl the endpoint directly (see backend checklist) before touching
      // this file again.
      debugPrint(
        'Profile sync failed (${e.response?.statusCode}): ${e.message}',
      );
    } catch (e) {
      debugPrint('Profile sync failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearOnLogout() {
    _displayName = "";
    _username = "";
    _phoneNumber = "";
    _profileImagePath = "";
    notifyListeners();
  }

  void onTabTapped(BuildContext context, int index) {
    if (index == _selectedIndex) return;
    _selectedIndex = index;
    notifyListeners();
  }

  void handleProfileItemTap(BuildContext context, String text) {
    // Handle profile item tap
  }
}
