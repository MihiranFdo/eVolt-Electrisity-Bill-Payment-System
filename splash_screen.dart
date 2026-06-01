import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay navigation using Future.delayed instead of direct navigation
    Future.delayed(const Duration(seconds: 3), _checkAuthAndNavigate);
  }

  void _checkAuthAndNavigate() {
    final user = FirebaseAuth.instance.currentUser;
    
    // Use Future.microtask to ensure navigation happens after build
    Future.microtask(() {
      if (!mounted) return; // Check if widget still mounted
      
      if (user != null) {
        // User is logged in
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // User is not logged in
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'eV',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'eVolt',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Electricity Bill Payment',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: Colors.blue.shade700,
            ),
          ],
        ),
      ),
    );
  }
}