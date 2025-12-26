
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:suchigo_app/Screens.dart/login_screen.dart';
// // import 'otp_screen.dart'; // No longer needed as navigation is handled in AuthProvider
// import 'package:suchigo_app/provider/auth_provider.dart'; 

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }


// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController _inputController = TextEditingController();
//   final String _countryCode = "+91";

//   void _validateAndProceed() async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     String input = _inputController.text.trim();
    
//     bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
//     bool isPhone = RegExp(r'^\d{10}$').hasMatch(input);

//     if (!isEmail && !isPhone) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter a valid email or 10-digit phone number")));
//       return;
//     }

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.startAuthentication(context, input, isEmail);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final h = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Container(
//         width: double.infinity, height: double.infinity,
//         color: const Color(0xFFEAF7EA),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 40),
//                   child: Image.asset('assets/images/signin.png', height: h * 0.35, fit: BoxFit.cover),
//                 ),
//                 const SizedBox(height: 30),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 6))],
//                   ),
//                   child: Column(
//                     children: [
//                       const Text('Enter email or number to continue', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 20),
//                       TextField(
//                         controller: _inputController,
//                         decoration: InputDecoration(
//                           hintText: 'Email or Phone Number',
//                           prefixIcon: const Icon(Icons.atm_rounded),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       SizedBox(
//                         width: 250, height: 60,
//                         child: ElevatedButton(
//                           onPressed: authProvider.isLoading ? null : _validateAndProceed,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: authProvider.isLoading ? Colors.grey.shade400 : const Color(0xFF545454),
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
//                           ),
//                           child: authProvider.isLoading 
//                             ? const CircularProgressIndicator(color: Colors.white)
//                             : const Text('Sign in', style: TextStyle(fontSize: 20, color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                    const SizedBox(height: 25),


//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const LoginScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Already have an account?',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),               
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }