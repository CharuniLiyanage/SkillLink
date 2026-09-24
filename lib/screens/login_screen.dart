import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/session.dart';
import 'choose_role_screen.dart';
import 'register_screen.dart';
import 'choose_role_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter email and password.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    final loginData = await ApiService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (loginData != null) {
      final String token =
          loginData['token'].toString();

      final List<dynamic> roles =
          loginData['roles'] as List<dynamic>;

      // SAVE LOGIN SESSION
      Session.email =
          emailController.text.trim();

      Session.roles = roles
          .map(
            (role) => role.toString(),
          )
          .toList();

      // SAVE EMAIL USING SHARED PREFERENCES
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'customerEmail',
        emailController.text.trim(),
      );

      // DEBUG
      print('TOKEN: $token');
      print('ROLES: $roles');
      print(
        'SESSION EMAIL: ${Session.email}',
      );
      print(
        'SESSION ROLES: ${Session.roles}',
      );
      print(
        'SAVED CUSTOMER EMAIL: '
        '${emailController.text.trim()}',
      );

      // CHOOSE ROLE
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseRoleScreen(
            name: '',
            email: emailController.text.trim(),
            password: '',
            phone: '',
            availableRoles: roles
                .map(
                  (role) => role.toString(),
                )
                .toList(),
            isLoginFlow: true,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email or password.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ICON
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Login to continue using SkillLink',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // EMAIL
            TextField(
              controller: emailController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // PASSWORD
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : login,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // REGISTER
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Register",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}