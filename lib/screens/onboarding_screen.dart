import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // -------------------- TOP BAR ---------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _controller.jumpToPage(2),
                    child: const Text("Skip"),
                  ),
                  TextButton(
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),

            // -------------------- PAGES -------------------------
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: [
                  buildPage(
                    image: 'assets/logo1.jpg',
                    title: 'Welcome to Savoiurs',
                    description: 'Your trusted companion for financial success.',
                    cards: [
                      buildGoalCard(Icons.security, "Security First",
                          "Your data is safe and protected."),
                      buildGoalCard(Icons.speed, "Fast Processing",
                          "Complete tasks faster and smarter."),
                    ],
                  ),

                  buildPage(
                    image: 'assets/onboard2.png',
                    title: 'Stay Organized',
                    description:
                        'Track your activities, reminders, and daily tasks easily.',
                    cards: [
                      buildGoalCard(Icons.task_alt, "Smart Tracking",
                          "Monitor everything in one place."),
                      buildGoalCard(Icons.notifications_active, "Instant Alerts",
                          "Stay updated with timely notifications."),
                    ],
                  ),

                  buildPage(
                    image: 'assets/onboard3.png',
                    title: 'Achieve Your Goals',
                    description:
                        'Set targets, follow your progress, and celebrate achievements.',
                    cards: [
                      buildGoalCard(Icons.flag, "Set Clear Goals",
                          "Define what you want to achieve today."),
                      buildGoalCard(Icons.emoji_events, "Achievement Rewards",
                          "Earn badges as you reach milestones."),
                      buildGoalCard(Icons.trending_up, "Progress Insights",
                          "Understand your growth with analytics."),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ------------------ BOTTOM BUTTON --------------------
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.deepPurple,
                alignment: Alignment.center,
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // ----------------- PAGE BUILDER -----------------
  Widget buildPage({
    required String image,
    required String title,
    required String description,
    required List<Widget> cards,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ------------- CIRCULAR IMAGE --------------
          Container(
            height: 200,
            width: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 25),

          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),

          const SizedBox(height: 25),

          // ----------------- GOAL CARDS -----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: cards),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ----------------- CARD WIDGET -----------------
  Widget buildGoalCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
