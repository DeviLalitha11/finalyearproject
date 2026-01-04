import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class AIAnalysisPage extends StatefulWidget {
  final Map<String, dynamic>? analysisResults;

  const AIAnalysisPage({super.key, this.analysisResults});

  @override
  State<AIAnalysisPage> createState() => _AIAnalysisPageState();
}

class _AIAnalysisPageState extends State<AIAnalysisPage> {
  late Map<String, dynamic> _analysisResults;

  @override
  void initState() {
    super.initState();
    // Get results from widget parameter or route arguments
    _analysisResults = widget.analysisResults ?? {};
    if (_analysisResults.isEmpty) {
      // Try to get from route arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is Map<String, dynamic>) {
          setState(() {
            _analysisResults = args;
          });
        }
      });
    }
  }

  Widget _buildPredictionCards() {
    return Column(
      children: [
        // Heart Disease Card
        _buildPredictionCard(
          'Heart Disease',
          _analysisResults['heart_disease']?.toString() ?? 'Low Risk',
          Icons.favorite,
          _getRiskColor(
            _analysisResults['heart_disease']?.toString() ?? 'Low Risk',
          ),
          _getHeartDescription(
            _analysisResults['heart_disease']?.toString() ?? 'Low Risk',
          ),
          0.92,
        ),
        const SizedBox(height: 16),

        // Hypertension Card
        _buildPredictionCard(
          'Hypertension',
          _analysisResults['hypertension']?.toString() ?? 'Normal',
          Icons.monitor_heart,
          _getRiskColor(
            _analysisResults['hypertension']?.toString() ?? 'Normal',
          ),
          _getHypertensionDescription(
            _analysisResults['hypertension']?.toString() ?? 'Normal',
          ),
          0.85,
        ),
        const SizedBox(height: 16),

        // Diabetes Card
        _buildPredictionCard(
          'Type 2 Diabetes',
          _analysisResults['diabetes']?.toString() ?? 'Low Risk',
          Icons.restaurant,
          _getRiskColor(_analysisResults['diabetes']?.toString() ?? 'Low Risk'),
          _getDiabetesDescription(
            _analysisResults['diabetes']?.toString() ?? 'Low Risk',
          ),
          0.88,
        ),
      ],
    );
  }

  Widget _buildPredictionCard(
    String title,
    String risk,
    IconData icon,
    Color color,
    String description,
    double accuracy,
  ) {
    return Card(
      color: const Color(0xFF1C2F4A).withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getRiskLabel(risk),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(color: Color(0xFFB0C4DE), fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Prediction Accuracy',
              style: TextStyle(color: Color(0xFFB0C4DE), fontSize: 12),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: accuracy,
              backgroundColor: const Color(0xFFB0C4DE).withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${(accuracy * 100).toInt()}% Risk',
                  style: const TextStyle(
                    color: Color(0xFFB0C4DE),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(_getTrendIcon(risk), color: color, size: 16),
                const SizedBox(width: 4),
                Text(
                  _getStatusText(risk),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRiskLabel(String risk) {
    if (risk.contains('High')) return 'High';
    if (risk.contains('Moderate')) return 'Moderate';
    return 'Low';
  }

  Color _getRiskColor(String risk) {
    if (risk.contains('High')) return const Color(0xFFEF4444);
    if (risk.contains('Moderate')) return const Color(0xFFF5B74F);
    return const Color(0xFF1ED1A2);
  }

  IconData _getTrendIcon(String risk) {
    if (risk.contains('High')) return Icons.trending_up;
    if (risk.contains('Moderate')) return Icons.trending_up;
    return Icons.arrow_upward;
  }

  String _getStatusText(String risk) {
    if (risk.contains('High')) return 'At Risk';
    if (risk.contains('Moderate')) return 'Monitor';
    return 'Stable';
  }

  String _getHeartDescription(String risk) {
    if (risk.contains('High')) {
      return 'Elevated risk detected. Consult a cardiologist for comprehensive evaluation and consider lifestyle modifications.';
    } else if (risk.contains('Moderate')) {
      return 'Moderate risk indicators present. Regular monitoring and preventive measures recommended.';
    }
    return 'Heart health indicators are within normal range. Continue maintaining a healthy lifestyle.';
  }

  String _getHypertensionDescription(String risk) {
    if (risk.contains('High')) {
      return 'High blood pressure detected. Immediate medical consultation required. Reduce sodium intake and monitor regularly.';
    } else if (risk.contains('Moderate')) {
      return 'Slightly elevated readings detected. Consider reducing sodium intake and regular monitoring.';
    }
    return 'Blood pressure readings are within healthy range. Maintain regular check-ups.';
  }

  String _getDiabetesDescription(String risk) {
    if (risk.contains('High')) {
      return 'High diabetes risk detected. Consult an endocrinologist for blood sugar monitoring and management.';
    } else if (risk.contains('Moderate')) {
      return 'Moderate diabetes risk. Consider lifestyle modifications and regular blood sugar monitoring.';
    }
    return 'Blood sugar levels are healthy. Keep up with balanced diet and regular exercise.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Health Analysis',
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Powered by Advanced ML Models',
              style: TextStyle(
                color: Color(0xFFB0C4DE),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy, color: Color(0xFFFFFFFF)),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E7F7C), // Top: teal
              Color(0xFF243A6F), // Middle: indigo
              Color(0xFF4A2B7F), // Bottom: purple
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Analysis Complete Card
                Card(
                  color: const Color(0xFF1C2F4A).withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1ED1A2,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.psychology, // Brain icon
                            color: Color(0xFF1ED1A2),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Analysis Complete',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Based on your latest health data',
                                style: TextStyle(
                                  color: Color(0xFFB0C4DE),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '89% accuracy',
                          style: TextStyle(
                            color: Color(0xFF1ED1A2),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Section Title
                const Text(
                  'Health Predictions',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                // Prediction Cards
                _buildPredictionCards(),

                const SizedBox(height: 32),

                // AI Recommendations Card
                Card(
                  color: const Color(0xFF1C2F4A).withValues(alpha: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Recommendations',
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _analysisResults['recommendations']?.toString() ??
                              'Maintain a healthy lifestyle with regular exercise and balanced diet.',
                          style: const TextStyle(
                            color: Color(0xFFB0C4DE),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Primary Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.records),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ED1A2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View Detailed Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // AI is active
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1C2F4A),
        selectedItemColor: const Color(0xFF1ED1A2),
        unselectedItemColor: const Color(0xFFB0C4DE),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Data',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Reports',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.dashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.healthEntry);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.aiAnalysis);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.records);
              break;
            case 4:
              Navigator.pushNamed(context, AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }
}
