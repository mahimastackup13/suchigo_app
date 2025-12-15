// 
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../provider/register_provider.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart'; 
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- UPDATED CONTROLLERS ---
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize all controllers
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final provider = context.read<RegisterProvider>();

      // Set initial values from provider state
      _usernameController.text = provider.username;
      _firstNameController.text = provider.firstName;
      _lastNameController.text = provider.lastName;
      _emailController.text = provider.email;
      _phoneController.text = provider.phone;
      _passwordController.text = provider.password;

      // Add Listeners for all required fields
      _usernameController.addListener(() {
        provider.setUsername(_usernameController.text);
        provider.clearError();
      });
      _firstNameController.addListener(() {
        provider.setFirstName(_firstNameController.text);
        provider.clearError();
      });
      _lastNameController.addListener(() {
        provider.setLastName(_lastNameController.text);
        provider.clearError();
      });
      _emailController.addListener(() {
        provider.setEmail(_emailController.text);
        provider.clearError();
      });
      _phoneController.addListener(() {
        provider.setPhone(_phoneController.text);
        provider.clearError();
      });
      _passwordController.addListener(() {
        provider.setPassword(_passwordController.text);
        provider.clearError();
      });

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 360,
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registration',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // --- UPDATED INPUT FIELDS ---
                  _buildInput('Username', _usernameController, TextInputType.text),
                  const SizedBox(height: 14),
                  _buildInput('First Name', _firstNameController, TextInputType.text),
                  const SizedBox(height: 14),
                  _buildInput('Last Name', _lastNameController, TextInputType.text),
                  const SizedBox(height: 14),
                  // --- END UPDATED INPUT FIELDS ---

                  _buildInput('Email', _emailController, TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  // _buildInput('Phone', _phoneController, TextInputType.phone),
                  // const SizedBox(height: 14),
                  _buildInput('Phone (e.g., +919998887776)', _phoneController, TextInputType.phone),
                  const SizedBox(height: 14),
                  _buildInput('Password', _passwordController, TextInputType.text, isPassword: true),
                  const SizedBox(height: 16),

                  if (provider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 2),
                      child: Text(
                        'Error: ${provider.errorMessage!}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  Row(
                    children: [
                      Checkbox(
                        value: provider.termsAccepted,
                        onChanged: provider.isLoading ? null : (v) => 
                            provider.setTermsAccepted(v ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'I have read and agree to the terms and conditions stated above',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: provider.isValid && !provider.isLoading
                          ? () async {
                              final success = await provider.registerUser();
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Registration successful! Please login.')),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) =>
                              states.contains(MaterialState.disabled)
                                  ? const Color(0xFFB0B0B0)
                                  : const Color(0xFF565454),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(4),
                      ),
                      child: provider.isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Text(
                              'CONTINUE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // OR Separator
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color.fromRGBO(73, 72, 72, 1))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Or',
                          style: TextStyle(
                              color: Color.fromRGBO(73, 72, 72, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: Divider(color: Color.fromRGBO(73, 72, 72, 1))),
                    ],
                  ),

                  const SizedBox(height: 60),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/fb.png',
                          width: 35,
                          height: 35,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.facebook, size: 35, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 80),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          'assets/icons/google.svg',
                          width: 35,
                          height: 35,
                          placeholderBuilder: (context) => const Icon(Icons.g_mobiledata, size: 35, color: Colors.red),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/login'),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for input fields
  Widget _buildInput(String hint, TextEditingController controller, TextInputType type, {bool isPassword = false}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: type,
        decoration: InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
      ),
    );
  }
}