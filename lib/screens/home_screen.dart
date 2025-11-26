import 'dart:async';
import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'profile_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _whyController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> whyChooseData = [
    {"img": "assets/why1.jpg", "text": "Fast Loan Approval"},
    {"img": "assets/why2.jpg", "text": "Low Interest Rates"},
    {"img": "assets/why3.jpg", "text": "Secure Transactions"},
    {"img": "assets/why4.jpg", "text": "24/7 Customer Support"},
  ];

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_whyController.hasClients) {
        currentPage++;
        if (currentPage == whyChooseData.length) currentPage = 0;

        _whyController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ---------------- HEADER ----------------
              Align(
                //alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    
                    
                    
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We Are Your financial partner in every moment.",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 22, 1, 1),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- LOGO ----------------
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ---------------- LOAN CARD ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Loan Limit",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Min: 2M  •  Max: 100M",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      height: 1,
                      width: 120,
                      color: Colors.blue[200],
                    ),

                    const SizedBox(height: 12),
                    Text(
                      "Flexible loans tailored to your needs.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- GET STARTED BUTTON ----------------
              // First Button
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SignInScreen(),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[800],
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 5,
    ),
    child: const Text(
      "Get Started",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

// *** Add spacing between buttons ***
const SizedBox(height: 15),

// Second Button
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileCardScreen(), // <-- change if needed
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[600],
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 5,
    ),
    child: const Text(
      "View Profile Card",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

const SizedBox(height: 25),

Text(
  "Secure • Fast • Reliable",
  style: TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 9, 1, 1),
    fontStyle: FontStyle.italic,
  ),
),

const SizedBox(height: 30),

              // ---------------- WHY CHOOSE US ----------------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Why Choose Us",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: _whyController,
                  itemCount: whyChooseData.length,
                  itemBuilder: (context, index) {
                    return buildWhyChooseItem(
                      whyChooseData[index]["img"]!,
                      whyChooseData[index]["text"]!,
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ HELPER WIDGET --------------------
Widget buildWhyChooseItem(String image, String text) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),

      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black.withOpacity(0.45),
        ),
      ),

      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}


