import 'package:flutter/material.dart';

class ReportsCard extends StatelessWidget {
  final VoidCallback onTap;

  const ReportsCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2A3A), // Dark card
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, color: Colors.white, size: 26),
            SizedBox(width: 10),
            Text(
              "Reports",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
