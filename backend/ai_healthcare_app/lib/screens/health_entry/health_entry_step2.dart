import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

enum StepState { completed, active, inactive }

class HealthEntryStep2 extends StatefulWidget {
  const HealthEntryStep2({super.key});

  @override
  State<HealthEntryStep2> createState() => _HealthEntryStep2State();
}

class _HealthEntryStep2State extends State<HealthEntryStep2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _oxygenController = TextEditingController();

  @override
  void dispose() {
    _bloodSugarController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _oxygenController.dispose();
    super.dispose();
  }

  void _continueToNextStep() {
    if (!_formKey.currentState!.validate()) return;

    final step1Data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final step2Data = {
      ...step1Data,
      'bloodSugar': int.parse(_bloodSugarController.text),
      'temperature': double.parse(_temperatureController.text),
      'weight': double.parse(_weightController.text),
      'oxygen': int.parse(_oxygenController.text),
    };

    Navigator.pushNamed(
      context,
      AppRoutes.healthEntryStep3,
      arguments: step2Data,
    );
  }

  void _goBack() {
    Navigator.of(context).pop();
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
                  'Enter your current health metrics',
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
                      state: StepState.active,
                    ), // Step 2
                    _buildStepConnector(isCompleted: false),
                    _buildStepIndicator(
                      step: 3,
                      state: StepState.inactive,
                    ), // Step 3
                  ],
                ),

                const SizedBox(height: 40),

                // Health Metrics Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Health Metrics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Please enter your additional health measurements',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 32),

                        // Blood Sugar Field
                        _buildInputField(
                          controller: _bloodSugarController,
                          label: 'Blood Sugar',
                          unit: 'mg/dL',
                          icon: Icons.water_drop,
                          color: Colors.amber,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter blood sugar level';
                            }
                            final sugar = int.tryParse(value);
                            if (sugar == null || sugar < 50 || sugar > 500) {
                              return 'Enter valid blood sugar (50-500 mg/dL)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Temperature Field
                        _buildInputField(
                          controller: _temperatureController,
                          label: 'Temperature',
                          unit: '°F',
                          icon: Icons.thermostat,
                          color: Colors.orange,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter temperature';
                            }
                            final temp = double.tryParse(value);
                            if (temp == null || temp < 95 || temp > 105) {
                              return 'Enter valid temperature (95-105°F)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Weight Field
                        _buildInputField(
                          controller: _weightController,
                          label: 'Weight',
                          unit: 'kg',
                          icon: Icons.monitor_weight,
                          color: Colors.green,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null || weight < 30 || weight > 200) {
                              return 'Enter valid weight (30-200 kg)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Oxygen Level Field
                        _buildInputField(
                          controller: _oxygenController,
                          label: 'Oxygen Level',
                          unit: '%',
                          icon: Icons.air,
                          color: Colors.blue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter oxygen level';
                            }
                            final oxygen = int.tryParse(value);
                            if (oxygen == null || oxygen < 70 || oxygen > 100) {
                              return 'Enter valid oxygen level (70-100%)';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
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

            // Continue Button
            Expanded(
              child: ElevatedButton(
                onPressed: _continueToNextStep,
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
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
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
            fontWeight: FontWeight.bold,
          ),
        );
        break;
      case StepState.inactive:
        backgroundColor = Colors.grey[300]!;
        borderColor = Colors.grey[400]!;
        child = Text(
          step.toString(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: state == StepState.active
            ? [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      width: 40,
      height: 2,
      color: isCompleted ? const Color(0xFF10B981) : Colors.grey[300],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String unit,
    required IconData icon,
    required Color color,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 24),
            ),
            suffixText: unit,
            suffixStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
