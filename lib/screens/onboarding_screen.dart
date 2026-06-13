import 'package:flutter/material.dart';
import 'package:saviours_app/screens/login_screen.dart';
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
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _controller.jumpToPage(2),
                    child: const Text("Skip", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 6, 143, 240))),
                  ),
                  TextButton(
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text("Next", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 6, 143, 240))),
                  ),
                ],
              ),
            ),

          
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
                  ),

              
                  buildPage(
                    image: 'assets/onboard2.png',
                    title: 'Our Offers',
                    description:
                        'Flexible loans designed to meet your personal and business needs.\nLimits from 3M to 50M.',
                  ),

          
                  buildPage(
                    image: 'assets/onboard3.png',
                    title: 'Achieve Your Goals',
                    description:
                        'Set targets, follow your progress, and celebrate achievements.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

  
      bottomSheet: isLastPage
    ? Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 143, 240),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

        
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 6, 143, 240),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 143, 240),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      )
    : const SizedBox.shrink(),
    );
  }}
  
Widget buildPage({
  required String image,
  required String title,
  required String description,
}) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

      
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Image.asset(
            image,
            height: 180,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 30),

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

        const SizedBox(height: 20),
      ],
    ),
  );
}


