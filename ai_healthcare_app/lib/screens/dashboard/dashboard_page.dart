// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../health_entry/health_entry_step1.dart';

// import '../profile/profile_page.dart';
// import '../../routes/app_routes.dart';
// import '../../services/health_validation_service.dart';
// import '../../utils/dialogs.dart';
// import '../../services/ai_analysis_service.dart';
// import '../ai_analysis/ai_result_page.dart';

// class DashboardPage extends StatefulWidget {
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   Future<bool> _isDataSharingEnabled() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('dataSharing') ?? false;
//   }

//   void _navigateToAIAnalysis() async {
//     final enabled = await _isDataSharingEnabled();
//     if (!enabled) {
//       _showDataSharingRequiredDialog();
//       return;
//     }

//     final hasHealthData = await HealthValidationService.hasRequiredHealthData();

//     if (!hasHealthData) {
//       showHealthDataMissingDialog(context);
//       return;
//     }

//     try {
//       // 🔄 Show loading
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const Center(child: CircularProgressIndicator()),
//       );

//       // 🤖 Run AI analysis
//       final results = await AIAnalysisService.runAnalysis();

//       // ❌ Close loading
//       Navigator.pop(context);

//       // ✅ Navigate with results
//       if (mounted) {
//         Navigator.pushNamed(
//           context,
//           AppRoutes.aiResult,
//           arguments: results,
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       _showErrorDialog(e.toString());
//     }
//   }

//   void _navigateToReports() async {
//     final enabled = await _isDataSharingEnabled();
//     if (enabled && mounted) {
//       Navigator.pushNamed(context, AppRoutes.records);
//     } else {
//       _showDataSharingRequiredDialog();
//     }
//   }

//   void _showDataSharingRequiredDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Data Sharing Required'),
//         content: const Text(
//           'Enable Data Sharing in Profile settings to access this feature.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, AppRoutes.profile);
//             },
//             child: const Text('Go to Profile'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('AI Analysis Failed'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ------------------ HEALTH SCORE LOGIC ------------------

//   int _calculateHealthScore(Map<String, dynamic> health) {
//     int score = 100;

//     final hr = health['heartRate'];
//     final sugar = health['bloodSugar'];

//     if (hr != null && (hr < 60 || hr > 100)) score -= 15;
//     if (sugar != null && sugar > 140) score -= 20;

//     return score.clamp(0, 100);
//   }

//   Color _scoreColor(int score) {
//     if (score >= 75) return Colors.green;
//     if (score >= 50) return Colors.orange;
//     return Colors.red;
//   }

//   String _scoreText(int score) {
//     if (score >= 75) return "Good";
//     if (score >= 50) return "Moderate";
//     return "High Risk";
//   }

//   /// -------------------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text('User not logged in')),
//       );
//     }

//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final data = snapshot.data!.data() as Map<String, dynamic>;
//         final health = data['healthData'] ?? {};
//         final lastUpdated = health['updatedAt'] as Timestamp?;
//         final hasHealthData = health.isNotEmpty;

//         final score = _calculateHealthScore(health);

//         return Scaffold(
//           backgroundColor: const Color(0xFF020617),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// ---------------- HEADER ----------------
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Welcome back,",
//                               style: TextStyle(color: Colors.grey)),
//                           Text(
//                             data['name'] ??
//                                 user.email?.split('@').first ??
//                                 'User',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.settings, color: Colors.white),
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const ProfilePage(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   /// ---------------- HEALTH SCORE ----------------
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1E293B),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 36,
//                           backgroundColor: _scoreColor(score),
//                           child: Text(
//                             "$score",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Health Score",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               _scoreText(score),
//                               style: TextStyle(
//                                 color: _scoreColor(score),
//                               ),
//                             ),
//                             if (lastUpdated != null)
//                               Text(
//                                 "Last updated: ${DateTime.now().difference(lastUpdated.toDate()).inDays} days ago",
//                                 style: const TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   /// ---------------- HEALTH DATA ----------------
//                   hasHealthData
//                       ? GridView.count(
//                           crossAxisCount: 2,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                           children: [
//                             if (health['heartRate'] != null)
//                               _metricCard(
//                                   "Heart Rate",
//                                   "${health['heartRate']} bpm",
//                                   Icons.favorite,
//                                   Colors.red),
//                             if (health['bloodPressure'] != null)
//                               _metricCard(
//                                 "Blood Pressure",
//                                 "${health['bloodPressure']['systolic']}/${health['bloodPressure']['diastolic']} mmHg",
//                                 Icons.monitor_heart,
//                                 Colors.cyan,
//                               ),
//                             if (health['bloodSugar'] != null)
//                               _metricCard(
//                                   "Blood Sugar",
//                                   "${health['bloodSugar']} mg/dL",
//                                   Icons.water_drop,
//                                   Colors.amber),
//                             if (health['bmi'] != null)
//                               _metricCard("BMI", health['bmi'].toString(),
//                                   Icons.accessibility, Colors.green),
//                           ],
//                         )
//                       : _addHealthCard(context, health),

