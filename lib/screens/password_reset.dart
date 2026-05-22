import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'new_password_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailTouched = false;
  String? _emailError;
  bool _linkSent = false;

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
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    if (!_emailTouched) return;
    setState(() {
      final v = _emailController.text.trim();
      if (v.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(v)) {
        _emailError = 'Enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  bool get _isEmailValid =>
      _emailError == null && _emailController.text.isNotEmpty;

  Future<void> _resetPassword() async {
    setState(() => _emailTouched = true);
    _validateEmail();
    if (!_isEmailValid) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() => _linkSent = true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Reset link sent! Check your email.'),
            backgroundColor: const Color(0xFF30D158),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewPasswordScreen(email: email),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Something went wrong'),
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
  void dispose() {
    _emailController.dispose();
    _animController.dispose();
    super.dispose();
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
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                    child: Container(
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
                      child: _linkSent
                          ? _buildSuccessState()
                          : _buildFormState(),
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

          // Centered content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lock icon in a white rounded box
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: Color(0xFF0057D9),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "We'll send a reset link to your email",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  FORM STATE
  // ─────────────────────────────────────────────
  Widget _buildFormState() {
    final bool hasError = _emailError != null && _emailTouched;
    final bool isValid = _emailError == null &&
        _emailTouched &&
        _emailController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          "Forgot Password?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B40),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Enter your registered email and we'll send you a secure link to reset your password.",
          style: TextStyle(fontSize: 13, color: Colors.black45, height: 1.5),
        ),

        const SizedBox(height: 28),

        // ── INFO BANNER ──
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0A84FF).withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF0A84FF).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline_rounded,
                  color: Color(0xFF0057D9), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Check your spam folder if you don't receive the email within a few minutes.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0057D9),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // ── EMAIL LABEL ──
        const Text(
          "Email Address",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D1B40),
          ),
        ),
        const SizedBox(height: 6),

        // ── EMAIL FIELD ──
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
              _validateEmail();
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

        // ── INLINE ERROR ──
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.redAccent, size: 13),
                const SizedBox(width: 4),
                Text(
                  _emailError!,
                  style: const TextStyle(
                      color: Colors.redAccent, fontSize: 11),
                ),
              ],
            ),
          ),

        const SizedBox(height: 28),

        // ── SEND BUTTON ──
        _buildSendButton(),

        const SizedBox(height: 20),

        // ── BACK TO LOGIN ──
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back_rounded,
                    color: Color(0xFF0057D9), size: 16),
                SizedBox(width: 6),
                Text(
                  "Back to Login",
                  style: TextStyle(
                    color: Color(0xFF0057D9),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  SUCCESS STATE
  // ─────────────────────────────────────────────
  Widget _buildSuccessState() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF30D158).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            color: Color(0xFF30D158),
            size: 52,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Email Sent! 🎉",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B40),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "A reset link has been sent to\n${_emailController.text.trim()}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black45,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0A84FF).withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF0A84FF).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: const [
              Icon(Icons.timer_outlined,
                  color: Color(0xFF0057D9), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Redirecting you to reset your password...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0057D9),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  SEND BUTTON
  // ─────────────────────────────────────────────
  Widget _buildSendButton() {
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
          onTap: _isLoading ? null : _resetPassword,
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Send Reset Link",
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