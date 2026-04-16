import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'password_reset.dart';
import 'terms_screen.dart';
import 'help_center.dart';
import 'loan_dashboard_screen.dart';
//import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  Map<String, dynamic>? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null) {
    setState(() {
      _user = null;
      _loading = false;
    });
    return;
  }
  // Build user map from the individually saved fields
  setState(() {
    _user = {
      'name': prefs.getString('user_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
      'phone': prefs.getString('user_phone') ?? '',
      'location': prefs.getString('user_location') ?? '',
      'id': prefs.getInt('user_id') ?? 0,
    };
    _loading = false;
  });
}

  Future<void> _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('user_name');
  await prefs.remove('user_email');
  await prefs.remove('user_phone');
  await prefs.remove('user_location');
  await prefs.remove('user_id');
  setState(() {
    _user = null;
  });
}

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      // Not logged in — show login prompt
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("My Profile"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle_outlined,
                    size: 90, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  "You're not logged in",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please login to view your profile and loan dashboard.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                      _loadUser(); // Reload after login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Login",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Logged in — show full profile
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: "Logout",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Logout",
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirm == true) _logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= PROFILE HEADER =================
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user!['name'] ?? "User",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _user!['email'] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _user!['phone'] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= LOAN DASHBOARD SECTION =================
            _buildCard(
              title: "My Loans",
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet,
                      color: Colors.blue),
                  title: const Text("Loan Dashboard"),
                  subtitle:
                      const Text("View applications, status & repayments"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoanDashboardScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ================= SECURITY SECTION =================
            _buildCard(
              title: "Security",
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.lock_reset, color: Colors.blue),
                  title: const Text("Reset Password"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ResetPasswordScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ================= SETTINGS SECTION =================
            _buildCard(
              title: "Settings",
              children: [
                SwitchListTile(
                  secondary:
                      const Icon(Icons.notifications, color: Colors.blue),
                  title: const Text("Enable Notifications"),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.help_outline, color: Colors.blue),
                  title: const Text("Help Center"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpCenterScreen()),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.description, color: Colors.blue),
                  title: const Text("Terms & Conditions"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TermsAndConditionsScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _buildCard(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              const Divider(),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'password_reset.dart';
// import 'terms_screen.dart';
// import 'help_center.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool notificationsEnabled = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("My Profile"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [

//             // ================= PROFILE HEADER =================
//             Container(
//               padding: const EdgeInsets.all(20),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(35),
//                   bottomRight: Radius.circular(35),
//                 ),
//               ),
//               child: Column(
//                 children: const [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage("assets/profile.jpg"),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Mary blessing",
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "maryblessing@gmail.com",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "+256 789 456 123",
//                     style: TextStyle(color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

            

//             // ================= SECURITY SECTION =================
//             _buildCard(
//   title: "Security",
//   children: [
//     ListTile(
//       leading: const Icon(Icons.lock_reset, color: Colors.blue),
//       title: const Text("Reset Password"),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ResetPasswordScreen(),
//           ),
//         );
//       },
//     ),
//     ListTile(
//       leading: const Icon(Icons.login, color: Colors.green),
//       title: const Text("Login"),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const LoginScreen(),
//           ),
//         );
//       },
//     ),
//   ],
// ),
//             const SizedBox(height: 15),

//             // ================= SETTINGS SECTION =================
//             _buildCard(
//   title: "Settings",
//   children: [

//     SwitchListTile(
//       secondary: const Icon(Icons.notifications, color: Colors.blue),
//       title: const Text("Enable Notifications"),
//       value: notificationsEnabled,
//       onChanged: (value) {
//         setState(() {
//           notificationsEnabled = value;
//         });
//       },
//     ),

//     ListTile(
//       leading: const Icon(Icons.help_outline, color: Colors.blue),
//       title: const Text("Help Center"),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HelpCenterScreen(),
//           ),
//         );
//       },
//     ),

//     ListTile(
//       leading: const Icon(Icons.description, color: Colors.blue),
//       title: const Text("Terms & Conditions"),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const TermsAndConditionsScreen(),
//           ),
//         );
//       },
//     ),
//   ],
// ),
//           ],
//         ),
//       ),
//     );
//   }
//   //  REUSABLE CARD
//   static Widget _buildCard({required String title, required List<Widget> children}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue),
//                 ),
//               ),
//               const Divider(),
//               ...children,
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //  REUSABLE LIST TILE 
//   static Widget _buildTile(IconData icon, String title, String trailingText) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(title),
//       trailing: trailingText.isNotEmpty
//           ? Text(
//               trailingText,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             )
//           : const Icon(Icons.arrow_forward_ios, size: 16),
//     );
//   }
// }