//                   const SizedBox(height: 24),

//                   /// ---------------- QUICK ACTIONS ----------------
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _action(
//                           "Add Data",
//                           Icons.add,
//                           const Color(0xFF10B981),
//                           () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => HealthEntryStep1(
//                                   existingData: health,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _action(
//                           "AI Analysis",
//                           Icons.analytics,
//                           Colors.grey,
//                           _navigateToAIAnalysis,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _action(
//                           "Reports",
//                           Icons.description,
//                           const Color(0xFF374151),
//                           _navigateToReports,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   /// ---------------- REMINDER ----------------
//                   if (!hasHealthData)
//                     _reminderCard(
//                         "Add your first health record to unlock insights"),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// ---------------- UI HELPERS ----------------

//   Widget _metricCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E293B),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color),
//           const SizedBox(height: 8),
//           Text(value,
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//           Text(title, style: const TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   Widget _addHealthCard(
//     BuildContext context,
//     Map<String, dynamic> health,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HealthEntryStep1(
//               existingData: health, // ✅ edit support
//             ),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E293B),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.green),
//         ),
//         child: Column(
//           children: const [
//             Icon(Icons.add_circle_outline, size: 48, color: Colors.green),
//             SizedBox(height: 16),
//             Text(
//               "Add Your First Health Record",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _action(String label, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color),
//             const SizedBox(height: 8),
//             Text(label, style: const TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _reminderCard(String text) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.orange.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: const [
//           Icon(Icons.notifications, color: Colors.orange),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               "Don’t forget to update your health data today!",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Ensure these paths match your project structure
import '../health_entry/health_entry_step1.dart';
import '../profile/profile_page.dart';
import '../../routes/app_routes.dart';
import '../../services/health_validation_service.dart';
import '../../services/ai_analysis_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  // ❤️ Heart animation
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  // 🧠 Daily tips
  final List<String> _dailyTips = [
    "💧 Drink at least 8 glasses of water today.",
    "🚶 Take a 20-minute walk to boost heart health.",
    "🥗 Include more vegetables in your meals.",
    "😴 Get at least 7–8 hours of sleep tonight.",
    "🧂 Reduce salt intake to control blood pressure.",
    "🍎 Eat a fruit instead of sugary snacks today.",
    "🧘 Practice deep breathing for 5 minutes.",
    "☀️ Get some sunlight for Vitamin D.",
    "🚫 Avoid junk food today for better digestion.",
    "❤️ Monitor your heart rate regularly.",
  ];

  String _todayTip = "";

  @override
  void initState() {
    super.initState();
    _loadDailyTip();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _heartAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _heartController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  // ---------------- Logic Methods ----------------

  Future<void> _loadDailyTip() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString("tip_date");

    if (savedDate != today) {
      final randomTip = (List.from(_dailyTips)..shuffle()).first;
      await prefs.setString("daily_tip", randomTip);
      await prefs.setString("tip_date", today);
      setState(() {
        _todayTip = randomTip;
      });
    } else {
      setState(() {
        _todayTip = prefs.getString("daily_tip") ?? _dailyTips.first;
      });
    }
  }

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
      // Assuming showHealthDataMissingDialog is defined in your utils/dialogs.dart
      _showErrorDialog(
          "Please add your health data before running AI analysis.");
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final results = await AIAnalysisService.runAnalysis();
      if (!mounted) return;
      Navigator.pop(context); // Close loading

      Navigator.pushNamed(
        context,
        AppRoutes.aiResult,
        arguments: results,
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
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
            'Enable Data Sharing in Profile settings to access this feature.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
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
        title: const Text('Notice'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

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

  // ---------------- UI Build ----------------

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    user?.reload();

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final health = data['healthData'] as Map<String, dynamic>? ?? {};
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
                  _buildHeader(data, user),
                  const SizedBox(height: 24),
                  _buildScoreCard(score, lastUpdated),
                  const SizedBox(height: 24),
                  hasHealthData
                      ? _buildMetricsGrid(health)
                      : _addHealthCard(context, health),
                  _dailyTipCard(),
                  _aiInsightCard(),
                  const SizedBox(height: 12),
                  _buildQuickActions(health),
                  if (!hasHealthData) const SizedBox(height: 24),
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

  // ---------------- UI Sub-Widgets ----------------

  Widget _buildHeader(Map<String, dynamic> data, User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back,", style: TextStyle(color: Colors.grey)),
            Text(
              data['name'] ??
                  data['profile']?['name'] ??
                  data['healthProfile']?['name'] ??
                  user.displayName ??
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
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ProfilePage())),
        ),
      ],
    );
  }

  Widget _buildScoreCard(int score, Timestamp? lastUpdated) {
    String timeAgo = "";
    if (lastUpdated != null) {
      final days = DateTime.now().difference(lastUpdated.toDate()).inDays;
      timeAgo = "Updated ${days == 0 ? 'Today' : '$days days ago'}";
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _scoreColor(score).withOpacity(0.35),
            const Color(0xFF0F172A)
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(_scoreColor(score)),
                ),
              ),
              ScaleTransition(
                scale: _heartAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: _scoreColor(score), size: 24),
                    Text("$score",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Overall Health",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(_scoreText(score),
                    style: TextStyle(color: _scoreColor(score), fontSize: 16)),
                const Text("AI evaluated from your vitals",
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                if (timeAgo.isNotEmpty)
                  Text(timeAgo,
                      style:
                          const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Map<String, dynamic> health) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        if (health['heartRate'] != null)
          _metricCard("Heart Rate", "${health['heartRate']} bpm",
              Icons.favorite, Colors.red),
        if (health['bloodPressure'] != null)
          _metricCard(
            "Blood Pressure",
            "${health['bloodPressure']['systolic']}/${health['bloodPressure']['diastolic']}",
            Icons.monitor_heart,
            Colors.cyan,
          ),
        if (health['bloodSugar'] != null)
          _metricCard("Blood Sugar", "${health['bloodSugar']} mg/dL",
              Icons.water_drop, Colors.amber),
        if (health['bmi'] != null)
          _metricCard("BMI", health['bmi'].toString(), Icons.accessibility,
              Colors.green),
      ],
    );
  }

  Widget _buildQuickActions(Map<String, dynamic> health) {
    return Row(
      children: [
        Expanded(
          child: _action(
            "Add Data",
            Icons.add,
            const Color(0xFF10B981),
            () => Navigator.pushNamed(
              context,
              AppRoutes.healthEntry,
              arguments: health, // ✅ prefill data
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: _action("AI Analysis", Icons.analytics, Colors.blueAccent,
                _navigateToAIAnalysis)),
        const SizedBox(width: 12),
        Expanded(
            child: _action("Reports", Icons.description, Colors.blueGrey,
                _navigateToReports)),
      ],
    );
  }

  Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(color: Colors.white60, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _addHealthCard(BuildContext context, Map<String, dynamic> health) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => HealthEntryStep1(existingData: health))),
      child: Container(
        width: double.infinity,
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
            Text("Add Your First Health Record",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _dailyTipCard() {
    if (_todayTip.isEmpty) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
              child: Text(_todayTip,
                  style: const TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _aiInsightCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.psychology, color: Colors.white, size: 34),
          SizedBox(width: 16),
          Expanded(
              child: Text(
                  "AI can analyze your health trends and predict risks early.",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15))),
        ],
      ),
    );
  }

  Widget _action(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
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
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
