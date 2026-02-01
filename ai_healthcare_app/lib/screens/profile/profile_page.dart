// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../routes/app_routes.dart';
// import '../../services/auth_service.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool _pushNotifications = true;
//   bool _healthReminders = true;
//   bool _dataSharing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//   }

//   Future<void> _loadPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _pushNotifications = prefs.getBool('pushNotifications') ?? true;
//       _healthReminders = prefs.getBool('healthReminders') ?? true;
//       _dataSharing = prefs.getBool('dataSharing') ?? false;
//     });
//   }

//   Future<bool> _isDataSharingEnabled() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('dataSharing') ?? false;
//   }

//   void _navigateToAIAnalysis() async {
//     final enabled = await _isDataSharingEnabled();
//     if (enabled && mounted) {
//       Navigator.pushNamed(context, '/ai-analysis');
//     } else if (mounted) {
//       _showDataSharingRequiredDialog();
//     }
//   }

//   void _navigateToReports() async {
//     final enabled = await _isDataSharingEnabled();
//     if (enabled && mounted) {
//       Navigator.pushNamed(context, '/records');
//     } else if (mounted) {
//       _showDataSharingRequiredDialog();
//     }
//   }

//   void _showDataSharingRequiredDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Data Sharing Required'),
//         content: const Text(
//           'Enable Data Sharing in Profile settings to access this feature.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Already on profile page
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _updatePreference(String key, bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(key, value);
//   }

//   @override
//   Widget build(BuildContext context) {
//   final user = FirebaseAuth.instance.currentUser;

//   if (user == null) {
//     return const Scaffold(
//       body: Center(child: Text('User not logged in')),
//     );
//   }

//   return StreamBuilder<DocumentSnapshot>(
//     stream: FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         );
//       }

//       if (!snapshot.hasData || !snapshot.data!.exists) {
//         return const Scaffold(
//           body: Center(child: Text('Profile data not found')),
//         );
//       }

//       final data = snapshot.data!.data() as Map<String, dynamic>;

//       // Debug: Print all available fields
//       print('Firebase data: $data');

//       // Extract user data following FirebaseService structure
//       final name =
//     data['name'] ??
//     FirebaseAuth.instance.currentUser?.displayName ??
//     'User';
//       final email = data['email'] ?? user.email ?? 'No email';
//       final phone = data['phone'] ?? 'Not provided';
//       final age = data['age']?.toString() ?? '-';
//       final gender = data['gender'] ?? 'Not provided';
      
//       // Extract bloodGroup from healthData object
//       final healthData = data['healthData'] as Map<String, dynamic>?;
//       final bloodGroup = healthData?['bloodGroup'] ?? 'Not provided';
      
//       // Other fields with fallbacks
//       final dateOfBirth = data['dob'] ?? data['dateOfBirth'] ?? 'Not provided';
//       final address = data['address'] ?? 'Not provided';
      
//       // Extract nested emergency contact data
//       final emergencyData = data['emergency'] as Map<String, dynamic>?;
//       final emergencyContactName = emergencyData?['name'] ?? 'Not provided';
//       final emergencyContactPhone = emergencyData?['phone'] ?? 'Not provided';
      
//       // Extract nested health info data
//       final healthInfoData = data['healthInfo'] as Map<String, dynamic>?;
//       final allergies = healthInfoData?['allergies'] ?? 'None';
//       final medicalConditions = healthInfoData?['conditions'] ?? 'None';
      
//       final membershipType = data['membershipType'] ?? 'Standard Member';

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFFF4FBF9), // Light green-tinted
//               Color(0xFFF7F9FC), // Light blue-tinted
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top Header
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.05),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back,
//                           color: Color(0xFF111827),
//                         ),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'My Profile',
//                             style: TextStyle(
//                               color: Color(0xFF111827),
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             'Manage your health identity',
//                             style: TextStyle(
//                               color: Color(0xFF6B7280),
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.05),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: const Icon(Icons.edit, color: Color(0xFF111827)),
//                         onPressed: () =>
//                             Navigator.pushNamed(context, AppRoutes.editProfile),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // Profile Summary Card
//                 Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shadowColor: Colors.black.withValues(alpha: 0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       children: [
//                         // Avatar with badge
//                         Stack(
//                           children: [
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     Color(0xFF16B38A),
//                                     Color(0xFF34D399),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Container(
//                                 width: 24,
//                                 height: 24,
//                                 decoration: const BoxDecoration(
//                                   color: Color(0xFF16B38A),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.check,
//                                   color: Colors.white,
//                                   size: 16,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         Text(
//                           name,
//                           style: const TextStyle(
//                             color: Color(0xFF111827),
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),

