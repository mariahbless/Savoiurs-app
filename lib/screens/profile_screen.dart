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

//             // ================= FINANCIAL OVERVIEW SECTION =================
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                   const Text(
//                     "Financial Overview",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 15),

//                   GridView.count(
//                     crossAxisCount: 2,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 1.2,
//                     children: [

//                       _buildStatCard("Total Savings", "UGX 1,200,000", Icons.savings),
//                       _buildStatCard("Active Loans", "UGX 800,000", Icons.account_balance),
//                       _buildStatCard("Total Deposits", "UGX 5,000,000", Icons.arrow_downward),
//                       _buildStatCard("Withdrawals", "UGX 2,000,000", Icons.arrow_upward),

//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 15),

//             // ================= SECURITY SECTION =================
//             _buildCard(
//               title: "Security",
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.lock_reset, color: Colors.blue),
//                   title: const Text("Reset Password"),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const ResetPasswordScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.login, color: Colors.green),
//                   title: const Text("Login"),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LoginScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 15),

//             // ================= SETTINGS SECTION =================
//             _buildCard(
//               title: "Settings",
//               children: [

//                 SwitchListTile(
//                   secondary: const Icon(Icons.notifications, color: Colors.blue),
//                   title: const Text("Enable Notifications"),
//                   value: notificationsEnabled,
//                   onChanged: (value) {
//                     setState(() {
//                       notificationsEnabled = value;
//                     });
//                   },
//                 ),

//                 ListTile(
//                   leading: const Icon(Icons.help_outline, color: Colors.blue),
//                   title: const Text("Help Center"),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HelpCenterScreen(),
//                       ),
//                     );
//                   },
//                 ),

//                 ListTile(
//                   leading: const Icon(Icons.description, color: Colors.blue),
//                   title: const Text("Terms & Conditions"),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const TermsAndConditionsScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= REUSABLE CARD =================
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

//   // ================= STAT CARD =================
//   Widget _buildStatCard(String title, String amount, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 8,
//             spreadRadius: 2,
//           )
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 30, color: Colors.blue),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 5),
//           Text(
//             amount,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // ================= REUSABLE LIST TILE =================
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


import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'password_reset.dart';
import 'terms_screen.dart';
import 'help_center.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
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
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mary blessing",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "maryblessing@gmail.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "+256 789 456 123",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            

            // ================= SECURITY SECTION =================
            _buildCard(
  title: "Security",
  children: [
    ListTile(
      leading: const Icon(Icons.lock_reset, color: Colors.blue),
      title: const Text("Reset Password"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResetPasswordScreen(),
          ),
        );
      },
    ),
    ListTile(
      leading: const Icon(Icons.login, color: Colors.green),
      title: const Text("Login"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
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
      secondary: const Icon(Icons.notifications, color: Colors.blue),
      title: const Text("Enable Notifications"),
      value: notificationsEnabled,
      onChanged: (value) {
        setState(() {
          notificationsEnabled = value;
        });
      },
    ),

    ListTile(
      leading: const Icon(Icons.help_outline, color: Colors.blue),
      title: const Text("Help Center"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HelpCenterScreen(),
          ),
        );
      },
    ),

    ListTile(
      leading: const Icon(Icons.description, color: Colors.blue),
      title: const Text("Terms & Conditions"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TermsAndConditionsScreen(),
          ),
        );
      },
    ),
  ],
),
          ],
        ),
      ),
    );
  }
  // ================= REUSABLE CARD =================
  static Widget _buildCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  // ================= REUSABLE LIST TILE =================
  static Widget _buildTile(IconData icon, String title, String trailingText) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: trailingText.isNotEmpty
          ? Text(
              trailingText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          : const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
