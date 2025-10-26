import 'dart:async';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

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
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  void moveToNext(int index, String value) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }

    checkOtpCompletion();
  }

  void checkOtpCompletion() {
    bool allFilled = otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    setState(() {
      isOtpComplete = allFilled;
    });
  }

  void verifyOtp() {
    String otp = otpControllers.map((e) => e.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter 6-digit OTP")));
      return;
    }

    // ✅ If OTP is 6 digits → Go to Register Screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Text(
              //   "We sent the code to $masked",
              //   style: const TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              Text.rich(
  TextSpan(
    children: [
      const TextSpan(
        text: "We sent the code to ",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey, // grey text
        ),
      ),
      TextSpan(
        text: masked,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black, // black bold text
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
                            ), // subtle 3D downward-right shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
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

              Text(
                secondsRemaining > 0
                    ? "Resend the code in $secondsRemaining seconds"
                    : "Resend Code",
                style: TextStyle(
                  fontSize: 14,
                  color: secondsRemaining > 0 ? Colors.grey : Colors.blue,
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isOtpComplete ? verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOtpComplete
                        ? const Color(0xFF545454)
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: isOtpComplete
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
