import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../health_entry/health_entry_step1.dart';

import '../profile/profile_page.dart';
import '../../routes/app_routes.dart';
import '../../services/health_validation_service.dart';
import '../../utils/dialogs.dart';
import '../../services/ai_analysis_service.dart';
import '../ai_analysis/ai_result_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<bool> _isDataSharingEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dataSharing') ?? false;
  }

  void _navigateToAIAnalysis() async {
    final enabled = await _isDataSharingEnabled();
    if (!enabled) {
      _showDataSharingRequiredDialog();
      return;
    }

    final hasHealthData = await HealthValidationService.hasRequiredHealthData();

    if (!hasHealthData) {
      showHealthDataMissingDialog(context);
      return;
    }

    try {
      // 🔄 Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // 🤖 Run AI analysis
      final results = await AIAnalysisService.runAnalysis();

      // ❌ Close loading
      Navigator.pop(context);

      // ✅ Navigate with results
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.aiResult,
          arguments: results,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(e.toString());
    }
  }

  void _navigateToReports() async {
    final enabled = await _isDataSharingEnabled();
    if (enabled && mounted) {
      Navigator.pushNamed(context, AppRoutes.records);
    } else {
      _showDataSharingRequiredDialog();
    }
  }

  void _showDataSharingRequiredDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Data Sharing Required'),
        content: const Text(
          'Enable Data Sharing in Profile settings to access this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            child: const Text('Go to Profile'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('AI Analysis Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// ------------------ HEALTH SCORE LOGIC ------------------

  int _calculateHealthScore(Map<String, dynamic> health) {
    int score = 100;

    final hr = health['heartRate'];
    final sugar = health['bloodSugar'];

    if (hr != null && (hr < 60 || hr > 100)) score -= 15;
    if (sugar != null && sugar > 140) score -= 20;

    return score.clamp(0, 100);
  }

  Color _scoreColor(int score) {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  String _scoreText(int score) {
    if (score >= 75) return "Good";
    if (score >= 50) return "Moderate";
    return "High Risk";
  }

  /// -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final health = data['healthData'] ?? {};
        final lastUpdated = health['updatedAt'] as Timestamp?;
        final hasHealthData = health.isNotEmpty;

        final score = _calculateHealthScore(health);

        return Scaffold(
          backgroundColor: const Color(0xFF020617),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---------------- HEADER ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Welcome back,",
                              style: TextStyle(color: Colors.grey)),
                          Text(
                            data['name'] ??
                                user.email?.split('@').first ??
                                'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// ---------------- HEALTH SCORE ----------------
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: _scoreColor(score),
                          child: Text(
                            "$score",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Health Score",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _scoreText(score),
                              style: TextStyle(
                                color: _scoreColor(score),
                              ),
                            ),
                            if (lastUpdated != null)
                              Text(
                                "Last updated: ${DateTime.now().difference(lastUpdated.toDate()).inDays} days ago",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ---------------- HEALTH DATA ----------------
                  hasHealthData
                      ? GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            if (health['heartRate'] != null)
                              _metricCard(
                                  "Heart Rate",
                                  "${health['heartRate']} bpm",
                                  Icons.favorite,
                                  Colors.red),
                            if (health['bloodPressure'] != null)
                              _metricCard(
                                "Blood Pressure",
                                "${health['bloodPressure']['systolic']}/${health['bloodPressure']['diastolic']} mmHg",
                                Icons.monitor_heart,
                                Colors.cyan,
                              ),
                            if (health['bloodSugar'] != null)
                              _metricCard(
                                  "Blood Sugar",
                                  "${health['bloodSugar']} mg/dL",
                                  Icons.water_drop,
                                  Colors.amber),
                            if (health['bmi'] != null)
                              _metricCard("BMI", health['bmi'].toString(),
                                  Icons.accessibility, Colors.green),
                          ],
                        )
                      : _addHealthCard(context, health),

                  const SizedBox(height: 24),

                  /// ---------------- QUICK ACTIONS ----------------
                  Row(
                    children: [
                      Expanded(
                        child: _action(
                          "Add Data",
                          Icons.add,
                          const Color(0xFF10B981),
                          () => Navigator.pushNamed(
                              context, AppRoutes.healthEntry),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _action(
                          "AI Analysis",
                          Icons.analytics,
                          Colors.grey,
                          _navigateToAIAnalysis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _action(
                          "Reports",
                          Icons.description,
                          const Color(0xFF374151),
                          _navigateToReports,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// ---------------- REMINDER ----------------
                  if (!hasHealthData)
                    _reminderCard(
                        "Add your first health record to unlock insights"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------------- UI HELPERS ----------------

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _addHealthCard(
    BuildContext context,
    Map<String, dynamic> health,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HealthEntryStep1(
              existingData: health, // ✅ edit support
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: Column(
          children: const [
            Icon(Icons.add_circle_outline, size: 48, color: Colors.green),
            SizedBox(height: 16),
            Text(
              "Add Your First Health Record",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _reminderCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.notifications, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Don’t forget to update your health data today!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
