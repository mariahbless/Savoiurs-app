import 'package:flutter/material.dart';
import 'loan_application_screen.dart'; // ← change this import

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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    Text(
                      '3. Loan Cancellation:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '3.1 Where the loan is cancelled at any stage of processing before disbursement of the funds, the Borrower shall be obligated to pay any loan originatio costs incurred.',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '3.2 Cancellation of the loan before disbursement of the funds should be communicated in writing by an oﬃcial letter.',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '3.3 If the loan is cancelled after receipt of the funds, the Borrower shall reimburse the disbursed amount plus the loan origination costs within 48 hours of receipt of the said funds be communicated in writing through an oﬃcial letter accompanied with the proof of refund. Failure to which Clause 6 of the Terms and Conditions shall take effect.',
                      style: TextStyle(fontSize: 15),
                    ),
                    
                    SizedBox(height: 10),
                    Text(
                      '4. Insurance',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '4.1 The Borrower undertakes to insure the collateral for the entire loan period.',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '4.2 The Borrower undertakes to endorse S.F.I.LTD as the principal beneﬁciary of any dues arising from an insurance claim relating to the motor vehicle used as a security.',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '4.3 The Borrower shall not use the motor vehicle nor permit it to be used for any purpose not permitted by the terms and conditions of the Insurance Policy nor permit to be done any act or thing by reason of which such Insurance Policy may be invalid.',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ACCEPT BUTTON — now goes to LoanApplicationScreen ✅
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoanApplicationScreen(), // ← changed
                    ),
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