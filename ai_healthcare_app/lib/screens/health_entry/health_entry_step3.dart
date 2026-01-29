import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum StepState { completed, active, inactive }

class HealthEntryStep3 extends StatefulWidget {
  const HealthEntryStep3({super.key});

  @override
  State<HealthEntryStep3> createState() => _HealthEntryStep3State();
}

class _HealthEntryStep3State extends State<HealthEntryStep3> {
  final Set<String> _selectedSymptoms = {};

  final List<String> _symptoms = [
    'Headache',
    'Fever',
    'Cough',
    'Fatigue',
    'Chest Pain',
    'Shortness of Breath',
    'Nausea',
    'Dizziness',
    'Sore Throat',
    'Body Aches',
    'Loss of Taste',
    'Loss of Smell',
    'Runny Nose',
    'Sneezing',
    'Itchy Eyes',
    'Rash',
  ];

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _analyzeHealthData() async {
    final stepData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final height = 170;
    final bmi = stepData['weight'] / ((height / 100) * (height / 100));

    final allStepsCombinedData = {
      'heartRate': stepData['heartRate'],
      'bloodPressure': stepData['bloodPressure'],
      'bloodSugar': stepData['bloodSugar'],
      'temperature': stepData['temperature'],
      'oxygen': stepData['oxygen'],
      'weight': stepData['weight'],
      'bmi': bmi.toStringAsFixed(1),
      'symptoms': _selectedSymptoms.toList(),
    };

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'healthData': {
          ...allStepsCombinedData,
          'updatedAt': FieldValue.serverTimestamp(),
        }
      },
      SetOptions(merge: true),
    );

    Navigator.popUntil(
      context,
      ModalRoute.withName(AppRoutes.dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goBack,
        ),
        title: const Text(
          'Health Data Entry',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.healthEntry),
            child: const Text(
              'Start Over',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0EA5E9), // Light blue
              Color(0xFF0284C7), // Medium blue
              Color(0xFF0369A1), // Darker blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Subtitle
                const Text(
                  'Select your current symptoms',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 30),

                // Step Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(
                      step: 1,
                      state: StepState.completed,
                    ), // Step 1
                    _buildStepConnector(isCompleted: true),
                    _buildStepIndicator(
                      step: 2,
                      state: StepState.completed,
                    ), // Step 2
                    _buildStepConnector(isCompleted: true),
                    _buildStepIndicator(
                      step: 3,
                      state: StepState.active,
                    ), // Step 3
                  ],
                ),

                const SizedBox(height: 40),

                // Current Symptoms Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Symptoms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Select all symptoms you are currently experiencing',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                      const SizedBox(height: 24),

                      // Symptoms Wrap
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _symptoms.map((symptom) {
                          final isSelected = _selectedSymptoms.contains(
                            symptom,
                          );
                          return FilterChip(
                            label: Text(
                              symptom,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) => _toggleSymptom(symptom),
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.8,
                            ),
                            selectedColor: const Color(0xFF10B981),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Back Button
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF10B981), width: 2),
                  foregroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Analyze Button
            Expanded(
              child: ElevatedButton(
                onPressed: _analyzeHealthData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Analyze Health Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.analytics, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator({required int step, required StepState state}) {
    const double size = 32;
    Color backgroundColor;
    Color borderColor;
    Widget child;

    switch (state) {
      case StepState.completed:
        backgroundColor = const Color(0xFF10B981); // Green
        borderColor = const Color(0xFF10B981);
        child = const Icon(Icons.check, color: Colors.white, size: 16);
        break;
      case StepState.active:
        backgroundColor = const Color(0xFF10B981); // Green
        borderColor = const Color(0xFF10B981);
        child = Text(
          step.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        );
        break;
      case StepState.inactive:
        backgroundColor = Colors.white.withValues(alpha: 0.2);
        borderColor = Colors.white.withValues(alpha: 0.3);
        child = Text(
          step.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        );
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      width: 40,
      height: 2,
      color: isCompleted
          ? const Color(0xFF10B981)
          : Colors.white.withValues(alpha: 0.3),
    );
  }
}
