import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationScreen> {
  // 1. PLACE THE CODE HERE
  Future<void> addUser(String name, String email) async {
    // ... code you pasted above ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          // 2. CALL THE FUNCTION HERE
          addUser("John Doe", "john@example.com");
        },
        child: const Text("Register"),
      ),
    );
  }
}
