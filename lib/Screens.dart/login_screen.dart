// 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'collector_screen.dart';

import '../provider/login_provider.dart'; // ⭐ CHANGED to LoginProvider

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>();

  bool _isButtonActive = false;

  

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_checkFields);
    _passwordController.removeListener(_checkFields);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  
  void _checkFields() {
    
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (!_isButtonActive) {
        setState(() {
          _isButtonActive = true;
        });
      }
    } else {
      if (_isButtonActive) {
        setState(() {
          _isButtonActive = false;
        });
      }
    }
  }



  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // ⭐ Changed from AuthProvider to LoginProvider
      final loginProvider = Provider.of<LoginProvider>(context, listen: false); 

      final isSuccess = await loginProvider.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (isSuccess) {
          // You might want to push a different screen if the user is a collector
          // based on data received from the login API, but for now, navigating to HomeScreen.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (loginProvider.errorMessage != null) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginProvider.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
          loginProvider.clearErrorMessage(); // Clear the error after showing
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ Changed from AuthProvider to LoginProvider
    final loginProvider = Provider.of<LoginProvider>(context); 
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE2F2DF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Image section
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Image.asset(
                    'assets/images/login.png',
                    height: h * 0.35,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Login Form Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey, // Attach the GlobalKey
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Username Field
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Login Button
                      GestureDetector(
                        onTap: (_isButtonActive && !loginProvider.isLoading) // ⭐ Changed to loginProvider
                            ? _login
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 220,
                          height: 60,
                          decoration: BoxDecoration(
                            color: (_isButtonActive && !loginProvider.isLoading) // ⭐ Changed to loginProvider
                                ? const Color(0xFF4C6B4C)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (loginProvider.isLoading) // ⭐ Changed to loginProvider
                                // Show loading indicator
                                const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                              else
                                // Show Login text and icon
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_circle_right_outlined,
                                      size: 32,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}