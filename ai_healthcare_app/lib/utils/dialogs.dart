import 'package:flutter/material.dart';

void showHealthDataMissingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Health Data Required'),
      content: const Text(
        'Please fill your health data before proceeding with AI analysis.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
