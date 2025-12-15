// 
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
// Import your AuthProvider
import '../provider/auth_provider.dart'; // ⭐ Assume AuthProvider is in this path

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  // ⭐ Add verificationId to receive the ID from Firebase after sending OTP
  final String verificationId; 

  const OtpScreen({
    super.key, 
    required this.phoneNumber, 
    required this.verificationId, // ⭐ NEW REQUIRED PARAMETER
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  int secondsRemaining = 60;
  Timer? timer;
  bool isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    // Add listeners to check completion when text changes
    for (var controller in otpControllers) {
      controller.addListener(checkOtpCompletion);
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        // Use setState conditionally to avoid unnecessary rebuilds
        if (mounted) {
          setState(() => secondsRemaining--);
        }
      } else {
        timer.cancel();
      }
    });
  }

  void moveToNext(int index, String value) {
    // Only proceed to the next field if a character was typed
    if (value.length == 1) {
      // Move focus to the next field if it exists
      if (index < 5) {
        FocusScope.of(context).nextFocus();
      }
    } else if (value.isEmpty) {
      // Move focus to the previous field if the user deletes a character
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
    
    // Call checkOtpCompletion to update button state
    checkOtpCompletion();
  }

  void checkOtpCompletion() {
    // Check if all 6 controllers have text
    bool allFilled = otpControllers.every(
      (controller) => controller.text.length == 1,
    );

    // Only update state if the completion status actually changes
    if (allFilled != isOtpComplete) {
      setState(() {
        isOtpComplete = allFilled;
      });
    }
  }

  // ⭐ UPDATED FOR FIREBASE AUTHENTICATION
  Future<void> verifyOtp() async {
    // Combine the text from all controllers into a single OTP string
    final String otp = otpControllers.map((e) => e.text).join();

    if (otp.length != 6) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter the full 6-digit OTP")),
        );
      }
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Start loading state (if your provider has one)
    authProvider.setLoading(true);

    final bool isSuccess = await authProvider.verifySmsCode(
      context, // Pass context for navigation/snackbar if needed in provider
      widget.verificationId,
      otp,
    );

    authProvider.setLoading(false); // Stop loading

    if (isSuccess && mounted) {
      // Navigate to Register Screen upon successful Firebase sign-in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    } else if (mounted) {
      // Error handling (handled by AuthProvider, but a final fallback)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? "Invalid OTP or unexpected error."),
          backgroundColor: Colors.red,
        ),
      );
      // Clear OTP fields on failure
      for (var controller in otpControllers) {
        controller.clear();
      }
    }
  }


  @override
  void dispose() {
    timer?.cancel();
    for (var controller in otpControllers) {
      controller.removeListener(checkOtpCompletion); // Remove listener
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider to check loading state
    final authProvider = Provider.of<AuthProvider>(context); 
    
    String masked =
        "+91 ${widget.phoneNumber.substring(0, 2)}******${widget.phoneNumber.substring(8)}";

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter the code",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "We sent the code to ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey, 
                      ),
                    ),
                    TextSpan(
                      text: masked,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, 
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // OTP input Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    height: 50,
                    width: 45,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(
                              2,
                              3,
                            ), 
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        // Call moveToNext on text change to handle focus shift
                        onChanged: (value) => moveToNext(index, value), 
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 18),

              // Resend Code Text/Timer
              GestureDetector(
                onTap: secondsRemaining == 0
                    ? () {
                        // Implement resend logic here
                        // You will need to call authProvider.signInWithPhoneNumber again
                        // and update the verificationId
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Resend logic needs to be implemented")),
                          );
                        }
                      }
                    : null,
                child: Text(
                  secondsRemaining > 0
                      ? "Resend the code in $secondsRemaining seconds"
                      : "Resend Code",
                  style: TextStyle(
                    fontSize: 14,
                    color: secondsRemaining > 0 ? Colors.grey : Colors.blue,
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  // Button is enabled if OTP is complete AND not loading
                  onPressed: (isOtpComplete && !authProvider.isLoading) 
                      ? verifyOtp 
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isOtpComplete && !authProvider.isLoading)
                        ? const Color(0xFF545454)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      : Text(
                          "CONTINUE",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: (isOtpComplete && !authProvider.isLoading)
                                ? Colors.white
                                : Colors.grey.shade200,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}