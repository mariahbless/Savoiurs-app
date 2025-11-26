import 'package:flutter/material.dart';

class ProfileCardScreen extends StatelessWidget {
  const ProfileCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 3,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Profile Image / Logo
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color.fromARGB(255, 141, 220, 240),
                backgroundImage: const AssetImage("assets/profile.jpg"), 
                // Change this path to your actual profile image
              ),

              const SizedBox(height: 20),

              // Title (Name)
              const Text(
                "Mary Blessings Akello",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Role
              Text(
                "Computer Scientist ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                "A highly skilled computer scientist with experience in designing "
                "efficient information systems, analyzing user needs, and "
                "ensuring smooth system integration across multiple platforms.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              // Optional: Add a button or extra info
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
