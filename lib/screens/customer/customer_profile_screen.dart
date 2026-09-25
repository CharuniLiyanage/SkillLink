import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';
import 'customer_edit_profile_screen.dart';
import 'become_provider_screen.dart';

// ==================== Customer Profile Screen ====================

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState
    extends State<CustomerProfileScreen> {
  bool isLoading = true;

  String name = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // ================= LOAD PROFILE =================

  Future<void> loadProfile() async {
    if (Session.email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final profile = await ApiService.getUserProfile(
      email: Session.email,
    );

    debugPrint('CUSTOMER PROFILE EMAIL: ${Session.email}');
    debugPrint('CUSTOMER PROFILE DATA: $profile');

    if (!mounted) return;

    if (profile != null) {
      setState(() {
        name = profile['name'] ?? '';
        email = profile['email'] ?? Session.email;
        phone = profile['phone'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load profile'),
        ),
      );
    }
  }


  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadProfile,
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Profile photo
                    CircleAvatar(
                      radius: 55,
                      backgroundColor:
                          AppColors.primary.withValues(
                        alpha: 0.1,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 58,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Name
                    Text(
                      name.isEmpty ? 'Customer' : name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 4),

                    // Email
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    // Full Name
                    _ProfileInfoTile(
                      icon: Icons.person_rounded,
                      title: 'Full Name',
                      subtitle:
                          name.isEmpty ? 'Not added' : name,
                    ),

                    // Email
                    const SizedBox(height: 12),

                    _ProfileInfoTile(
                      icon: Icons.email_rounded,
                      title: 'Email',
                      subtitle: email,
                      iconColor: AppColors.secondary,
                    ),

                    // Phone
                    const SizedBox(height: 12),

                    _ProfileInfoTile(
                      icon: Icons.phone_rounded,
                      title: 'Phone Number',
                      subtitle:
                          phone.isEmpty ? 'Not added' : phone,
                      iconColor: AppColors.success,
                    ),

                    const SizedBox(height: 20),

                    // Become Provider
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
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerEditProfileScreen(
                                name: name,
                                email: email,
                                phone: phone,
                              ),
                            ),
                          );

                          if (updated == true && mounted) {
                            await loadProfile();
                          }
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
                          foregroundColor:
                              AppColors.danger,
                          side: const BorderSide(
                            color: AppColors.danger,
                          ),
                        ),
                        onPressed: () {
                          Session.email = '';
                          Session.roles = [];

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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}

// ================= PROFILE INFO TILE =================

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}