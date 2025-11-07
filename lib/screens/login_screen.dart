// import 'package:flutter/material.dart';
// import 'password_reset.dart';
// import 'signin_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void _loginUser() {
//     if (_formKey.currentState!.validate()) {
//       final email = _emailController.text.trim();
//       final password = _passwordController.text.trim();
      

//       // For now, just show a message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Logging in as $email')),
//       );

//       // TODO: Add your real login logic here (API, Firebase, etc.)
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 40),
//               const Text(
//                 "Welcome Back!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // 🔹 Email Field
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your email";
//                   } else if (!value.contains("@")) {
//                     return "Enter a valid email address";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 15),

//               // 🔹 Password Field
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   prefixIcon: Icon(Icons.lock),
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your password";
//                   } else if (value.length < 6) {
//                     return "Password must be at least 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 10),

//               // 🔹 Forgot Password link
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ResetPasswordScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "Forgot Password?",
//                     style: TextStyle(color: Colors.blueAccent),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 🔹 Login Button
//               ElevatedButton(
//                 onPressed: _loginUser,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   "Login",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // 🔹 Register Link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't have an account? "),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SignInScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Create Account",
//                       style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'password_reset.dart';
import 'signin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔹 Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🔹 Login logic
  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // For now, just show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in as $email')),
      );

      // Later you can add your API login logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Login'),
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
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    // Login Button
                    ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}
