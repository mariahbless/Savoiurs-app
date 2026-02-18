import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 250),
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- LOGO / BANNER ----------------
            Container(
              height: 150,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                'assets/savlogo.jpg', // your logo image
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),

            // ---------------- ABOUT / MISSION ----------------
            const Text(
              'About Us',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Saviours Finance Int LTD is dedicated to providing fast, safe, and reliable financial solutions to individuals and businesses. '
              'Our mission is to empower our clients with flexible loans tailored to their needs.',
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 25),

            // ---------------- CORE VALUES ----------------
            const Text(
              'Our Core Values',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: const [
                ValueCard(icon: Icons.security, title: 'Integrity'),
                ValueCard(icon: Icons.thumb_up, title: 'Excellence'),
                ValueCard(icon: Icons.group, title: 'Teamwork'),
                ValueCard(icon: Icons.lightbulb, title: 'Innovation'),
              ],
            ),
            const SizedBox(height: 25),

            // ---------------- ACHIEVEMENTS / STATS ----------------
            const Text(
              'Our Achievements',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatCard(title: 'Clients Served', value: '1,200+'),
                StatCard(title: 'Loans Disbursed', value: '1,000+'),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                StatCard(title: 'Approval Time', value: '24 hrs'),
                StatCard(title: 'Branch', value: '1'),
              ],
            ),
            const SizedBox(height: 25),

            // ---------------- TEAM / LEADERSHIP ----------------
            // const Text(
            //   'Meet Our Team',
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 15),
            // SizedBox(
            //   height: 140,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       TeamMemberCard(
            //         name: 'Madam Joan',
            //         role: 'CEO',
            //         image: 'assets/onboard2.png',
            //       ),
            //       TeamMemberCard(
            //         name: 'Mr Nichlas',
            //         role: 'Loan Officer',
            //         image: 'assets/onboard2.png',
            //       ),
            //       TeamMemberCard(
            //         name: 'Mr Kenneth',
            //         role: 'Loan Officer',
            //         image: 'assets/onboard2.png',
            //       ),
            //       TeamMemberCard(
            //         name: 'Mr Peter',
            //         role: 'Finance Manager',
            //         image: 'assets/onboard2.png',
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 25),

            // ---------------- CONTACT INFO ----------------
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Phone: +256 783 519 023\nEmail: saviours@gmail.com\nAddress: Plot 123, Kampala, Uganda',
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ---------------- VALUE CARD ----------------
class ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const ValueCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blue[800]),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ---------------- STAT CARD ----------------
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- TEAM MEMBER CARD ----------------
class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;

  const TeamMemberCard({super.key, required this.name, required this.role, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          // ---- Onboard-style image approach (no clipping) ----
          SizedBox(
            height: 60,
            width: 60,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            role,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class AboutScreen extends StatelessWidget {
//   const AboutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 251, 250),
//       appBar: AppBar(
//         title: const Text('About Us'),
//         centerTitle: true,
//         backgroundColor: Colors.blue[800],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ---------------- LOGO / BANNER ----------------
//             Container(
//   height: 120, // or whatever size you want
//   child: Image.asset(
//     'assets/onboard2.png', // your new logo image
//     fit: BoxFit.contain,
//   ),
// ),
// const SizedBox(height: 20),

//             // ---------------- ABOUT / MISSION ----------------
//             const Text(
//               'About Us',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'S.F.I LTD is dedicated to providing fast, safe, and reliable financial solutions to individuals and businesses. Our mission is to empower our clients with flexible loans tailored to their needs, ensuring transparency and trust in every transaction.',
//               style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
//             ),
//             const SizedBox(height: 25),

//             // ---------------- CORE VALUES ----------------
//             const Text(
//               'Our Core Values',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//             GridView.count(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               crossAxisCount: 2,
//               crossAxisSpacing: 15,
//               mainAxisSpacing: 15,
//               children: const [
//                 ValueCard(icon: Icons.security, title: 'Integrity'),
//                 ValueCard(icon: Icons.thumb_up, title: 'Excellence'),
//                 ValueCard(icon: Icons.group, title: 'Teamwork'),
//                 ValueCard(icon: Icons.lightbulb, title: 'Innovation'),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // ---------------- ACHIEVEMENTS / STATS ----------------
//             const Text(
//               'Our Achievements',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 StatCard(title: 'Clients Served', value: '1,200+'),
//                 StatCard(title: 'Loans Disbursed', value: '2,500+'),
//               ],
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 StatCard(title: 'Average Approval Time', value: '24 hrs'),
//                 StatCard(title: 'Branches', value: '5'),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // ---------------- TEAM / LEADERSHIP (Optional) ----------------
//             const Text(
//               'Meet Our Team',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//             SizedBox(
//               height: 100,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   TeamMemberCard(name: 'Madam Joan', role: 'CEO', image: 'assets/why1.jpg'),
//                   TeamMemberCard(name: 'Mr Nichlas', role: 'Loan officer', image: 'assets/why2.jpg'),
//                   TeamMemberCard(name: 'Mr Kenneth', role: 'Loan officer', image: 'assets/why3.jpg'),
//                   TeamMemberCard(name: 'Mr Kenneth', role: 'Loan officer', image: 'assets/why3.jpg'),
//                   TeamMemberCard(name: 'Mr Kenneth', role: 'Loan officer', image: 'assets/why3.jpg'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 25),

//             // ---------------- CONTACT INFO ----------------
//             const Text(
//               'Contact Us',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Phone: +256 783 519 023\nEmail: info@sfi.com\nAddress: Plot 123, Kampala, Uganda',
//               style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ---------------- VALUE CARD ----------------
// class ValueCard extends StatelessWidget {
//   final IconData icon;
//   final String title;

//   const ValueCard({super.key, required this.icon, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 36, color: Colors.blue[800]),
//           const SizedBox(height: 12),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---------------- STAT CARD ----------------
// class StatCard extends StatelessWidget {
//   final String title;
//   final String value;

//   const StatCard({super.key, required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         margin: const EdgeInsets.only(right: 8),
//         decoration: BoxDecoration(
//           color: Colors.blue[50],
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ---------------- TEAM MEMBER CARD ----------------
// class TeamMemberCard extends StatelessWidget {
//   final String name;
//   final String role;
//   final String image;

//   const TeamMemberCard({super.key, required this.name, required this.role, required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
//       ),
//       child: Column(
//         children: [
//           CircleAvatar(
//             backgroundImage: AssetImage(image),
//             radius: 28,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             role,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 12, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
// }
