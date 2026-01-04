import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3FBF8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Smart Health',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signin');
            },
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Color(0xFF1AB394),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF3FBF8),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1AB394).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Color(0xFF1AB394),
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'AI-Powered Healthcare',
                            style: TextStyle(
                              color: Color(0xFF1AB394),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Main Heading
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Smart Health.\n',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          TextSpan(
                            text: 'Smarter Decisions.',
                            style: TextStyle(
                              color: Color(0xFF1AB394),
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: const Text(
                        'Your personal health companion powered by AI.\n'
                        'Track, predict, and manage your wellness journey\n'
                        'with confidence.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),

                // Primary Actions
                Column(
                  children: [
                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create-account');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1AB394),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started Free',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // I have an account button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF1AB394),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'I have an account',
                          style: TextStyle(
                            color: Color(0xFF1AB394),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 64),

                // Key Features Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Features',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildFeatureCard(
                          icon: Icons.monitor_heart,
                          title: 'Track Vitals',
                          subtitle:
                              'Monitor BP, heart rate, sugar levels and more in real-time',
                        ),
                        _buildFeatureCard(
                          icon: Icons.psychology,
                          title: 'AI Predictions',
                          subtitle:
                              'Get early disease predictions powered by advanced AI',
                        ),
                        _buildFeatureCard(
                          icon: Icons.description,
                          title: 'Health Reports',
                          subtitle:
                              'Access your complete medical history anytime',
                        ),
                        _buildFeatureCard(
                          icon: Icons.security,
                          title: 'Secure Data',
                          subtitle:
                              'Your health data is encrypted and protected',
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Why Choose MediCare+ Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1AB394), Color(0xFF34D399)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why Choose MediCare+?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildBulletPoint(
                        icon: Icons.access_time,
                        text: '24/7 Health Monitoring',
                      ),
                      const SizedBox(height: 12),
                      _buildBulletPoint(
                        icon: Icons.medical_services,
                        text: 'Doctor Consultations',
                      ),
                      const SizedBox(height: 12),
                      _buildBulletPoint(
                        icon: Icons.warning,
                        text: 'Emergency Alerts',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('10K+', 'Active Users'),
                    _buildStatItem('99%', 'Accuracy'),
                    _buildStatItem('24/7', 'Support'),
                  ],
                ),

                const SizedBox(height: 64),

                // Footer
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1AB394), Color(0xFF34D399)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'MediCare+',
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Privacy',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6B7280),
                            shape: BoxShape.circle,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Terms',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF6B7280),
                            shape: BoxShape.circle,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Contact',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      '© 2024 MediCare+. All rights reserved.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1AB394).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1AB394), size: 24),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
