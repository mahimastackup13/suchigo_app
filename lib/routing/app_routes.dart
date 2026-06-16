/// Centralised route name constants.
///
/// Using named routes eliminates magic strings from the codebase.
/// All navigation should use [AppRoutes.X] rather than raw string paths.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String bills = '/bills';
  static const String pickups = '/pickups';
  static const String addresses = '/addresses';
  static const String settings = '/settings';
}