//                         const SizedBox(height: 4),

//                         Text(
//                           membershipType,
//                           style: const TextStyle(
//                             color: Color(0xFF6B7280),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         const Divider(color: Color(0xFFE5EDF5), height: 1),

//                         const SizedBox(height: 20),

//                         // Stats Row
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _buildStatItem(age, 'Years'),
//                             _buildStatItem(bloodGroup, 'Blood'),
//                             _buildStatItem(gender, 'Gender'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Personal Information Card
//                 Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shadowColor: Colors.black.withValues(alpha: 0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Personal Information',
//                           style: TextStyle(
//                             color: Color(0xFF111827),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildInfoItem(
//                           Icons.mail,
//                           'Email',
//                           email,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildInfoItem(Icons.phone, 'Phone', phone),
//                         const SizedBox(height: 12),
//                         _buildInfoItem(
//                           Icons.calendar_today,
//                           'Date of Birth',
//                           dateOfBirth,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildInfoItem(
//                           Icons.home,
//                           'Address',
//                           address,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildInfoItem(Icons.water_drop, 'Blood Group', bloodGroup),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Emergency Contact Card
//                 Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shadowColor: Colors.black.withValues(alpha: 0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Emergency Contact',
//                           style: TextStyle(
//                             color: Color(0xFF111827),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildInfoItem(Icons.person_add, 'Name', emergencyContactName),
//                         const SizedBox(height: 12),
//                         _buildInfoItem(
//                           Icons.phone_android,
//                           'Phone',
//                           emergencyContactPhone,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Health Information Card
//                 Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shadowColor: Colors.black.withValues(alpha: 0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Health Information',
//                           style: TextStyle(
//                             color: Color(0xFF111827),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildInfoItem(Icons.warning, 'Allergies', allergies),
//                         const SizedBox(height: 12),
//                         _buildInfoItem(
//                           Icons.medical_services,
//                           'Medical Conditions',
//                           medicalConditions,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Preferences Card
//                 Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shadowColor: Colors.black.withValues(alpha: 0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Preferences',
//                           style: TextStyle(
//                             color: Color(0xFF111827),
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         _buildToggleItem(
//                           'Push Notifications',
//                           'Receive alerts & updates',
//                           _pushNotifications,
//                           (value) {
//                             setState(() => _pushNotifications = value);
//                             _updatePreference('pushNotifications', value);
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         _buildToggleItem(
//                           'Health Reminders',
//                           'Daily check-in prompts',
//                           _healthReminders,
//                           (value) {
//                             setState(() => _healthReminders = value);
//                             _updatePreference('healthReminders', value);
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         _buildToggleItem(
//                           'Data Sharing',
//                           'Share with healthcare providers',
//                           _dataSharing,
//                           (value) {
//                             setState(() => _dataSharing = value);
//                             _updatePreference('dataSharing', value);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Account Actions Card
//                 Card(
//                   color: Colors.white,
//                   elevation: 4,
//                   shadowColor: Colors.black.withValues(alpha: 0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildActionItem(
//                         Icons.lock,
//                         'Change Password',
//                         const Color(0xFF111827),
//                         () =>
//                             Navigator.pushNamed(context, AppRoutes.changePassword),
//                       ),
//                       const Divider(color: Color(0xFFE5EDF5), height: 1),
//                       _buildActionItem(
//                         Icons.logout,
//                         'Log Out',
//                         const Color(0xFFEF4444),
//                         () async {
//                           // 1️⃣ Sign out from Firebase
//                           final authService = context.read<AuthService>();
//                           await authService.signOut();

//                           // 2️⃣ Navigate to home page
//                           Navigator.pushNamedAndRemoveUntil(
//                             context,
//                             AppRoutes.home,
//                             (route) => false,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 32),

//                 // Footer
//                 const Center(
//                   child: Text(
//                     'MediCare+ v1.0.0',
//                     style: TextStyle(
//                       color: Color(0xFF6B7280),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 4, // Profile is active
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: const Color(0xFF16B38A),
//         unselectedItemColor: const Color(0xFF6B7280),
//         elevation: 8,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle),
//             label: 'Add Data',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.description),
//             label: 'Reports',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, '/dashboard');
//               break;
//             case 1:
//               Navigator.pushNamed(context, '/health-entry');
//               break;
//             case 2:
//               _navigateToAIAnalysis();
//               break;
//             case 3:
//               _navigateToReports();
//               break;
//             case 4:
//               Navigator.pushNamed(context, '/profile');
//               break;
//           }
//         },
//       ),
//     );
//     },
//   );
//   }

//   Widget _buildStatItem(String value, String label) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Color(0xFF111827),
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Color(0xFF6B7280),
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoItem(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: const Color(0xFF16B38A).withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: const Color(0xFF16B38A), size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Color(0xFF6B7280),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   color: Color(0xFF111827),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildToggleItem(
//     String title,
//     String subtitle,
//     bool value,
//     Function(bool) onChanged,
//   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Color(0xFF111827),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: Color(0xFF6B7280),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Switch(
//           value: value,
//           onChanged: onChanged,
//           activeColor: const Color(0xFF16B38A),
//           activeTrackColor: const Color(0xFF16B38A).withValues(alpha: 0.3),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionItem(
//     IconData icon,
//     String title,
//     Color textColor,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(icon, color: textColor, size: 24),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   color: textColor,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Icon(Icons.chevron_right, color: textColor.withValues(alpha: 0.5)),
//           ],
//         ),
//       ),
//     );
//   }
// }

















import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _dataSharing = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dataSharing = prefs.getBool('dataSharing') ?? false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _navigateToAIAnalysis() {
    if (_dataSharing) {
      Navigator.pushNamed(context, AppRoutes.aiAnalysis);
    } else {
      _showDataSharingRequiredDialog();
    }
  }

  void _navigateToReports() {
    if (_dataSharing) {
      Navigator.pushNamed(context, AppRoutes.records);
    } else {
      _showDataSharingRequiredDialog();
    }
  }

  void _showDataSharingRequiredDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Data Sharing Required'),
        content: const Text(
          'Enable Data Sharing in Profile settings to access this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF16B38A))),
          ),
        ],
      ),
    );
  }

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
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final name =
            data['name'] ?? FirebaseAuth.instance.currentUser?.displayName ?? 'User';
        final email = data['email'] ?? user.email ?? '-';
        final phone = data['phone'] ?? '-';
        final age = data['age']?.toString() ?? '-';
        final gender = data['gender'] ?? '-';

        final healthData = data['healthData'] as Map<String, dynamic>?;
        final bloodGroup = healthData?['bloodGroup'] ?? '-';

        return Scaffold(
          backgroundColor: const Color(0xFFE8F5F1),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),
                  const SizedBox(height: 24),
                  _profileCard(name, age, bloodGroup, gender),
                  const SizedBox(height: 24),
                  _infoCard(
                    'Personal Information',
                    [
                      _infoRow(Icons.mail, 'Email', email),
                      _infoRow(Icons.phone, 'Phone', phone),
                      _infoRow(Icons.water_drop, 'Blood Group', bloodGroup),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _infoCard(
                    'Preferences',
                    [
                      _toggleRow(
                        'Data Sharing',
                        'Allow health data usage for AI & reports',
                        _dataSharing,
                        (v) {
                          setState(() => _dataSharing = v);
                          _updatePreference('dataSharing', v);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _accountActions(context),
                  const SizedBox(height: 32),
                  const Center(
                    child: Text(
                      'Smart Health v1.0.0',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _bottomNav(),
        );
      },
    );
  }

  // ================= UI SECTIONS =================

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF16B38A)),
          onPressed: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'My Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Color(0xFF16B38A)),
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
      ],
    );
  }

  Widget _profileCard(
      String name, String age, String blood, String gender) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 56),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat(age, 'Years'),
              _divider(),
              _stat(blood, 'Blood'),
              _divider(),
              _stat(gender, 'Gender'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _infoCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF10B981), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF10B981),
          activeTrackColor: const Color(0xFFD1FAE5),
        ),
      ],
    );
  }

  Widget _accountActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock, color: Color(0xFF10B981), size: 22),
            ),
            title: const Text(
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.changePassword),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 22),
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              await context.read<AuthService>().signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (i) {
          if (i == 2) _navigateToReports();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add Data'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}