/// User-facing string constants for the SuchiGo application.
///
/// Centralises all UI text to avoid scattered string literals across screens.
/// Simplifies future localisation (replace with ARB/intl when multi-language
/// support is needed).
///
/// Error messages from [AppError.userMessage] are canonical — this file holds
/// both standard UI strings and error UI strings.
abstract final class AppStrings {
  // ---------------------------------------------------------------------------
  // App Identity
  // ---------------------------------------------------------------------------
  static const String appName = 'SuchiGo';
  static const String appTagline = 'Schedule. Collect. Sustain';

  // ---------------------------------------------------------------------------
  // Auth Screens
  // ---------------------------------------------------------------------------
  static const String welcomeTitle = 'Welcome to SuchiGo';
  static const String loginTitle = 'Login';
  static const String registerTitle = 'Create Account';
  static const String otpTitle = 'Verify OTP';
  static const String loginButton = 'Login';
  static const String registerButton = 'Register';
  static const String verifyButton = 'Verify';
  static const String logoutButton = 'Logout';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount = "Don't have an account? ";
  static const String hasAccount = 'Already have an account? ';
  static const String signUpLink = 'Sign Up';
  static const String signInLink = 'Sign In';
  static const String termsAgreement = 'I agree to the Terms & Conditions';

  // ---------------------------------------------------------------------------
  // Form Labels
  // ---------------------------------------------------------------------------
  static const String usernameLabel = 'Username';
  static const String usernameFormatLabel = 'Username (letters, numbers, dots, underscores only)';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String passwordMinLengthLabel = 'Password (minimum 8 characters)';
  static const String firstNameLabel = 'First Name';
  static const String lastNameLabel = 'Last Name';
  static const String phoneLabel = 'Phone Number';
  static const String addressLabel = 'Address';
  static const String landmarkLabel = 'Landmark';
  static const String pincodeLabel = 'Pincode';
  static const String commentsLabel = 'Comments';
  static const String wardLabel = 'Ward';

  // ---------------------------------------------------------------------------
  // Booking Flow
  // ---------------------------------------------------------------------------
  static const String selectWard = 'Select Ward';
  static const String selectWaste = 'Select Waste Type';
  static const String schedulePickup = 'Schedule Pickup';
  static const String confirmBooking = 'Confirm Booking';
  static const String bookNow = 'Book Now';
  static const String continueButton = 'Continue';
  static const String submitButton = 'Submit';
  static const String selectDate = 'Select Date';
  static const String selectTime = 'Select Time';

  // ---------------------------------------------------------------------------
  // Waste Categories
  // ---------------------------------------------------------------------------
  static const String wasteHazardous = 'Hazardous';
  static const String wasteGeneral = 'General';
  static const String wasteRecyclable = 'Recycle';
  static const String wasteFoodWaste = 'Food Waste';

  // ---------------------------------------------------------------------------
  // Dashboard
  // ---------------------------------------------------------------------------
  static const String homeTab = 'Home';
  static const String settingsTab = 'Settings';
  static const String profileTab = 'Profile';
  static const String ordersTitle = 'Orders';
  static const String historyTitle = 'History';
  static const String billsTitle = 'Bills';
  static const String addLocation = 'Add location';
  static const String wasteActivity = 'Your waste activity';

  // ---------------------------------------------------------------------------
  // Tracking
  // ---------------------------------------------------------------------------
  static const String trackingTitle = 'Track Collector';
  static const String collectorProfile = 'Collector Profile';
  static const String estimatedArrival = 'Estimated Arrival';

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------
  static const String accountSettings = 'Account Settings';
  static const String contactUs = 'Contact Us';
  static const String saveChanges = 'Save Changes';

  // ---------------------------------------------------------------------------
  // State Messages
  // ---------------------------------------------------------------------------
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String noData = 'No data available';
  static const String offlineBanner = 'You are offline. Showing cached data.';
  static const String syncPending = 'Changes will sync when online.';
  static const String syncComplete = 'All changes synced.';
  static const String syncFailed = 'Some changes failed to sync.';

  // ---------------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------------
  static const String profileSaved = 'Profile Saved!';
  static const String profileSaveFailed = 'Failed to save profile';
  static const String bookingConfirmed = 'Booking confirmed!';
  static const String pickupDetailsRequired = 'Please enter all pickup details.';

  // ---------------------------------------------------------------------------
  // Error Messages
  // ---------------------------------------------------------------------------
  static const String errorNoInternet = 'No internet connection. Please check your network.';
  static const String errorTimeout = 'The server took too long to respond. Please try again.';
  static const String errorServer = 'Something went wrong on our end. Please try later.';
  static const String errorParse = 'We received an unexpected response. Please try again.';
  static const String errorInvalidCredentials = 'Incorrect username or password.';
  static const String errorTokenExpired = 'Your session has expired. Please log in again.';
  static const String errorTokenNotFound = 'Please log in to continue.';
  static const String errorOtpExpired = 'Your verification code has expired. Please request a new one.';
  static const String errorRegistrationFailed = 'Registration failed. Please try again.';
  static const String errorFieldRequired = 'is required.';
  static const String errorInvalidEmail = 'Please enter a valid email address.';
  static const String errorInvalidPhone = 'Please enter a valid phone number with country code (e.g., +91...).';
  static const String errorInvalidDate = 'Please select a future date for pickup.';
  static const String errorDbRead = 'Failed to load data. Please try again.';
  static const String errorDbWrite = 'Failed to save data. Please try again.';
  static const String errorSecureStorage = 'A secure storage error occurred. Please restart the app.';
  static const String errorPermissionDenied = 'Location access is required to track your collector.';
  static const String errorPermissionPermanentlyDenied = 'Location access is permanently denied. Please enable it in Settings.';
  static const String errorLocationUnavailable = 'Location services are unavailable. Please enable GPS.';
  static const String errorUnknown = 'An unexpected error occurred. Please try again.';
}
