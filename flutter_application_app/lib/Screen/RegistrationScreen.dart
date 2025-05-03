import 'package:flutter/material.dart';
import 'package:flutter_application_app/Provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatelessWidget {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const Text(
              'Register',
              style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: TextField(
                controller: nameController,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: TextField(
                controller: surnameController,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: TextField(
                controller: usernameController,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: TextField(
                controller: emailController,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: TextField(
                controller: passwordController,
                cursorColor: const Color.fromARGB(255, 0, 0, 0),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                await authProvider.register(
                  context,
                  nameController.text,
                  surnameController.text,
                  emailController.text,
                  passwordController.text,
                  usernameController.text,
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
          ],
        ),
      ),
    );
  }
}
