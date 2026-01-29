import 'package:flutter/material.dart';
import '../../services/ai_analysis_service.dart';

class AIResultPage extends StatefulWidget {
  const AIResultPage({super.key});

  @override
  State<AIResultPage> createState() => _AIResultPageState();
}

class _AIResultPageState extends State<AIResultPage> {
  bool loading = true;
  Map<String, dynamic>? result;
  String? error;

  @override
  void initState() {
    super.initState();
    _runAI();
  }

  Future<void> _runAI() async {
    try {
      final res = await AIAnalysisService.runAnalysis();
      setState(() {
        result = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Color _riskColor(String level) {
    switch (level) {
      case "High":
        return Colors.red;
      case "Moderate":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("AI Analysis")),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("AI Health Analysis")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔴 Risk Level
            Card(
              color: _riskColor(result!['riskLevel']),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Overall Risk: ${result!['riskLevel']}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🩺 Diseases
            const Text("Detected Health Risks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(
              result!['diseases'].length,
              (i) => ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(result!['diseases'][i]),
              ),
            ),

            const SizedBox(height: 20),

            // 🧠 Explainability
            const Text("Why this result?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(
              result!['explanations'].length,
              (i) => ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(result!['explanations'][i]),
              ),
            ),

            const SizedBox(height: 20),

            // 💡 Suggestions
            const Text("AI Health Suggestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(
              result!['suggestions'].length,
              (i) => ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(result!['suggestions'][i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
