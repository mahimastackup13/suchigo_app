// // 
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'register_screen.dart';
// import '../provider/auth_provider.dart'; 

// class OtpScreen extends StatefulWidget {
//   final String identifier; 
//   final String verificationId;
//   final bool isEmail;

//   const OtpScreen({
//     super.key, 
//     required this.identifier, 
//     required this.verificationId, 
//     required this.isEmail,
//   });

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
//   int secondsRemaining = 60;
//   Timer? timer;
//   bool isOtpComplete = false;

//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           if (secondsRemaining > 0) {
//             secondsRemaining--;
//           } else {
//             timer.cancel();
//           }
//         });
//       }
//     });
//   }

//   void moveToNext(int index, String value) {
//     if (value.isNotEmpty) {
//       if (index < 5) {
//         FocusScope.of(context).nextFocus();
//       }
//     } else {
//       if (index > 0) {
//         FocusScope.of(context).previousFocus();
//       }
//     }
    
//     setState(() {
//       isOtpComplete = otpControllers.every((controller) => controller.text.isNotEmpty);
//     });
//   }

//   Future<void> verifyOtp() async {
//     final String otp = otpControllers.map((e) => e.text).join();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     authProvider.setLoading(true);
//     // Passing identifier (email) is required for the Cloud Function verification
//     bool success = await authProvider.verifyOtp(
//       context, 
//       widget.verificationId, 
//       otp, 
//       widget.isEmail, 
//       widget.identifier,
//     );
//     authProvider.setLoading(false);

//     if (success && mounted) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => const RegisterScreen()),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
    
//     // UI Masking logic
//     String displayIdentifier = widget.isEmail 
//         ? widget.identifier 
//         : "+91 ${widget.identifier.substring(0, 2)}******${widget.identifier.substring(8)}";

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Enter the code", 
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text.rich(
//                 TextSpan(children: [
//                   const TextSpan(text: "We sent the code to ", style: TextStyle(color: Colors.grey)),
//                   TextSpan(
//                     text: displayIdentifier, 
//                     style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//                   ),
//                 ]),
//               ),
//               const SizedBox(height: 20),
              
//               // OTP Input Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(6, (index) => _otpBox(index)),
//               ),
              
//               const SizedBox(height: 20),
//               Text(
//                 secondsRemaining > 0 
//                     ? "Resend code in $secondsRemaining seconds" 
//                     : "I didn't receive a code",
//                 style: const TextStyle(color: Colors.grey),
//               ),

//               const Spacer(),
              
//               SizedBox(
//                 width: double.infinity, 
//                 height: 60,
//                 child: ElevatedButton(
//                   onPressed: (isOtpComplete && !authProvider.isLoading) ? verifyOtp : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: (isOtpComplete && !authProvider.isLoading) 
//                         ? const Color(0xFF545454) 
//                         : Colors.grey.shade400,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: authProvider.isLoading 
//                     ? const SizedBox(
//                         height: 24, width: 24,
//                         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                       )
//                     : const Text(
//                         "CONTINUE", 
//                         style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _otpBox(int index) {
//     return SizedBox(
//       height: 50, width: 45,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1), 
//               blurRadius: 6, 
//               offset: const Offset(0, 3),
//             )
//           ],
//         ),
//         child: TextField(
//           controller: otpControllers[index],
//           keyboardType: TextInputType.number,
//           textAlign: TextAlign.center,
//           maxLength: 1,
//           onChanged: (value) => moveToNext(index, value),
//           decoration: const InputDecoration(
//             counterText: "", 
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     );
//   }
// }