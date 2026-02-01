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
      case "Low":
        return const Color(0xFF10B981);
      case "Moderate":
        return const Color(0xFFF59E0B);
      case "High":
        return const Color(0xFFFF8C42);
      default:
        return const Color(0xFF3B82F6);
    }
  }

  String _getRiskMessage(String? level) {
    switch (level) {
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
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF10B981)),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final health = userData['healthData'] as Map<String, dynamic>? ?? {};
          final bp = health['bloodPressure'] as Map<String, dynamic>? ?? {};

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

                // AI Detected Risks - Beautiful Cards
                if (aiResult != null && (aiResult!['diseases'] as List?)?.isNotEmpty == true) ...[
                  _buildSectionTitle("AI DETECTED RISKS"),
                  const SizedBox(height: 12),
                  if (aiLoading)
                    _skeletonLoader()
                  else
                    _buildRisksGrid(aiResult!['diseases'] as List),
                  const SizedBox(height: 25),
                ],

                // Suggestions - Beautiful Cards
                _buildSectionTitle("AI SUGGESTIONS"),
                const SizedBox(height: 12),
                if (aiLoading)
                  _skeletonLoader()
                else
                  _buildSuggestionsCards((aiResult!['suggestions'] as List?) ?? []),

                const SizedBox(height: 25),

                // Explanations
                if (aiResult != null && (aiResult!['explanations'] as List?)?.isNotEmpty == true) ...[
                  _buildSectionTitle("WHY THIS RESULT?"),
                  const SizedBox(height: 12),
                  if (!aiLoading) _buildReasoningBox(aiResult!['explanations']),
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
              "AI analysis can make mistakes. These suggestions are for informational purposes. Always consult a doctor.",
              style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w500),
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
        border: Border.all(color: _getStatusColor(level).withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(
            level == "Low"
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
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
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

  Widget _buildVitalsCarousel(Map<String, dynamic> health, Map<String, dynamic> bp) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _vitalCard("Heart Rate", "${health['heartRate'] ?? '--'} BPM", Icons.favorite, Colors.redAccent),
          _vitalCard("Blood Pressure", "${bp['systolic'] ?? '--'}/${bp['diastolic'] ?? '--'}", Icons.speed, Colors.orangeAccent),
          _vitalCard("Oxygen", "${health['oxygen'] ?? '--'}%", Icons.air, Colors.blueAccent),
          _vitalCard("Glucose", "${health['bloodSugar'] ?? '--'} mg/dL", Icons.water_drop, Colors.purpleAccent),
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
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRisksGrid(List diseases) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: diseases.take(6).map((disease) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.redAccent.withOpacity(0.15),
                Colors.orangeAccent.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                disease.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestionsCards(List suggestions) {
    final limitedSuggestions = suggestions.take(5).toList();
    
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
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
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
                const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
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
                  child: const Icon(Icons.lightbulb_outline, color: Color(0xFF10B981), size: 16),
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
          if (i == 0) Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          if (i == 1) Navigator.pushNamed(context, AppRoutes.healthEntry);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Add Data"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: "Insights"),
        ],
      ),
    );
  }

  Widget _skeletonLoader() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}