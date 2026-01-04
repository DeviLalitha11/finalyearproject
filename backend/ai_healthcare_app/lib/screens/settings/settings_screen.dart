import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../profile/profile_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                title: Text('Privacy Settings'),
                subtitle: Text('Manage data sharing'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Notifications'),
                subtitle: Text('Email and push preferences'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Change Password'),
                subtitle: Text('Update your password (UI only)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
