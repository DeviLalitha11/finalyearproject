import 'package:flutter/material.dart';

/// Small testimonial card with avatar, stars and quote.
class TestimonialCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String role;
  final String quote;

  const TestimonialCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.role,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    role,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [Text('★★★★★', style: TextStyle(color: Colors.amber))],
          ),
          const SizedBox(height: 8),
          Text(quote, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}
