import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/ai_analysis_service.dart';
import '../../routes/app_routes.dart';

class AIResultPage extends StatefulWidget {
  const AIResultPage({super.key});

  @override
  State<AIResultPage> createState() => _AIResultPageState();
}

class _AIResultPageState extends State<AIResultPage> {
  bool aiLoading = true;
  Map<String, dynamic>? aiResult;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _runAI();
  }

  Future<void> _runAI() async {
    try {
      final res = await AIAnalysisService.runAnalysis();
      setState(() {
        aiResult = res;
        aiLoading = false;
      });
    } catch (e) {
      setState(() => aiLoading = false);
    }
  }

  Color _getStatusColor(String? level) {
    switch (level) {
      case "Very Low":
      case "Low":
        return const Color(0xFF10B981);
      case "Moderate":
        return const Color(0xFFF59E0B);
      case "High":
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  /// Gradient color based on probability percentage
  Color _getPercentageColor(double percentage) {
    if (percentage >= 70) return const Color(0xFFEF4444); // Red
    if (percentage >= 50) return const Color(0xFFF59E0B); // Orange
    if (percentage >= 30) return const Color(0xFFFBBF24); // Yellow
    return const Color(0xFF10B981); // Green
  }

  String _getRiskMessage(String? level) {
    switch (level) {
      case "Very Low":
        return "Excellent! Your health indicators look great.";
      case "Low":
        return "Great! Keep maintaining your healthy lifestyle.";
      case "Moderate":
        return "Some areas need attention. Follow the suggestions below.";
      case "High":
        return "Please consult a doctor for proper medical advice.";
      default:
        return "Analyzing your health data...";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "AI HEALTH REPORT",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle,
                color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF10B981)),
            );
          }

          final userData =
              snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final health =
              userData['healthData'] as Map<String, dynamic>? ?? {};
          final bp =
              health['bloodPressure'] as Map<String, dynamic>? ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDisclaimerBox(),
                const SizedBox(height: 20),

                if (!aiLoading && aiResult != null)
                  _buildClassificationCard(aiResult!['riskLevel']),

                const SizedBox(height: 30),

                _buildSectionTitle("VITAL METRICS"),
                const SizedBox(height: 12),
                _buildVitalsCarousel(health, bp),

                const SizedBox(height: 35),

                // ---------- DISEASE PROBABILITY PREDICTIONS ----------
                _buildSectionTitle("DISEASE PROBABILITY ANALYSIS"),
                const SizedBox(height: 6),
                const Text(
                  "Chance of each disease based on your health data",
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 14),
                if (aiLoading)
                  _skeletonLoader()
                else if (aiResult != null &&
                    (aiResult!['predictions'] as List?)?.isNotEmpty == true)
                  _buildPredictionsWithPercentage(
                      aiResult!['predictions'] as List)
                else
                  _buildNoDataCard(),

                const SizedBox(height: 30),

                // ---------- DETECTED RISKS (if any) ----------
                if (aiResult != null &&
                    (aiResult!['diseases'] as List?)?.isNotEmpty == true) ...[
                  _buildSectionTitle("⚠️ HIGH PRIORITY ALERTS"),
                  const SizedBox(height: 12),
                  if (aiLoading)
                    _skeletonLoader()
                  else
                    _buildHighPriorityAlerts(
                        aiResult!['diseases'] as List,
                        aiResult!['predictions'] as List? ?? []),
                  const SizedBox(height: 25),
                ],

                // ---------- AI SUGGESTIONS ----------
                _buildSectionTitle("AI SUGGESTIONS"),
                const SizedBox(height: 12),
                if (aiLoading)
                  _skeletonLoader()
                else
                  _buildSuggestionsCards(
                      (aiResult?['suggestions'] as List?) ?? []),

                const SizedBox(height: 25),

                // ---------- EXPLANATIONS ----------
                if (aiResult != null &&
                    (aiResult!['explanations'] as List?)?.isNotEmpty ==
                        true) ...[
                  _buildSectionTitle("WHY THIS RESULT?"),
                  const SizedBox(height: 12),
                  if (!aiLoading)
                    _buildReasoningBox(aiResult!['explanations']),
                ],

                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildDisclaimerBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.amber, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "AI analysis is for informational purposes only. These are predictions, not diagnoses. Always consult a doctor.",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassificationCard(String? level) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getStatusColor(level).withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: _getStatusColor(level).withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(
            level == "Low" || level == "Very Low"
                ? Icons.check_circle_outline
                : level == "Moderate"
                    ? Icons.info_outline
                    : Icons.health_and_safety_outlined,
            color: _getStatusColor(level),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            "${level?.toUpperCase() ?? 'ANALYZING'} RISK",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _getStatusColor(level),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _getRiskMessage(level),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildVitalsCarousel(
      Map<String, dynamic> health, Map<String, dynamic> bp) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _vitalCard("Heart Rate", "${health['heartRate'] ?? '--'} BPM",
              Icons.favorite, Colors.redAccent),
          _vitalCard(
              "Blood Pressure",
              "${bp['systolic'] ?? '--'}/${bp['diastolic'] ?? '--'}",
              Icons.speed,
              Colors.orangeAccent),
          _vitalCard("Oxygen", "${health['oxygen'] ?? '--'}%", Icons.air,
              Colors.blueAccent),
          _vitalCard("Glucose", "${health['bloodSugar'] ?? '--'} mg/dL",
              Icons.water_drop, Colors.purpleAccent),
        ],
      ),
    );
  }

  Widget _vitalCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Text(label,
              style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  /// ✅ NEW: Display all diseases with their probability percentages
  Widget _buildPredictionsWithPercentage(List predictions) {
    // Sort by probability descending
    final sortedPredictions = List.from(predictions);
    sortedPredictions.sort((a, b) {
      final aPct = (a['percentage'] ?? 0).toDouble();
      final bPct = (b['percentage'] ?? 0).toDouble();
      return bPct.compareTo(aPct);
    });

    return Column(
      children: sortedPredictions.map((pred) {
        final disease = pred['disease']?.toString() ?? 'Unknown';
        final percentage = (pred['percentage'] ?? 0).toDouble();
        final severity = pred['severity']?.toString() ?? 'Low';
        final detected = pred['detected'] ?? false;
        final reasons = (pred['reasons'] as List?) ?? [];

        final color = _getPercentageColor(percentage);

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: detected
                  ? color.withOpacity(0.5)
                  : Colors.white.withOpacity(0.06),
              width: detected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease name + percentage
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getDiseaseIcon(disease),
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          disease,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$severity Risk",
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Percentage badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.4)),
                    ),
                    child: Text(
                      "${percentage.toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (percentage / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.7),
                              color,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Reasons (if any)
              if (reasons.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...reasons.take(3).map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.circle, size: 5, color: color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                r.toString(),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Icon per disease
  IconData _getDiseaseIcon(String disease) {
    final d = disease.toLowerCase();
    if (d.contains('diabetes')) return Icons.bloodtype;
    if (d.contains('heart')) return Icons.favorite;
    if (d.contains('hypertension')) return Icons.speed;
    if (d.contains('kidney')) return Icons.water_drop;
    if (d.contains('thyroid')) return Icons.emoji_nature;
    return Icons.medical_services;
  }

  /// High priority alerts for detected diseases
  Widget _buildHighPriorityAlerts(List diseases, List predictions) {
    return Column(
      children: diseases.map((disease) {
        // Find matching prediction for this disease
        final match = predictions.firstWhere(
          (p) => p['disease']?.toString().toLowerCase() ==
              disease.toString().toLowerCase(),
          orElse: () => {},
        );

        final percentage = (match['percentage'] ?? 0).toDouble();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.redAccent.withOpacity(0.15),
                Colors.orangeAccent.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.redAccent, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (percentage > 0)
                      Text(
                        "Risk Probability: ${percentage.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoDataCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white54),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "No prediction data available. Please add your health data.",
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsCards(List suggestions) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final limitedSuggestions = suggestions.take(6).toList();

    return Column(
      children: limitedSuggestions.asMap().entries.map((entry) {
        final index = entry.key;
        final suggestion = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF10B981).withOpacity(0.1),
                const Color(0xFF34D399).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    suggestion.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle,
                    color: Color(0xFF10B981), size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReasoningBox(List? explanations) {
    if (explanations == null || explanations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: explanations.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lightbulb_outline,
                      color: Color(0xFF10B981), size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    e.toString(),
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: Colors.white24,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          }
          if (i == 1) Navigator.pushNamed(context, AppRoutes.healthEntry);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined), label: "Add Data"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: "Insights"),
        ],
      ),
    );
  }

  Widget _skeletonLoader() {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          height: 90,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
