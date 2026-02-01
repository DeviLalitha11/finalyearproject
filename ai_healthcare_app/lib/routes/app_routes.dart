import 'package:flutter/material.dart';
import '../screens/auth/home_page.dart';
// import '../screens/auth/signin_screen.dart';
import '../screens/auth/create_acct.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/health_profile.dart';
import '../screens/auth/security_setup_page.dart';
import '../screens/dashboard/dashboard_page.dart';
import '../screens/ai/ai_analysis_page.dart';
import '../screens/health_entry/health_entry_step1.dart';
import '../screens/health_entry/health_entry_step2.dart';
import '../screens/health_entry/health_entry_step3.dart';
import '../screens/profile/profile_page.dart';
import '../screens/profile/change_password_page.dart';
import '../screens/profile/edit_profile_page.dart';
import '../screens/records/medical_records_page.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/auth/auth_home.dart';
import '../screens/ai_analysis/ai_result_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String signin = '/signin';
  static const String createAccount = '/create-account';
  static const String login = '/login';
  static const String healthProfile = '/health-profile';
  static const String securitySetup = '/security-setup';
  static const String dashboard = '/dashboard';
  static const String aiAnalysis = '/ai-analysis';
  static const String healthEntry = '/health-entry';
  static const String healthEntryStep2 = '/health-entry-step2';
  static const String healthEntryStep3 = '/health-entry-step3';
  static const String profile = '/profile';
  static const String records = '/records';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String editProfile = '/edit-profile';
  static const String authHome = '/auth-home';
  static const String aiResult = '/ai-result';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomePage(),
        // signin: (context) => const SignInPage(),
        createAccount: (context) => const CreateAccountPage(),
        login: (context) => const LoginPage(),
        healthProfile: (context) => const HealthProfilePage(),
        securitySetup: (context) => const SecuritySetupPage(),
        dashboard: (context) => const DashboardPage(),
        aiAnalysis: (context) => const AIAnalysisPage(),
        // healthEntry: (context) => const HealthEntryStep1(),
        // healthEntryStep2: (context) => const HealthEntryStep2(),
        // healthEntryStep3: (context) => const HealthEntryStep3(),
        profile: (context) => const ProfilePage(),
        records: (context) => const MedicalRecordsPage(),
        settings: (context) => const SettingsScreen(),
        changePassword: (context) => const ChangePasswordPage(),
        editProfile: (context) => const EditProfilePage(),
        aiResult: (context) => const AIResultPage(),
        authHome: (context) => const AuthHomePage(), // ✅ FIXED
      };

      static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case healthEntry:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => HealthEntryStep1(existingData: args),
        );

      case healthEntryStep2:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => HealthEntryStep2(existingData: args),
        );

      case healthEntryStep3:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => HealthEntryStep3(existingData: args),
        );

      default:
        return null;
    }
  }
}
