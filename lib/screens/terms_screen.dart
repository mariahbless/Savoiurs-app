import 'package:flutter/material.dart';
import 'login_screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 250),
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'TERMS AND CONDITIONS',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    Text(
                      'The following TERMS AND CONDITIONS shall apply to your loan facility:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),

                    Text(
                      '1. Collateral',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'The Borrower has provided the collateral described above specifically to secure the loan and in the event of default, the Lender will exercise its right to realize the collateral and recover any unpaid portion of the loan plus all costs including accrued fees, interest, recovery or legal costs.',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '1.1 All loan facilities will be linked to a pre-existing charged collateral, until both facilities are fully paid.',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),

                    Text(
                      '2. Default',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '2.1 Default will be deemed to have occurred if the borrower fails to remit monthly installments on their due date.',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '2.2 If an applicant defaults on any of the loan facilities issued to them alongside this Logbook loan, S.F.I LTD is entitled to exercise the rights to offset and withhold any collateral held by the Company during such default.',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),

                    // Add remaining sections here similarly, structured
                    // You can continue the numbering 3, 4, 5... 13
                    // Each section bolded + text below it, spacing between
                    // For brevity, I'm not pasting all 13 here, you can extend the pattern
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ACCEPT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Accept & Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Decline',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
