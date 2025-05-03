import 'package:flutter/material.dart';
import 'package:flutter_application_app/Screen/LoginScreen.dart';
import 'package:flutter_application_app/Screen/RegistrationScreen.dart';
import 'package:flutter_application_app/Style/Colors.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color.fromARGB(255, 155, 114, 250), Color.fromARGB(255, 255, 255, 255)]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.only(top: 200.0)),
            const SizedBox(height: 100),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                child: const Center(
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              '@Copyright Russo&Favaro 2025',
              style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
