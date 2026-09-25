import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'become_provider_screen.dart';
import 'provider_list_screen.dart';
import 'customer_bookings_screen.dart';
import 'customer_profile_screen.dart';
import '../../widgets/section_header.dart';

// ==================== Customer Home Screen ====================

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'name': 'Electrician',
        'icon': Icons.electrical_services_rounded,
        'color': const Color(0xFF2F6FED),
      },
      {
        'name': 'Plumber',
        'icon': Icons.plumbing_rounded,
        'color': const Color(0xFF17A2A0),
      },
      {
        'name': 'Carpenter',
        'icon': Icons.carpenter_rounded,
        'color': const Color(0xFFB5652C),
      },
      {
        'name': 'Mason',
        'icon': Icons.foundation_rounded,
        'color': const Color(0xFF6B7280),
      },
      {
        'name': 'Mechanic',
        'icon': Icons.car_repair_rounded,
        'color': const Color(0xFFE5484D),
      },
      {
        'name': 'AC Technician',
        'icon': Icons.ac_unit_rounded,
        'color': const Color(0xFF2CB1E8),
      },
      {
        'name': 'Computer Technician',
        'icon': Icons.computer_rounded,
        'color': const Color(0xFF7C5CFC),
      },
      {
        'name': 'Phone Repair',
        'icon': Icons.phone_android_rounded,
        'color': const Color(0xFF22A559),
      },
      {
        'name': 'Painter',
        'icon': Icons.format_paint_rounded,
        'color': const Color(0xFFFF8A3D),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillLink'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'What service do you need today?',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a service...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================== Become Provider Banner ====================

            Card(
              elevation: 0,
              color: AppColors.primary,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BecomeProviderScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Become a Service Provider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Offer your skills and earn through SkillLink',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const SectionHeader(
              title: 'Service Categories',
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final service = services[index];

                final color =
                    service['color'] as Color;

                return Card(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProviderListScreen(
                            serviceName:
                                service['name'] as String,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  color.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Icon(
                              service['icon'] as IconData,
                              size: 26,
                              color: color,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            service['name'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              fontSize: 12.5,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ==================== Bottom Navigation ====================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CustomerBookingsScreen(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CustomerProfileScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon:
                Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.calendar_month_outlined),
            activeIcon:
                Icon(Icons.calendar_month_rounded),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon:
                Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}