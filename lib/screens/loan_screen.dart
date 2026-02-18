import 'package:flutter/material.dart';
//import 'login_screen.dart';
import 'terms_screen.dart';

class LoanScreen extends StatelessWidget {
  const LoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 250),
      appBar: AppBar(
        title: const Text('Loans'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- LOAN SUMMARY ----------
            const LoanSummaryCard(),

            const SizedBox(height: 30),

            // -------- SECTION TITLE ----------
            const Text(
              'Available Loan Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // -------- LOAN PRODUCTS ----------
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: const [
                LoanProductCard(
                  icon: Icons.person,
                  title: 'Personal Loan',
                  limit: 'Up to 50M',
                ),
                LoanProductCard(
                  icon: Icons.business_center,
                  title: 'Business Loan',
                  limit: 'Up to 50M',
                ),
                LoanProductCard(
                  icon: Icons.school,
                  title: 'School Fees Loan',
                  limit: 'Up to 30M',
                ),
                LoanProductCard(
                  icon: Icons.home_work,
                  title: 'Land Title Loan',
                  limit: 'Up to 50M',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // -------- APPLY BUTTON ----------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TermsAndConditionsScreen(),
    ),
  );
                  // Navigate to Apply Loan (later)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 125, 186, 230),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Apply for a Loan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LoanSummaryCard extends StatelessWidget {
  const LoanSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Loan Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'You have no active loans',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 5),
          Text(
            'You are eligible to borrow up to 50M',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}


class LoanProductCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String limit;

  const LoanProductCard({
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
        color: Colors.white,
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
          Icon(icon, size: 36, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            limit,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
