import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../routes/app_routes.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(DateFormat('HH:mm:ss').format(_now),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        Text(DateFormat('EEEE, dd MMM yyyy').format(_now),
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  String getHealthStatus(Map<String, dynamic> data) {
    final bp = data['bloodPressure'] ?? {};
    final sys = bp['systolic'] ?? 0;
    final dia = bp['diastolic'] ?? 0;
    final oxygen = data['oxygen'] ?? 0;
    final sugar = data['bloodSugar'] ?? 0;

    if (sys >= 140 || dia >= 90 || oxygen < 92) {
      return "Take Care";
    }

    if (sys >= 130 || dia >= 85 || sugar > 140) {
      return "Need To Caution";
    }

    if (sys >= 120) {
      return "Good";
    }

    return "Normal";
  }

  void _showRecordDetails(BuildContext context, Map<String, dynamic> data, String dateStr) {
    final bp = data['bloodPressure'] ?? {};
    final symptoms = data['symptoms'] as List<dynamic>? ?? [];
    
    // Get AI advice - could be a string or list
    final aiAdviceData = data['aiAdvice'];
    String aiAdvice;
    
    if (aiAdviceData is List) {
      // If it's a list of suggestions, join them
      aiAdvice = (aiAdviceData as List).map((s) => "• $s").join("\n");
      if (aiAdvice.isEmpty) {
        aiAdvice = 'No AI advice available for this record.';
      }
    } else if (aiAdviceData is String) {
      aiAdvice = aiAdviceData;
    } else {
      aiAdvice = 'No AI advice available for this record.';
    }
    
    final status = getHealthStatus(data);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Health Record Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: $dateStr',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Health Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: status == "Normal"
                              ? Colors.green.withOpacity(0.1)
                              : status == "Good"
                                  ? Colors.blue.withOpacity(0.1)
                                  : status == "Need To Caution"
                                      ? Colors.orange.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: status == "Normal"
                                ? Colors.green
                                : status == "Good"
                                    ? Colors.blue
                                    : status == "Need To Caution"
                                        ? Colors.orange
                                        : Colors.red,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == "Normal" || status == "Good"
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: status == "Normal"
                                  ? Colors.green
                                  : status == "Good"
                                      ? Colors.blue
                                      : status == "Need To Caution"
                                          ? Colors.orange
                                          : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Status: $status',
                              style: TextStyle(
                                color: status == "Normal"
                                    ? Colors.green
                                    : status == "Good"
                                        ? Colors.blue
                                        : status == "Need To Caution"
                                            ? Colors.orange
                                            : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Vital Signs
                      _buildSectionTitle('Vital Signs'),
                      const SizedBox(height: 12),
                      _buildVitalCard('Blood Pressure', '${bp['systolic'] ?? '--'}/${bp['diastolic'] ?? '--'} mmHg', Icons.favorite),
                      _buildVitalCard('Oxygen Level', '${data['oxygen'] ?? '--'}%', Icons.air),
                      _buildVitalCard('Blood Sugar', '${data['bloodSugar'] ?? '--'} mg/dL', Icons.bloodtype),
                      _buildVitalCard('Sugar Level', data['sugarLevel'] ?? 'N/A', Icons.water_drop),

                      const SizedBox(height: 20),

                      // Symptoms Section
                      _buildSectionTitle('Symptoms'),
                      const SizedBox(height: 12),
                      if (symptoms.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.grey),
                              SizedBox(width: 12),
                              Text(
                                'No symptoms recorded',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: symptoms.map((symptom) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle, size: 8, color: Color(0xFF10B981)),
                                  const SizedBox(width: 8),
                                  Text(
                                    symptom.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF065F46),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 20),

                      // AI Advice Section
                      _buildSectionTitle('AI Advice'),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF10B981).withOpacity(0.1),
                              const Color(0xFF34D399).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.smart_toy, color: Color(0xFF10B981)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                aiAdvice,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _buildVitalCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF10B981), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4FBF9), Color(0xFFF7F9FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- HEADER SECTION ---
              _buildHeader(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- USER & TIME INFO ---
                      _buildUserTimeInfo(user),

                      const SizedBox(height: 24),

                      // --- DATA TABLE SECTION ---
                      const Text(
                        'Daily Health Logs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRecordsTable(user),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Medical Records',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Icon(Icons.person, color: Color(0xFF16B38A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTimeInfo(User? user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String name = 'User';
        String phone = '';
        String bloodGroup = 'Not Set';

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;

          name = userData['name'] ?? 'User';
          phone = userData['phone'] ?? '';
          final healthData = userData['healthData'] as Map<String, dynamic>?;
          bloodGroup = healthData?['bloodGroup'] ?? 'Not set';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF16B38A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16B38A).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT SIDE USER INFO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "📞 $phone",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    "🩸 Blood Group: $bloodGroup",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),

              // RIGHT SIDE CLOCK
              const LiveClock(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordsTable(User? user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .collection('health_history')
                .orderBy('updatedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              return DataTable(
                headingRowColor:
                    MaterialStateProperty.all(const Color(0xFFF3F4F6)),
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('BP (Sys/Dia)')),
                  DataColumn(label: Text('Oxygen')),
                  DataColumn(label: Text('Glucose')),
                  DataColumn(label: Text('Sugar')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final bp = data['bloodPressure'] ?? {};
                  final timestamp = data['updatedAt'] as Timestamp?;
                  final dateStr = timestamp != null
                      ? DateFormat('dd/MM/yy').format(timestamp.toDate())
                      : '-';
                  final status = getHealthStatus(data);
                  return DataRow(
                    onSelectChanged: (_) => _showRecordDetails(context, data, dateStr),
                    cells: [
                      DataCell(Text(dateStr)),
                      DataCell(
                        Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: status == "Normal"
                                ? Colors.green
                                : status == "Good"
                                    ? Colors.blue
                                    : status == "Need To Caution"
                                        ? Colors.orange
                                        : Colors.red,
                          ),
                        ),
                      ),
                      DataCell(Text(
                          '${bp['systolic'] ?? '--'}/${bp['diastolic'] ?? '--'}')),
                      DataCell(Text('${data['oxygen'] ?? '--'}%')),
                      DataCell(Text('${data['bloodSugar'] ?? '--'}')),
                      DataCell(Text(data['sugarLevel'] ?? 'N/A')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, color: Color(0xFF16B38A), size: 20),
                            onPressed: () => _showRecordDetails(context, data, dateStr),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text("Delete Record"),
                                  content: const Text(
                                      "Are you sure you want to delete this record?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text("Delete", style: TextStyle(color: Colors.red))),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await doc.reference.delete();
                              }
                            },
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3, // Medical Records is active
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF16B38A),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushNamed(context, '/health-entry');
            break;
          case 2:
            Navigator.pushNamed(context, '/ai-result');
            break;
          case 3:
            break; // Already here
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle), label: 'Add Data'),
        BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy), label: 'AI Analysis'),
        BottomNavigationBarItem(
            icon: Icon(Icons.description), label: 'Records'),
      ],
    );
  }
}