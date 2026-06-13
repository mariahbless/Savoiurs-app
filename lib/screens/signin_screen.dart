
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
 

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedLocation;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  final Map<String, String?> _errors = {
    'firstName': null, 'lastName': null, 'email': null,
    'password': null, 'confirmPassword': null,
    'phone': null, 'location': null,
  };
  final Map<String, bool> _touched = {
    'firstName': false, 'lastName': false, 'email': false,
    'password': false, 'confirmPassword': false,
    'phone': false, 'location': false,
  };

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
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    _firstNameController.addListener(() => _validate('firstName'));
    _lastNameController.addListener(() => _validate('lastName'));
    _emailController.addListener(() => _validate('email'));
    _passwordController.addListener(() {
      _validate('password');
      if (_touched['confirmPassword']!) _validate('confirmPassword');
    });
    _confirmPasswordController.addListener(() => _validate('confirmPassword'));
    _phoneController.addListener(() => _validate('phone'));
  }

  void _validate(String field) {
    if (!_touched[field]!) return;
    setState(() {
      switch (field) {
        case 'firstName':
          _errors['firstName'] = _firstNameController.text.trim().isEmpty
              ? 'First name is required' : null;
          break;
        case 'lastName':
          _errors['lastName'] = _lastNameController.text.trim().isEmpty
              ? 'Last name is required' : null;
          break;
        case 'email':
          final v = _emailController.text.trim();
          if (v.isEmpty) {
            _errors['email'] = 'Email is required';
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(v)) {
            _errors['email'] = 'Enter a valid email address';
          } else {
            _errors['email'] = null;
          }
          break;
        case 'password':
          final v = _passwordController.text;
          if (v.isEmpty) {
            _errors['password'] = 'Password is required';
          } else if (v.length < 6) {
            _errors['password'] = 'At least 6 characters required';
          } else {
            _errors['password'] = null;
          }
          break;
        case 'confirmPassword':
          _errors['confirmPassword'] =
              _confirmPasswordController.text != _passwordController.text
                  ? 'Passwords do not match' : null;
          break;
        case 'phone':
          final v = _phoneController.text.trim();
          if (v.isEmpty) {
            _errors['phone'] = 'Phone number is required';
          } else if (v.length < 9) {
            _errors['phone'] = 'Enter a valid phone number';
          } else {
            _errors['phone'] = null;
          }
          break;
      }
    });
  }

  bool get _isFormValid =>
      _errors.values.every((e) => e == null) &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _selectedLocation != null;

  void _touchAll() {
    _touched.updateAll((key, _) => true);
    for (final field in _touched.keys) {
      _validate(field);
    }
    if (_selectedLocation == null) {
      setState(() => _errors['location'] = 'Please select your location');
    }
  }

  void _submitForm() async {
    _touchAll();
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    final url = Uri.parse('${AppConstants.apiBaseUrl}/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
          'phone': '+256${_phoneController.text.trim()}',
          'location': _selectedLocation,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['name']);
        await prefs.setString('user_email', data['user']['email']);
        await prefs.setString('user_phone', data['user']['phone']);
        await prefs.setString('user_location', data['user']['location']);
        await prefs.setInt('user_id', data['user']['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Welcome ${data['user']['name']}'),
            backgroundColor: const Color(0xFF30D158),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        final errors = data['errors'] as Map<String, dynamic>;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errors.values.first[0]),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Connection error. Check your internet or server.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D1B40),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Fill in your details to get started",
                            style: TextStyle(fontSize: 13, color: Colors.black45),
                          ),

                          const SizedBox(height: 24),

                  
                          Row(
                            children: [
                              Expanded(
                                child: _buildField(
                                  label: "First Name",
                                  controller: _firstNameController,
                                  field: 'firstName',
                                  hint: "Elon",
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildField(
                                  label: "Last Name",
                                  controller: _lastNameController,
                                  field: 'lastName',
                                  hint: "klea",
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                  
                          _buildField(
                            label: "Email Address",
                            controller: _emailController,
                            field: 'email',
                            hint: "you@example.com",
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

                          
                          _buildField(
                            label: "Phone Number",
                            controller: _phoneController,
                            field: 'phone',
                            hint: "700 000 000",
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            prefix: "+256",
                          ),

                          const SizedBox(height: 16),

                      
                          _buildLabel("Location"),
                          const SizedBox(height: 6),
                          _buildLocationDropdown(),

                          const SizedBox(height: 16),

                
                          _buildField(
                            label: "Password",
                            controller: _passwordController,
                            field: 'password',
                            hint: "Min. 6 characters",
                            icon: Icons.lock_outline_rounded,
                            obscureText: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _showPassword = !_showPassword),
                            ),
                          ),

                          const SizedBox(height: 16),

                  
                          _buildField(
                            label: "Confirm Password",
                            controller: _confirmPasswordController,
                            field: 'confirmPassword',
                            hint: "Re-enter password",
                            icon: Icons.lock_outline_rounded,
                            obscureText: !_showConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey.shade400,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _showConfirmPassword = !_showConfirmPassword),
                            ),
                          ),

                          const SizedBox(height: 28),

                
                          _buildSubmitButton(),

                          const SizedBox(height: 20),

                  
                          Row(
                            children: [
                              Expanded(child: Divider(color: const Color.fromARGB(255, 59, 54, 54))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text("or",
                                    style: TextStyle(
                                        color: const Color.fromARGB(255, 117, 114, 114), fontSize: 13)),
                              ),
                              Expanded(child: Divider(color: const Color.fromARGB(255, 59, 54, 54))),
                            ],
                          ),

                          const SizedBox(height: 20),

                      
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(color: Colors.black54, fontSize: 14),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()),
                                  ),
                                  child: const Text(
                                    "Login",
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
    padding: const EdgeInsets.fromLTRB(2, 15, 2, 15),
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

        
        Center(                          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: [
              Container(
                
               ),
              const SizedBox(height: 16),
              const Text(
                "Join Saviours Finance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Your financial freedom starts here",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String field,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? prefix,
  }) {
    final bool hasError = _errors[field] != null && _touched[field]!;
    final bool isValid = _errors[field] == null &&
        _touched[field]! &&
        controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
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
          child: Row(
            children: [
            
              if (prefix != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF3FF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      bottomLeft: Radius.circular(11),
                    ),
                    border: Border(
                      right: BorderSide(
                          color: Colors.grey.shade200, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("🇺🇬", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        prefix,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D1B40),
                        ),
                      ),
                    ],
                  ),
                ),

        
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: (_) {
                    _touched[field] = true;
                    _validate(field);
                  },
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: prefix == null
                        ? Icon(
                            icon,
                            color: hasError
                                ? Colors.redAccent
                                : isValid
                                    ? const Color(0xFF30D158)
                                    : Colors.grey.shade400,
                            size: 20,
                          )
                        : null,
                    suffixIcon: suffixIcon ??
                        (isValid
                            ? const Icon(Icons.check_circle_rounded,
                                color: Color(0xFF30D158), size: 20)
                            : null),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.redAccent, size: 13),
                const SizedBox(width: 4),
                Text(
                  _errors[field]!,
                  style:
                      const TextStyle(color: Colors.redAccent, fontSize: 11),
                ),
              ],
            ),
          ),
      ],
    );
  }

  
  Widget _buildLocationDropdown() {
    final bool hasError =
        _errors['location'] != null && _touched['location']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? Colors.redAccent
                  : _selectedLocation != null
                      ? const Color(0xFF30D158)
                      : Colors.grey.shade200,
              width: 1.5,
            ),
            color: const Color(0xFFF8FAFF),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLocation,
              isExpanded: true,
              hint: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 10),
                  Text("Select location",
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13)),
                ],
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400),
              items: ['Kampala', 'Jinja', 'Gulu', 'Entebbe']
                  .map((loc) => DropdownMenuItem(
                        value: loc,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: Color(0xFF0057D9), size: 18),
                            const SizedBox(width: 10),
                            Text(loc,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0D1B40))),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedLocation = v;
                  _touched['location'] = true;
                  _errors['location'] = null;
                });
              },
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: Colors.redAccent, size: 13),
                const SizedBox(width: 4),
                const Text(
                  'Please select your location',
                  style: TextStyle(color: Colors.redAccent, fontSize: 11),
                ),
              ],
            ),
          ),
      ],
    );
  }

 
  Widget _buildSubmitButton() {
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
          onTap: _isLoading ? null : _submitForm,
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
                      Icon(Icons.person_add_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Create Account",
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