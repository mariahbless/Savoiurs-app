import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'password_reset.dart';
import 'signin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // Real-time validation state
  String? _emailError;
  String? _passwordError;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    
    _emailController.addListener(_validateEmailRealTime);
    _passwordController.addListener(_validatePasswordRealTime);
  }

  void _validateEmailRealTime() {
    if (!_emailTouched) return;
    setState(() {
      final val = _emailController.text.trim();
      if (val.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(val)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePasswordRealTime() {
    if (!_passwordTouched) return;
    setState(() {
      final val = _passwordController.text;
      if (val.isEmpty) {
        _passwordError = 'Password is required';
      } else if (val.length < 6) {
        _passwordError = 'At least 6 characters required';
      } else {
        _passwordError = null;
      }
    });
  }

  bool get _isFormValid =>
      _emailError == null &&
      _passwordError == null &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    // Touch all fields to trigger validation
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });
    _validateEmailRealTime();
    _validatePasswordRealTime();

    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['name']);
        await prefs.setString('user_email', data['user']['email']);
        await prefs.setString('user_phone', data['user']['phone']);
        await prefs.setString('user_location', data['user']['location']);
        await prefs.setInt('user_id', data['user']['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${data['user']['name']}!'),
            backgroundColor: const Color(0xFF30D158),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Login failed'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Connection error. Check your internet or server.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              _buildHeroHeader(),

        
              FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                    child: Column(
                      children: [
                        
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                const Text(
                                  "Welcome Back",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D1B40),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Sign in to your account",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black45),
                                ),

                                const SizedBox(height: 24),

                                // EMAIL FIELD
                                _buildLabel("Email Address"),
                                const SizedBox(height: 6),
                                _buildEmailField(),

                                const SizedBox(height: 16),

                                // PASSWORD FIELD
                                _buildLabel("Password"),
                                const SizedBox(height: 6),
                                _buildPasswordField(),

                                //FORGOT PASSWORD 
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ResetPasswordScreen()),
                                    ),
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero),
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: Color(0xFF0057D9),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // LOGIN BUTTON
                                _buildLoginButton(),

                                const SizedBox(height: 20),

                                  //DIVIDER
                                Row(
                                  children: [
                                    Expanded(
                                        child: Divider(
                                            color: Colors.grey.shade200)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Text("or",
                                          style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 13)),
                                    ),
                                    Expanded(
                                        child: Divider(
                                            color: Colors.grey.shade200)),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // REGISTER LINK 
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const SignInScreen()),
                                        ),
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(
                                            color: Color(0xFF0057D9),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0035A0), Color(0xFF0A84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -10, left: -10,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          // Content
          Column(
            children: [
              const Text(
                "Saviours Finance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Fast • Secure • Reliable",
                style: TextStyle(color: Color.fromARGB(179, 248, 250, 250), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0D1B40),
      ),
    );
  }

  Widget _buildEmailField() {
    final bool hasError = _emailError != null && _emailTouched;
    final bool isValid = _emailError == null &&
        _emailTouched &&
        _emailController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent
                  : isValid
                      ? const Color(0xFF30D158)
                      : Colors.grey.shade200,
              width: 1.5,
            ),
            color: const Color(0xFFF8FAFF),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              _emailTouched = true;
              _validateEmailRealTime();
            },
            decoration: InputDecoration(
              hintText: "you@example.com",
              hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: hasError
                    ? Colors.redAccent
                    : isValid
                        ? const Color(0xFF30D158)
                        : Colors.grey.shade400,
                size: 20,
              ),
              suffixIcon: isValid
                  ? const Icon(Icons.check_circle_rounded,
                      color: Color(0xFF30D158), size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.redAccent, size: 14),
                const SizedBox(width: 4),
                Text(
                  _emailError!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField() {
    final bool hasError = _passwordError != null && _passwordTouched;
    final bool isValid = _passwordError == null &&
        _passwordTouched &&
        _passwordController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent
                  : isValid
                      ? const Color(0xFF30D158)
                      : Colors.grey.shade200,
              width: 1.5,
            ),
            color: const Color(0xFFF8FAFF),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            onChanged: (_) {
              _passwordTouched = true;
              _validatePasswordRealTime();
            },
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: hasError
                    ? Colors.redAccent
                    : isValid
                        ? const Color(0xFF30D158)
                        : Colors.grey.shade400,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.redAccent, size: 14),
                const SizedBox(width: 4),
                Text(
                  _passwordError!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0035A0), Color(0xFF0A84FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0057D9).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _isLoading ? null : _loginUser,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}