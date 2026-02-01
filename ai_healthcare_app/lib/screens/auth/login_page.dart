// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../services/auth_service.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool obscure = true;
//   bool _loading = false;

//   void _signInWithEmail() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _loading = true);
//       try {
//         final authService = Provider.of<AuthService>(context, listen: false);
//         await authService
//             .signInWithEmailAndPassword(
//               emailController.text.trim(),
//               passwordController.text,
//             )
//             .timeout(
//               const Duration(seconds: 15),
//               onTimeout: () {
//                 throw Exception(
//                   'Sign-in timed out. Check your connection and try again.',
//                 );
//               },
//             );

//         if (mounted) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/dashboard',
//             (route) => false,
//           );
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(e.toString())));
//         }
//       } finally {
//         if (mounted) setState(() => _loading = false);
//       }
//     }
//   }

//   void _signInWithGoogle() async {
//     try {
//       final authService = Provider.of<AuthService>(context, listen: false);
//       await authService.signInWithGoogle();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Successfully signed in with Google!')),
//         );

//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/dashboard',
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
//       }
//     }
//   }

//   void _signInWithApple() async {
//     try {
//       final authService = Provider.of<AuthService>(context, listen: false);
//       await authService.signInWithApple();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Successfully signed in with Apple!')),
//         );

//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/dashboard',
//           (route) => false,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Apple Sign-In failed: $e')));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF0F2E2E), Color(0xFF071A1A)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),

//                 // Top Icons
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Icon(
//                       Icons.medical_services,
//                       size: 42,
//                       color: Color(0xFF10B981),
//                     ),
//                     Icon(
//                       Icons.health_and_safety,
//                       size: 34,
//                       color: Color(0xFF10B981),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 30),

//                 // Welcome Text
//                 const Text(
//                   'Welcome Back',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 const Text(
//                   'Sign in to access your health dashboard',
//                   style: TextStyle(color: Colors.white70),
//                 ),

//                 const SizedBox(height: 40),

//                 // Card
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.08),
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Email or Phone',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         const SizedBox(height: 8),

//                         _inputField(
//                           controller: emailController,
//                           hint: 'Enter your email or phone',
//                           icon: Icons.email_outlined,
//                           validator: (v) => v!.isEmpty ? 'Required' : null,
//                         ),

//                         const SizedBox(height: 20),

//                         const Text(
//                           'Password',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         const SizedBox(height: 8),

//                         _inputField(
//                           controller: passwordController,
//                           hint: 'Enter your password',
//                           icon: Icons.lock_outline,
//                           obscure: obscure,
//                           suffix: IconButton(
//                             icon: Icon(
//                               obscure ? Icons.visibility_off : Icons.visibility,
//                               color: Colors.white54,
//                             ),
//                             onPressed: () => setState(() => obscure = !obscure),
//                           ),
//                           validator: (v) =>
//                               v!.length < 6 ? 'Min 6 characters' : null,
//                         ),

//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {},
//                             child: const Text(
//                               'Forgot Password?',
//                               style: TextStyle(color: Color(0xFF10B981)),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 10),

//                         // Sign In Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: 54,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF10B981),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ),
//                             onPressed: _loading ? null : _signInWithEmail,
//                             child: _loading
//                                 ? const SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2.5,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 : const Text(
//                                     'Sign In  →',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         const Row(
//                           children: [
//                             Expanded(child: Divider(color: Colors.white24)),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8),
//                               child: Text(
//                                 'or continue with',
//                                 style: TextStyle(color: Colors.white54),
//                               ),
//                             ),
//                             Expanded(child: Divider(color: Colors.white24)),
//                           ],
//                         ),

//                         const SizedBox(height: 20),

//                         // Social Buttons
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _socialButton(
//                                 'Google',
//                                 Icons.g_mobiledata,
//                                 () => _signInWithGoogle(),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: _socialButton(
//                                 'Apple',
//                                 Icons.apple,
//                                 () => _signInWithApple(),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 24),

//                         GestureDetector(
//                           onTap: () =>
//                               Navigator.pushNamed(context, '/create-account'),
//                           child: const Center(
//                             child: Text.rich(
//                               TextSpan(
//                                 text: "Don't have an account? ",
//                                 style: TextStyle(color: Colors.white54),
//                                 children: [
//                                   TextSpan(
//                                     text: 'Sign Up',
//                                     style: TextStyle(
//                                       color: Color(0xFF10B981),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 12),

//                         GestureDetector(
//                           onTap: () => Navigator.pushNamedAndRemoveUntil(
//                             context,
//                             '/home',
//                             (route) => false,
//                           ),
//                           child: const Center(
//                             child: Text(
//                               '← Back to Home',
//                               style: TextStyle(
//                                 color: Color(0xFF10B981),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _inputField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     bool obscure = false,
//     Widget? suffix,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       validator: validator,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.white54),
//         suffixIcon: suffix,
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.white38),
//         filled: true,
//         fillColor: Colors.white.withValues(alpha: 0.12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   Widget _socialButton(String text, IconData icon, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: 48,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.white24),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white),
//             const SizedBox(width: 8),
//             Text(text, style: const TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();


  bool obscure = true;
  bool _loading = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }


  void showToast(String message, {bool success = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: success ? const Color(0xFF10B981) : Colors.redAccent,
      textColor: Colors.white,
      fontSize: 15,
    );
  }


void _signInWithEmail() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _loading = true);

  try {
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService
        .signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception("timeout");
          },
        );

    showToast("Login successful ✅", success: true);

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      });
    }
  }
  on FirebaseAuthException catch (e) {
    // 🔥 REAL firebase errors
    String message;

    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email';
        break;
      case 'wrong-password':
        message = 'Incorrect password';
        break;
      case 'invalid-email':
        message = 'Invalid email format';
        break;
      case 'user-disabled':
        message = 'This account is disabled';
        break;
      default:
        message = e.message ?? 'Authentication failed';
    }

    showToast(message);
  }
  catch (e) {
    // 🔥 Other errors (timeout, network, etc.)
    showToast('Login failed. Check internet connection');
  }
  finally {
    if (mounted) setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2E2E), Color(0xFF071A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Top Icons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.medical_services, size: 42, color: Color(0xFF10B981)),
                    Icon(Icons.health_and_safety, size: 34, color: Color(0xFF10B981)),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to access your health dashboard',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 40),
                // Form Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email or Phone', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),
                        _inputField(
                          controller: emailController,
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          focusNode: emailFocus,
                          nextFocus: passwordFocus,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v!.isEmpty ? 'Email is required' : null,
                        ),
                        const SizedBox(height: 20),
                        const Text('Password', style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),
                        _inputField(
                          controller: passwordController,
                          hint: 'Enter your password',
                          icon: Icons.lock_outline,
                          focusNode: passwordFocus,
                          obscure: obscure,
                          suffix: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () => setState(() => obscure = !obscure),
                          ),
                          validator: (v) => v!.length < 6 ? 'Minimum 6 characters' : null,
                        ),
                        const SizedBox(height: 30), // Spacing before button
                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _loading ? null : _signInWithEmail,
                            child: _loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Sign In  →',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Navigation Links
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/create-account'),
                          child: const Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: Colors.white54),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          ),
                          child: const Center(
                            child: Text(
                              '← Back to Home',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          _signInWithEmail(); // Trigger sign in on 'Done'
        }
      },
      cursorColor: const Color(0xFF10B981),
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white54),
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
