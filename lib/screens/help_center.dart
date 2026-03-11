import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Contact Us",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text("+256 783 519 023"),
            ),

            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text("saviours@gmail.com"),
            ),

            ListTile(
              leading: Icon(Icons.location_on, color: Colors.red),
              title: Text("Ntinda Complex - Kampala"),
            ),
          ],
        ),
      ),
    );
  }
}
