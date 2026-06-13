import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

 @override
 _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
 @override
 void initState() {
 super.initState();
 
 Timer(Duration(seconds: 4), () {
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(builder: (context) => OnboardingScreen()),
 );
 });

 }
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 backgroundColor: Colors.white,
 body: Center(
 child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [

 Image.asset('assets/logo.png', height: 200),
 SizedBox(height: 40),
 Text(
 "My Awesome App",
 style: TextStyle(
 color: const Color.fromARGB(255, 75, 176, 235),
 fontSize: 24,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 60),
 CircularProgressIndicator(color: const Color.fromARGB(255, 43, 166, 242)),
 ],
 ),
 ),
 );
 }
}