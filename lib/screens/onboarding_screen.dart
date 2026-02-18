import 'package:flutter/material.dart';
//import 'home_screen.dart';
import 'main_screen.dart';

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      body: SafeArea(
        child: Column(
          children: [
            // -------------------- TOP BAR ---------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  // -------- PAGE 1 ----------
                  buildPage(
                    image: 'assets/logo1.jpg',
                    title: 'Welcome to Savoiurs',
                    description: 'Your trusted companion for financial success.',
                    cards: Column(
                      children: [
                        buildGoalCard(Icons.security, "Security First",
                            "Your data is safe and protected."),
                        buildGoalCard(Icons.speed, "Fast Processing",
                            "Complete tasks faster and smarter."),
                        buildGoalCard(Icons.speed, "Fast Processing",
                            "Complete tasks faster and smarter."),
                            
                      ],
                    ),
                  ),

                  // -------- PAGE 2 ----------
buildPage(
  image: 'assets/onboard2.png',
  title: 'Our Offers',
  description:
      'Flexible loans designed to meet your personal and business needs.\nLimits from 3M to 50M.',
  cards: GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    crossAxisCount: 2,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    children: const [
      OfferCard(
        title: 'Personal Loan',
        icon: Icons.person,
        limit: 'BORROW UP TO  50M',
      ),
      OfferCard(
        icon: Icons.business_center,
        title: 'Business Loan',
        limit: 'BORROW UP TO  50M',
      ),
      OfferCard(
        icon: Icons.school,
        title: 'School Fees Loan',
        limit: 'BORROW UP TO  50M',
      ),
      OfferCard(
        icon: Icons.home_work,
        title: 'Land Title Loan',
        limit: 'BORROW UP TO  50M',
      ),
    ],
  ),
),
                  // -------- PAGE 3 ----------
                  buildPage(
                    image: 'assets/onboard3.png',
                    title: 'Achieve Your Goals',
                    description:
                        'Set targets, follow your progress, and celebrate achievements.',
                    cards: Column(
                      children: [
                        buildGoalCard(Icons.flag, "Set Clear Goals",
                            "Define what you want to achieve today."),
                        buildGoalCard(Icons.emoji_events, "Achievement Rewards",
                            "Earn badges as you reach milestones."),
                        // buildGoalCard(Icons.trending_up, "Progress Insights",
                        //     "Understand your growth with analytics."),
                      ],
                    ),
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
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                color: const Color.fromARGB(255, 6, 143, 240),
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
    required Widget cards,
  }) {
    bool isPageTwo = image.contains("onboard2.png");

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

         // ---------------- IMAGE DISPLAY -----------------
isPageTwo
    ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset(
          image,
          height: 220,
          fit: BoxFit.contain,
        ),
      )
    : Container(
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
            const SizedBox(height: 15),

          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),

          const SizedBox(height: 15),

          // ----------------- CARDS -----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: cards,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ----------------- LONG CARD -----------------
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
              color: const Color.fromARGB(255, 128, 183, 241),
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

  // ----------------- SQUARE GRID CARD -----------------
  Widget buildSquareValueCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color.fromARGB(255, 130, 181, 234)),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}


class OfferCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String limit;

  const OfferCard({
    super.key,
    required this.icon,
    required this.title,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 183, 219, 245),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 42, color: const Color.fromARGB(255, 12, 97, 194)),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            limit,
            style: TextStyle(
              fontSize: 13,
              color: const Color.fromARGB(255, 43, 43, 43),
            ),
          ),
        ],
      ),
    );
  }
}
