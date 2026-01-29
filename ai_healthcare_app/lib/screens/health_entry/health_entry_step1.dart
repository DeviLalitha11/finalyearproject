import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class HealthEntryStep1 extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const HealthEntryStep1({super.key, this.existingData});

  @override
  State<HealthEntryStep1> createState() => _HealthEntryStep1State();
}

class _HealthEntryStep1State extends State<HealthEntryStep1> {
  final _formKey = GlobalKey<FormState>();

  final _heartRateController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = widget.existingData;
    if (data != null) {
      _heartRateController.text = data['heartRate']?.toString() ?? '';

      final bp = data['bloodPressure'];
      if (bp != null) {
        _systolicController.text = bp['systolic']?.toString() ?? '';
        _diastolicController.text = bp['diastolic']?.toString() ?? '';
      }
    }
  }

  void dispose() {
    _heartRateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    super.dispose();
  }

  void _continueToNextStep() {
    if (!_formKey.currentState!.validate()) return;

    final step1Data = {
      'heartRate': int.parse(_heartRateController.text),
      'bloodPressure': {
        'systolic': int.parse(_systolicController.text),
        'diastolic': int.parse(_diastolicController.text),
      },
    };

    Navigator.pushNamed(
      context,
      AppRoutes.healthEntryStep2,
      arguments: step1Data,
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Health Data Entry',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, AppRoutes.healthEntry),
            child:
                const Text('Start Over', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0EA5E9),
              Color(0xFF0284C7),
              Color(0xFF0369A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your current health metrics',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),

                /// STEP INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _StepDot(active: true),
                    _StepLine(),
                    _StepDot(active: false),
                    _StepLine(),
                    _StepDot(active: false),
                  ],
                ),

                const SizedBox(height: 30),

                /// FORM CARD
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vital Signs',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInput(
                            controller: _heartRateController,
                            label: 'Heart Rate',
                            unit: 'bpm',
                            icon: Icons.favorite,
                            color: Colors.red,
                            min: 40,
                            max: 200,
                          ),
                          const SizedBox(height: 20),
                          _buildInput(
                            controller: _systolicController,
                            label: 'Systolic BP',
                            unit: 'mmHg',
                            icon: Icons.monitor_heart,
                            color: Colors.blue,
                            min: 80,
                            max: 250,
                          ),
                          const SizedBox(height: 20),
                          _buildInput(
                            controller: _diastolicController,
                            label: 'Diastolic BP',
                            unit: 'mmHg',
                            icon: Icons.monitor_heart,
                            color: Colors.blue,
                            min: 50,
                            max: 150,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _continueToNextStep,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String unit,
    required IconData icon,
    required Color color,
    required int min,
    required int max,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        final num = int.tryParse(value ?? '');
        if (num == null || num < min || num > max) {
          return 'Enter valid $label';
        }
        return null;
      },
    );
  }
}

/// STEP UI
class _StepDot extends StatelessWidget {
  final bool active;
  const _StepDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 6,
      backgroundColor: active ? Colors.white : Colors.white54,
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 2,
      color: Colors.white54,
    );
  }
}
