import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'password_reset.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedLocation;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print("Form submitted!");
      print("First Name: ${_firstNameController.text}");
      print("Last Name: ${_lastNameController.text}");
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
      print("Location: $_selectedLocation");
      print("Phone: ${_phoneController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blueAccent.shade100,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.blue.shade50,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // First Name
                    _buildInputField(
                      controller: _firstNameController,
                      label: "First Name",
                      validator: (v) =>
                          v!.isEmpty ? 'Enter first name' : null,
                    ),
                    const SizedBox(height: 15),

                    // Last Name
                    _buildInputField(
                      controller: _lastNameController,
                      label: "Last Name",
                      validator: (v) => v!.isEmpty ? 'Enter last name' : null,
                    ),
                    const SizedBox(height: 15),

                    // Email
                    _buildInputField(
                      controller: _emailController,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) return 'Enter email';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                            .hasMatch(value)) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Password
                    _buildInputField(
                      controller: _passwordController,
                      label: "Password",
                      obscureText: !_showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      validator: (v) => v!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password
                    _buildInputField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      obscureText: !_showConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                      validator: (v) => v != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Location
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: ['Kampala', 'Jinja', 'Gulu', 'Entebbe']
                          .map((loc) => DropdownMenuItem(
                                value: loc,
                                child: Text(loc),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedLocation = v;
                        });
                      },
                      validator: (v) =>
                          v == null ? 'Please select your location' : null,
                    ),
                    const SizedBox(height: 15),

                    // Phone
                    _buildInputField(
                      controller: _phoneController,
                      label: "Phone Number",
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          v!.isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 25),

                    // 🔹 Submit Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign In / Register',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🔹 Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 🔹 Forgot Password (Now last)
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'password_reset.dart';


// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   String? _selectedLocation;
//   bool _showPassword = false;
//   bool _showConfirmPassword = false;

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       print("Form submitted!");
//       print("First Name: ${_firstNameController.text}");
//       print("Last Name: ${_lastNameController.text}");
//       print("Email: ${_emailController.text}");
//       print("Password: ${_passwordController.text}");
//       print("Location: $_selectedLocation");
//       print("Phone: ${_phoneController.text}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[50], // calm background
//       appBar: AppBar(
//         title: const Text('Register'),
//         backgroundColor: Colors.blueAccent.shade100,
//         elevation: 0,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Card(
//             color: Colors.blue.shade50, // calm card color
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Create Your Account",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // First Name
//                     _buildInputField(
//                       controller: _firstNameController,
//                       label: "First Name",
//                       validator: (v) =>
//                           v!.isEmpty ? 'Enter first name' : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Last Name
//                     _buildInputField(
//                       controller: _lastNameController,
//                       label: "Last Name",
//                       validator: (v) => v!.isEmpty ? 'Enter last name' : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Email
//                     _buildInputField(
//                       controller: _emailController,
//                       label: "Email",
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value!.isEmpty) return 'Enter email';
//                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
//                             .hasMatch(value)) {
//                           return 'Enter valid email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 15),

//                     // Password
//                     _buildInputField(
//                       controller: _passwordController,
//                       label: "Password",
//                       obscureText: !_showPassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _showPassword
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.blueAccent,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _showPassword = !_showPassword;
//                           });
//                         },
//                       ),
//                       validator: (v) => v!.length < 6
//                           ? 'Password must be at least 6 characters'
//                           : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Confirm Password
//                     _buildInputField(
//                       controller: _confirmPasswordController,
//                       label: "Confirm Password",
//                       obscureText: !_showConfirmPassword,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _showConfirmPassword
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.blueAccent,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _showConfirmPassword = !_showConfirmPassword;
//                           });
//                         },
//                       ),
//                       validator: (v) => v != _passwordController.text
//                           ? 'Passwords do not match'
//                           : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Location
//                     DropdownButtonFormField<String>(
//                       initialValue: _selectedLocation,
//                       decoration: InputDecoration(
//                         labelText: 'Location',
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       items: ['Kampala', 'Jinja', 'Gulu', 'Entebbe']
//                           .map((loc) => DropdownMenuItem(
//                                 value: loc,
//                                 child: Text(loc),
//                               ))
//                           .toList(),
//                       onChanged: (v) {
//                         setState(() {
//                           _selectedLocation = v;
//                         });
//                       },
//                       validator: (v) =>
//                           v == null ? 'Please select your location' : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Phone
//                     _buildInputField(
//                       controller: _phoneController,
//                       label: "Phone Number",
//                       keyboardType: TextInputType.phone,
//                       validator: (v) =>
//                           v!.isEmpty ? 'Enter phone number' : null,
//                     ),
//                     const SizedBox(height: 25),

//                     // Button
//                     ElevatedButton(
//                       onPressed: _submitForm,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 50, vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         'Sign In / Register',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔹 Reusable white input field widget
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     bool obscureText = false,
//     TextInputType keyboardType = TextInputType.text,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }
