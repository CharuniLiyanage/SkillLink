import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';
import '../../widgets/info_tile.dart';

import '../provider/provider_dashboard_screen.dart';

//==================== Become Provider Screen ====================

class BecomeProviderScreen extends StatefulWidget {
  const BecomeProviderScreen({super.key});

  @override
  State<BecomeProviderScreen> createState() =>
      _BecomeProviderScreenState();
}

class _BecomeProviderScreenState
    extends State<BecomeProviderScreen> {

  bool isLoading = false;

  // ==================== Become Provider ====================

  Future<void> becomeProvider() async {
    final email = Session.email;

    // Check login session
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );
      return;
    }

    // Already a provider
    if (Session.roles.contains('PROVIDER')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ProviderDashboardScreen(),
        ),
      );

      return;
    }

    // Start loading
    setState(() {
      isLoading = true;
    });

    // Call backend API
    final success = await ApiService.addRole(
      email: email,
      role: 'PROVIDER',
    );

    if (!mounted) return;

    // Stop loading
    setState(() {
      isLoading = false;
    });

    // ==================== Success ====================

    if (success) {
      // Add provider role to current session
      Session.roles.add('PROVIDER');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are now a Service Provider!',
          ),
        ),
      );

      // Go to Provider Dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ProviderDashboardScreen(),
        ),
      );
    }

    // ==================== Failed ====================

    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not become a Service Provider.',
          ),
        ),
      );
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Become a Service Provider',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ==================== Icon ====================

            Container(
              width: 100,
              height: 100,

              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.handyman_rounded,
                size: 52,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            // ==================== Title ====================

            const Text(
              'Start Offering Your Skills',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            // ==================== Description ====================

            const Text(
              'Become a SkillLink service provider and connect with customers who need your skills.',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 30),

            // ==================== Info 1 ====================

            InfoTile(
              icon: Icons.people_alt_rounded,
              title: 'Reach Customers',
              subtitle:
                  'Connect with people looking for your services.',
            ),

            // ==================== Info 2 ====================

            InfoTile(
              icon: Icons.work_rounded,
              title: 'Show Your Skills',
              subtitle:
                  'Create your provider profile and list your services.',
              iconColor: AppColors.secondary,
            ),

            // ==================== Info 3 ====================

            InfoTile(
              icon: Icons.trending_up_rounded,
              title: 'Grow Your Business',
              subtitle:
                  'Receive service requests through SkillLink.',
              iconColor: AppColors.success,
            ),

            const SizedBox(height: 14),

            // ==================== Button ====================

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : becomeProvider,

                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.handyman_rounded,
                      ),

                label: Text(
                  isLoading
                      ? 'Becoming a Provider...'
                      : 'Become a Service Provider',

                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}