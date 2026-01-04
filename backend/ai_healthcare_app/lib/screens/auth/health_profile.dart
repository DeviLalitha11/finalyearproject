import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthProfilePage extends StatefulWidget {
  const HealthProfilePage({super.key});

  @override
  State<HealthProfilePage> createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  String? _selectedGender;
  String? _selectedBloodGroup;
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F4F0), // Light mint
              Color(0xFFF0F9F6), // Pastel green
            ],
          ),
        ),
        child: Stack(
          children: [
            // Subtle medical illustration watermark
            Positioned(
              top: 150,
              left: 50,
              child: Icon(
                Icons.local_hospital,
                size: 100,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
            Positioned(
              bottom: 150,
              right: 50,
              child: Icon(
                Icons.favorite,
                size: 80,
                color: Colors.teal.withOpacity(0.1),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  // Top Bar
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF19B394),
                      ),
                      label: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Color(0xFF19B394),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F4EF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: Color(0xFF19B394),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Join our healthcare family',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Progress Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Step 1: User (completed)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF19B394),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      // Line to step 2
                      Container(
                        width: 40,
                        height: 2,
                        color: const Color(0xFF19B394),
                      ),
                      // Step 2: Heart (active)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF19B394),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      // Line to step 3
                      Container(
                        width: 40,
                        height: 2,
                        color: Colors.grey.shade300,
                      ),
                      // Step 3: Lock (inactive)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock,
                          color: Colors.grey.shade500,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Section Title
                  const Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Health Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your basic health details',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Age Field
                          TextFormField(
                            controller: _ageController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your age';
                              }
                              // Check if it's a valid number
                              final age = int.tryParse(value);
                              if (age == null) {
                                return 'Enter a valid age';
                              }
                              if (age < 1 || age > 120) {
                                return 'Enter a valid age (1-120)';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter your age',
                              prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Gender Pills
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedGender = 'Male';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedGender == 'Male'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedGender == 'Male'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'Male',
                                  style: TextStyle(
                                    color: _selectedGender == 'Male'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedGender = 'Female';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedGender == 'Female'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedGender == 'Female'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'Female',
                                  style: TextStyle(
                                    color: _selectedGender == 'Female'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedGender = 'Other';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedGender == 'Other'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedGender == 'Other'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'Other',
                                  style: TextStyle(
                                    color: _selectedGender == 'Other'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedGender = 'Prefer not to say';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor:
                                      _selectedGender == 'Prefer not to say'
                                          ? const Color(0xFF19B394)
                                          : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color:
                                        _selectedGender == 'Prefer not to say'
                                            ? const Color(0xFF19B394)
                                            : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'Prefer not to say',
                                  style: TextStyle(
                                    color:
                                        _selectedGender == 'Prefer not to say'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Blood Group Pills
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Blood Group',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'A+';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'A+'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'A+'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'A+',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'A+'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'A-';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'A-'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'A-'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'A-',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'A-'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'B+';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'B+'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'B+'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'B+',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'B+'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'B-';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'B-'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'B-'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'B-',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'B-'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'AB+';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'AB+'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'AB+'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'AB+',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'AB+'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'AB-';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'AB-'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'AB-'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'AB-',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'AB-'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'O+';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'O+'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'O+'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'O+',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'O+'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedBloodGroup = 'O-';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: _selectedBloodGroup == 'O-'
                                      ? const Color(0xFF19B394)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: _selectedBloodGroup == 'O-'
                                        ? const Color(0xFF19B394)
                                        : Colors.grey,
                                  ),
                                ),
                                child: Text(
                                  'O-',
                                  style: TextStyle(
                                    color: _selectedBloodGroup == 'O-'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Bottom Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Back'),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFF19B394),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    if (_selectedGender == null ||
                                        _selectedBloodGroup == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please select gender and blood group'),
                                        ),
                                      );
                                      return;
                                    }

                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('User not authenticated')),
                                      );
                                      return;
                                    }

                                    final firebaseService =
                                        Provider.of<FirebaseService>(context,
                                            listen: false);

                                    try {
                                      await firebaseService
                                          .addUserDataToFirebase(
                                        userId: user.uid,
                                        name: user.displayName ?? '',
                                        email: user.email ?? '',
                                        age: int.parse(_ageController.text),
                                        gender: _selectedGender!,
                                        healthData: {
                                          'bloodGroup': _selectedBloodGroup!,
                                        },
                                      );

                                      if (mounted) {
                                        Navigator.pushNamed(
                                            context, '/dashboard');
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to save data: $e')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF19B394),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Continue →',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Footer Text
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'By creating an account, you agree to our ',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Color(0xFF19B394),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF19B394),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
