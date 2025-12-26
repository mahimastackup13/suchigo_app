
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/material.dart';
// import '../Screens.dart/otp_screen.dart';

// class AuthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
//   bool _isLoading = false;
//   String? _errorMessage;

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void setLoading(bool status) {
//     _isLoading = status;
//     notifyListeners();
//   }

//   // Unified authentication starter
//   Future<void> startAuthentication(BuildContext context, String input, bool isEmail) async {
//     setLoading(true);
//     _errorMessage = null;

//     if (isEmail) {
//       try {
//         // Call the 'sendEmailOTP' Cloud Function you deployed
//         await _functions.httpsCallable('sendEmailOTP').call({'email': input});
//         setLoading(false);
//         if (context.mounted) {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (_) => OtpScreen(
//               identifier: input, 
//               isEmail: true, 
//               verificationId: 'email_flow',
//             ),
//           ));
//         }
//       } catch (e) {
//         setLoading(false);
//         _errorMessage = e.toString();
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Email Error: $_errorMessage")),
//           );
//         }
//       }
//     } else {
//       // Standard Phone Auth
//       await signInWithPhoneNumber(context, input, "+91");
//     }
//   }

//   Future<void> signInWithPhoneNumber(BuildContext context, String phoneNumber, String countryCode) async {
//     final fullPhoneNumber = countryCode + phoneNumber;

//     await _auth.verifyPhoneNumber(
//       phoneNumber: fullPhoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         setLoading(false);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         setLoading(false);
//         _errorMessage = e.message;
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Phone Error: ${e.message}")),
//           );
//         }
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setLoading(false);
//         if (context.mounted) {
//           Navigator.of(context).push(MaterialPageRoute(
//             builder: (_) => OtpScreen(
//               identifier: phoneNumber, 
//               verificationId: verificationId, 
//               isEmail: false,
//             ),
//           ));
//         }
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         setLoading(false);
//       },
//       timeout: const Duration(seconds: 60),
//     );
//   }

//   // Unified OTP verification
//   Future<bool> verifyOtp(BuildContext context, String verificationId, String code, bool isEmail, String identifier) async {
//     try {
//       if (isEmail) {
//         // Verify Email OTP via Cloud Function
//         final result = await _functions.httpsCallable('verifyEmailOTP').call({
//           'email': identifier,
//           'code': code,
//         });

//         String customToken = result.data['token'];
//         await _auth.signInWithCustomToken(customToken);
//         return true;
//       } else {
//         // Verify Phone OTP via Firebase
//         final credential = PhoneAuthProvider.credential(
//           verificationId: verificationId, 
//           smsCode: code,
//         );
//         await _auth.signInWithCredential(credential);
//         return true;
//       }
//     } catch (e) {
//       _errorMessage = e.toString();
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Verification Failed: $_errorMessage")),
//         );
//       }
//       return false;
//     }
//   }
// }