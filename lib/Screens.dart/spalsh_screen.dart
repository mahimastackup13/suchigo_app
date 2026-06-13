// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:suchigo_app/Screens.dart/welcome_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   late Animation<Offset> _topSlideAnim;
//   late Animation<Offset> _bottomSlideAnim;
//   late Animation<double> _logoScaleAnim;
//   late Animation<double> _logoFadeAnim;
//   late Animation<Offset> _logoSlideAnim;
//   late Animation<double> _word1FadeAnim;
//   late Animation<double> _word2FadeAnim;
//   late Animation<double> _word3FadeAnim;
//   late Animation<double> _word1ScaleAnim;
//   late Animation<double> _word2ScaleAnim;
//   late Animation<double> _word3ScaleAnim;

//   @override
//   void initState() {
//     super.initState();

//     // Total animation time is 2000 milliseconds (2 seconds)
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     );

//     // 1. Sliding Green Shape (Top Left)
//     // _topSlideAnim =
//     //     Tween<Offset>(begin: const Offset(1.0, 1.0), end: Offset.zero).animate(
//     //       CurvedAnimation(
//     //         parent: _controller,
//     //         curve: const Interval(0.0, 0.6, curve: Curves.easeInOutCubic),
//     //       ),
//     //     );

//     // // 2. Sliding Blue Shape (Bottom Right)
//     // _bottomSlideAnim =
//     //     Tween<Offset>(
//     //       begin: const Offset(-1.0, -1.0),
//     //       end: Offset.zero,
//     //     ).animate(
//     //       CurvedAnimation(
//     //         parent: _controller,
//     //         curve: const Interval(0.0, 0.6, curve: Curves.easeInOutCubic),
//     //       ),
//     //     );

//     // 3. Logo Sliding, Scaling and Fading
//     _logoSlideAnim =
//         Tween<Offset>(begin: const Offset(-2.0, 0.0), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
//           ),
//         );
//     _logoFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
//       ),
//     );
//     _logoScaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.3, 0.6, curve: Curves.easeOutBack),
//       ),
//     );

//     // 4. Staggered Words
//     _word1FadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
//       ),
//     );
//     _word1ScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.5, 0.7, curve: Curves.easeOutBack),
//       ),
//     );

//     _word2FadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
//       ),
//     );
//     _word2ScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.6, 0.8, curve: Curves.easeOutBack),
//       ),
//     );

//     _word3FadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
//       ),
//     );
//     _word3ScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.7, 1.0, curve: Curves.easeOutBack),
//       ),
//     );

//     // Start the animation
//     _controller.forward();

//     // Navigate to the next screen after the animation finishes and a short pause
//     Timer(const Duration(milliseconds: 3500), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Background Elements
//           // Top Left Green Shape
//           SlideTransition(
//             position: _topSlideAnim,
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Container(
//                 height: size.height * 0.35,
//                 width: size.width * 0.8,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color(0xFF388E3C),
//                       Color(0xFF81C784),
//                     ], // SuchiGo Green shades
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(300),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Bottom Right Blue Shape
//           SlideTransition(
//             position: _bottomSlideAnim,
//             child: Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 height: size.height * 0.35,
//                 width: size.width * 0.8,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color(0xFF64B5F6),
//                       Color(0xFF1976D2),
//                     ], // SuchiGo Blue shades
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(300),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Foreground Content: Logo and Words
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Animated Logo
//                 SlideTransition(
//                   position: _logoSlideAnim,
//                   child: FadeTransition(
//                     opacity: _logoFadeAnim,
//                     child: ScaleTransition(
//                       scale: _logoScaleAnim,
//                       child: Image.asset(
//                         'assets/images/logo.png', // Main SuchiGo logo
//                         width: 250,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // Animated Tagline (Staggered Words)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ScaleTransition(
//                       scale: _word1ScaleAnim,
//                       child: FadeTransition(
//                         opacity: _word1FadeAnim,
//                         child: const Text(
//                           'Schedule. ',
//                           style: TextStyle(
//                             color: Color(0xFF424242), // Dark grey
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ScaleTransition(
//                       scale: _word2ScaleAnim,
//                       child: FadeTransition(
//                         opacity: _word2FadeAnim,
//                         child: const Text(
//                           'Collect. ',
//                           style: TextStyle(
//                             color: Color(0xFF424242),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     ScaleTransition(
//                       scale: _word3ScaleAnim,
//                       child: FadeTransition(
//                         opacity: _word3FadeAnim,
//                         child: const Text(
//                           'Sustain.',
//                           style: TextStyle(
//                             color: Color(0xFF424242),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
