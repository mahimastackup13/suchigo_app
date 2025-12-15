// Hypothetical AuthProvider structure

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens.dart/otp_screen.dart'; 
// ... other imports

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  Future<void> signInWithPhoneNumber(BuildContext context, String phoneNumber, String countryCode) async {
    setLoading(true);
    _errorMessage = null;

    final fullPhoneNumber = countryCode + phoneNumber;

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieve/Sign-in on Android
        // This is usually handled automatically, but if it happens, you'd complete sign-in here.
        await _auth.signInWithCredential(credential);
        setLoading(false);
        // Navigate to HomeScreen or Registration if user is new.
      },
      verificationFailed: (FirebaseAuthException e) {
        setLoading(false);
        _errorMessage = e.message;
        notifyListeners();
        // Show error message via Snackbar
      },
      codeSent: (String verificationId, int? resendToken) async {
        setLoading(false);
        // ⭐ CRITICAL: Navigate to OtpScreen, passing the verificationId
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                phoneNumber: phoneNumber,
                verificationId: verificationId, // Pass the ID
              ),
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // ⭐ CRITICAL: Method for OtpScreen to call
  Future<bool> verifySmsCode(BuildContext context, String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // User successfully signed in
        _errorMessage = null;
        notifyListeners();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred during verification.';
      notifyListeners();
      return false;
    }
  }
}