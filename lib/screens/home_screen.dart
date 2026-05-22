import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saviours_app/screens/terms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PageController _whyController = PageController();
  int currentPage = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> whyChooseData = [
    {"img": "assets/why1.jpg", "text": "Fast Loan Approval", "icon": "⚡"},
    {"img": "assets/why2.jpg", "text": "Low Interest Rates", "icon": "📉"},
    {"img": "assets/why3.jpg", "text": "Secure Transactions", "icon": "🔒"},
    {"img": "assets/why4.jpg", "text": "24/7 Customer Support", "icon": "🎧"},
  ];

  final List<Map<String, dynamic>> loanTypes = [
    {"icon": Icons.person_rounded, "label": "Personal", "color": Color(0xFF0A84FF)},
    {"icon": Icons.business_center_rounded, "label": "Business", "color": Color(0xFF30D158)},
    {"icon": Icons.school_rounded, "label": "School Fees", "color": Color(0xFFFF9F0A)},
    {"icon": Icons.home_work_rounded, "label": "Land Title", "color": Color(0xFFFF375F)},
  ];

  final List<Map<String, dynamic>> statsData = [
    {"value": "50M+", "label": "Max Loan"},
    {"value": "24hrs", "label": "Approval"},
    {"value": "5k+", "label": "Clients"},
    {"value": "5%", "label": "Interest"},
  ];

  @override
  void initState() {
    super.initState();
    startAutoSlide();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_whyController.hasClients) {
        currentPage++;
        if (currentPage == whyChooseData.length) currentPage = 0;
        _whyController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─────────────── HERO HEADER ───────────────
              _buildHeroHeader(),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─────────────── STATS ROW ───────────────
                    _buildStatsRow(),

                    const SizedBox(height: 28),

                    // ─────────────── LOAN TYPES ───────────────
                    _buildSectionTitle("Loan Products"),
                    const SizedBox(height: 14),
                    _buildLoanTypes(),

                    const SizedBox(height: 28),

                    // ─────────────── APPLY CARD ───────────────
                    _buildApplyCard(),

                    const SizedBox(height: 28),

                    // ─────────────── WHY CHOOSE US ───────────────
                    _buildSectionTitle("Why Choose Us"),
                    const SizedBox(height: 14),
                    _buildWhySlider(),

                    const SizedBox(height: 28),

                    // ─────────────── HOW IT WORKS ───────────────
                    _buildSectionTitle("How It Works"),
                    const SizedBox(height: 14),
                    _buildHowItWorks(),

                    const SizedBox(height: 28),

                    // ─────────────── TESTIMONIAL ───────────────
                    _buildTestimonial(),

                    const SizedBox(height: 30),
                  ],
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
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0057D9), Color(0xFF0A84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Text(
                  //   "Good Morning 👋",
                  //   style: TextStyle(
                  //     color: Colors.white70,
                  //     fontSize: 14,
                  //   ),
                  // ),
                  SizedBox(height: 2),
                  Text(
                    "Savours Finance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Loan limit badge
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: child,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.account_balance_wallet_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Available Loan Limit",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "UGX 2M – 100M",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // tagline
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _heroChip("⚡ Fast"),
              const SizedBox(width: 10),
              _heroChip("🔒 Secure"),
              const SizedBox(width: 10),
              _heroChip("✅ Reliable"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 13)),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: statsData.map((stat) {
          return Column(
            children: [
              Text(
                stat["value"],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0057D9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat["label"],
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF0A84FF),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B40),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanTypes() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: loanTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final item = loanTypes[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (item["color"] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item["icon"] as IconData,
                          color: item["color"] as Color, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item["label"],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0D1B40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildApplyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0057D9), Color(0xFF38A5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0057D9).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ready to apply?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Get approved in under 24 hours.",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()),
                    );
  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0057D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Apply Now →",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.rocket_launch_rounded,
              color: Colors.white, size: 52),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  WHY CHOOSE US SLIDER
  // ─────────────────────────────────────────────
  Widget _buildWhySlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _whyController,
            itemCount: whyChooseData.length,
            onPageChanged: (i) => setState(() => currentPage = i),
            itemBuilder: (context, index) {
              return buildWhyChooseItem(
                whyChooseData[index]["img"]!,
                whyChooseData[index]["text"]!,
                whyChooseData[index]["icon"]!,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(whyChooseData.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? const Color(0xFF0A84FF)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  HOW IT WORKS
  // ─────────────────────────────────────────────
  Widget _buildHowItWorks() {
    final steps = [
      {"step": "1", "title": "Register", "desc": "Create your account in minutes", "icon": Icons.person_add_rounded},
      {"step": "2", "title": "Apply", "desc": "Choose loan type & fill form", "icon": Icons.edit_note_rounded},
      {"step": "3", "title": "Approved", "desc": "Get reviewed within 24 hours", "icon": Icons.verified_rounded},
      {"step": "4", "title": "Receive", "desc": "Funds sent directly to you", "icon": Icons.payments_rounded},
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        int i = entry.key;
        var step = entry.value;
        bool isLast = i == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A84FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A84FF).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Icon(step["icon"] as IconData,
                      color: Colors.white, size: 20),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: const Color(0xFF0A84FF).withOpacity(0.2),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      step["title"] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B40),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step["desc"] as String,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  //  TESTIMONIAL
  // ─────────────────────────────────────────────
  Widget _buildTestimonial() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B40),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "❝",
            style: TextStyle(
                fontSize: 40,
                color: Color(0xFF0A84FF),
                height: 1),
          ),
          const SizedBox(height: 8),
          const Text(
            "Savours helped me secure funding for my business within a day. The process was smooth and stress-free!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF0A84FF).withOpacity(0.2),
                child: const Text("AK",
                    style: TextStyle(
                        color: Color(0xFF0A84FF),
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Akello Sarah",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text("Business Owner, Kampala",
                      style:
                          TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => const Icon(Icons.star_rounded,
                      color: Color(0xFFFFCC00), size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


Widget buildWhyChooseItem(String image, String text, String emoji) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.55),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 18,
          left: 18,
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// //import 'signin_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final PageController _whyController = PageController();
//   int currentPage = 0;

//   final List<Map<String, String>> whyChooseData = [
//     {"img": "assets/why1.jpg", "text": "Fast Loan Approval"},
//     {"img": "assets/why2.jpg", "text": "Low Interest Rates"},
//     {"img": "assets/why3.jpg", "text": "Secure Transactions"},
//     {"img": "assets/why4.jpg", "text": "24/7 Customer Support"},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     startAutoSlide();
//   }

//   void startAutoSlide() {
//     Timer.periodic(const Duration(seconds: 2), (timer) {
//       if (_whyController.hasClients) {
//         currentPage++;
//         if (currentPage == whyChooseData.length) currentPage = 0;

//         _whyController.animateToPage(
//           currentPage,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [


//               // ---------------- LOAN CARD ----------------
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 8,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Loan Limit",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue[900],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "Min: 2M  •  Max: 100M",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.blue[800],
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       height: 1,
//                       width: 120,
//                       color: Colors.blue[200],
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "Flexible loans tailored to your needs.",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               Text(
//                 "Secure • Fast • Reliable",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: const Color.fromARGB(255, 15, 0, 0),
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // ---------------- WHY CHOOSE US ----------------
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Why Choose Us",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue[700],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               SizedBox(
//                 height: 170,
//                 child: PageView.builder(
//                   controller: _whyController,
//                   itemCount: whyChooseData.length,
//                   itemBuilder: (context, index) {
//                     return buildWhyChooseItem(
//                       whyChooseData[index]["img"]!,
//                       whyChooseData[index]["text"]!,
//                     );
//                   },
//                 ),
//               ),

//               const SizedBox(height: 18),

              

//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ------------------ HELPER WIDGET --------------------
// Widget buildWhyChooseItem(String image, String text) {
//   return Stack(
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           image: DecorationImage(
//             image: AssetImage(image),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           color: Colors.black.withOpacity(0.45),
//         ),
//       ),
//       Center(
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     ],
//   );
// }


