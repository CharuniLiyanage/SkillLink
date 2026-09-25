import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

import 'become_provider_screen.dart';
import '../../widgets/info_tile.dart';


//==================== Customer Profile Screen ====================

class CustomerProfileScreen
    extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person_rounded,
                size: 58,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Customer Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'customer@email.com',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            const InfoTile(
              icon: Icons.person_rounded,
              title: 'Full Name',
              subtitle: 'Customer Name',
            ),
            const InfoTile(
              icon: Icons.email_rounded,
              title: 'Email',
              subtitle: 'customer@email.com',
              iconColor: AppColors.secondary,
            ),
            const InfoTile(
              icon: Icons.phone_rounded,
              title: 'Phone Number',
              subtitle: '071 234 5678',
              iconColor: AppColors.success,
            ),
            const SizedBox(height: 14),

            // Become a Service Provider
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BecomeProviderScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.handyman_rounded,
                ),
                label: const Text(
                  'Become a Service Provider',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Edit Profile
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Edit profile feature will be added later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(
                    color: AppColors.danger,
                  ),
                ),
                onPressed: () {
                  // Return to the first screen.
                  // This keeps logout behavior separate
                  // from normal Back navigation.
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}