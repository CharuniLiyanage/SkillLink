import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';
import '../../widgets/section_header.dart';


import '../customer/customer_home_screen.dart';
import 'provider_profile_edit_screen.dart';
import 'my_services_screen.dart';
import 'provider_requests_screen.dart';
import 'provider_bookings_screen.dart';


// ==================== Provider Dashboard Screen ====================

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState
    extends State<ProviderDashboardScreen> {

  // ==================== Rating ====================

  double averageRating = 0.0;
  int reviewCount = 0;
  bool isLoadingRating = true;

  int pendingRequests = 0;
  int completedRequests = 0;
  int totalCustomers = 0;
  bool isLoadingStats = true;

  // ==================== Init ====================

  @override
    void initState() {
      super.initState();

      loadProviderRating();
      loadDashboardStats();
    }
  // ==================== Load Provider Rating ====================

  Future<void> loadProviderRating() async {
    final email = Session.email;

    debugPrint('================================');
    debugPrint('LOADING PROVIDER DASHBOARD RATING');
    debugPrint('PROVIDER EMAIL: $email');
    debugPrint('================================');

    if (email.isEmpty) {
      if (!mounted) return;

      setState(() {
        averageRating = 0.0;
        reviewCount = 0;
        isLoadingRating = false;
      });

      return;
    }

    try {
      final result =
          await ApiService.getProviderReviews(email);

      debugPrint('DASHBOARD REVIEWS: $result');
      debugPrint(
        'DASHBOARD REVIEW COUNT: ${result.length}',
      );

      double totalRating = 0.0;

      for (final review in result) {
        final rating =
            double.tryParse(
                  review['rating']?.toString() ?? '0',
                ) ??
                0.0;

        debugPrint('DASHBOARD REVIEW RATING: $rating');

        totalRating += rating;
      }

      final double calculatedAverage =
          result.isEmpty
              ? 0.0
              : totalRating / result.length;

      debugPrint(
        'DASHBOARD TOTAL RATING: $totalRating',
      );

      debugPrint(
        'DASHBOARD AVERAGE RATING: '
        '$calculatedAverage',
      );

      if (!mounted) return;

      setState(() {
        averageRating = calculatedAverage;
        reviewCount = result.length;
        isLoadingRating = false;
      });
    } catch (e) {
      debugPrint('================================');
      debugPrint('DASHBOARD RATING ERROR: $e');
      debugPrint('================================');

      if (!mounted) return;

      setState(() {
        averageRating = 0.0;
        reviewCount = 0;
        isLoadingRating = false;
      });
    }
  }

  //--------------Load Dashboard Stats-----------------//
  Future<void> loadDashboardStats() async {
   final email = Session.email;

    debugPrint('================================');
    debugPrint('LOADING PROVIDER DASHBOARD STATS');
    debugPrint('PROVIDER EMAIL: $email');
    debugPrint('================================');

    if (email.isEmpty) {
      if (!mounted) return;

      setState(() {
        pendingRequests = 0;
        completedRequests = 0;
        totalCustomers = 0;
        isLoadingStats = false;
      });

      return;
    }

    try {
      final result = await ApiService.getProviderRequests(
        email: email,
      );

      debugPrint('DASHBOARD REQUESTS: $result');
      debugPrint(
        'DASHBOARD REQUEST COUNT: ${result.length}',
      );

      int pending = 0;
      int completed = 0;

      final Set<String> customerIds = {};

      for (final request in result) {
        final status =
            request['status']?.toString().toUpperCase() ?? '';

        debugPrint('REQUEST STATUS: $status');

        if (status == 'PENDING') {
          pending++;
        }

        if (status == 'COMPLETED') {
          completed++;
        }

        final customer = request['customer'];

        if (customer != null) {
          final customerId =
              customer['id']?.toString();

          final customerEmail =
              customer['email']?.toString();

          if (customerId != null &&
              customerId.isNotEmpty) {
            customerIds.add(customerId);
          } else if (customerEmail != null &&
              customerEmail.isNotEmpty) {
            customerIds.add(customerEmail);
          }
        }
      }

      debugPrint('PENDING REQUESTS: $pending');
      debugPrint('COMPLETED REQUESTS: $completed');
      debugPrint('UNIQUE CUSTOMERS: ${customerIds.length}');

      if (!mounted) return;

      setState(() {
        pendingRequests = pending;
        completedRequests = completed;
        totalCustomers = customerIds.length;
        isLoadingStats = false;
      });
    } catch (e) {
      debugPrint('================================');
      debugPrint('DASHBOARD STATS ERROR: $e');
      debugPrint('================================');

      if (!mounted) return;

      setState(() {
        pendingRequests = 0;
        completedRequests = 0;
        totalCustomers = 0;
        isLoadingStats = false;
      });
    }
  }

  // ==================== Switch to Customer ====================

  Future<void> switchToCustomer(
    BuildContext context,
  ) async {
    final email = Session.email;

    // Check session
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

    // Customer role already exists
    if (Session.roles.contains('CUSTOMER')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const CustomerHomeScreen(),
        ),
      );

      return;
    }

    // Add CUSTOMER role
    final success = await ApiService.addRole(
      email: email,
      role: 'CUSTOMER',
    );

    if (!context.mounted) return;

    if (success) {
      // Update current session
      Session.roles.add('CUSTOMER');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can now use SkillLink as a Customer!',
          ),
        ),
      );

      // Go to Customer Home
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const CustomerHomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not switch to Customer.',
          ),
        ),
      );
    }
  }

  // ==================== Build ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Provider Dashboard',
        ),

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
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================== Welcome ====================

            const Text(
              'Welcome, Service Provider!',

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage your services and customer requests.',

              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // ==================== My Profile ====================

            _dashboardTile(
              context,

              icon: Icons.person_rounded,

              color: AppColors.primary,

              title: 'My Profile',

              subtitle:
                  'View and edit your provider profile',

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderProfileEditScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== My Services ====================

            _dashboardTile(
              context,

              icon: Icons.build_rounded,

              color: AppColors.secondary,

              title: 'My Services',

              subtitle:
                  'Manage the services you provide',

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        const MyServicesScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== Service Requests ====================

            _dashboardTile(
              context,

              icon: Icons.assignment_rounded,

              color: AppColors.warning,

              title: 'Service Requests',

              subtitle:
                  'View customer service requests',

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderRequestsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== My Bookings ====================

            _dashboardTile(
              context,

              icon: Icons.calendar_month_rounded,

              color: AppColors.success,

              title: 'My Bookings',

              subtitle:
                  'View accepted and completed bookings',

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderBookingsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== Switch to Customer ====================

            _dashboardTile(
              context,

              icon: Icons.person_search_rounded,

              color: AppColors.primary,

              title: 'Switch to Customer',

              subtitle:
                  'Find and book services from other providers',

              onTap: () {
                switchToCustomer(context);
              },
            ),

            const SizedBox(height: 28),

            // ==================== Overview ====================

            const SectionHeader(
              title: 'Overview',
            ),

            const SizedBox(height: 16),

             // ==================== Requests / Completed ====================

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.pending_actions_rounded,
                    title: 'Requests',
                    value: isLoadingStats
                        ? '...'
                        : pendingRequests.toString(),
                    color: AppColors.warning,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon: Icons.check_circle_rounded,
                    title: 'Completed',
                    value: isLoadingStats
                        ? '...'
                        : completedRequests.toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ==================== Rating / Customers ====================

            Row(
              children: [

                // ==================== RATING ====================

                Expanded(
                  child: _statCard(
                    icon:
                        Icons.star_rounded,

                    title: 'Rating',

                    value:
                        isLoadingRating
                            ? '...'
                            : averageRating
                                .toStringAsFixed(1),

                    color:
                        AppColors.secondary,
                  ),
                ),

                const SizedBox(width: 12),

                // ==================== CUSTOMERS ====================

                Expanded(
                  child: _statCard(
                    icon:
                        Icons.people_rounded,

                    title: 'Customers',

                    value: isLoadingStats
                      ? '...'
                      : totalCustomers.toString(),

                    color:
                        AppColors.primary,
                  ),
                ),
              ],
            ),

            // Optional review count
            if (!isLoadingRating &&
                reviewCount > 0) ...[

              const SizedBox(height: 8),

              Center(
                child: Text(
                  '$reviewCount reviews',

                  style: const TextStyle(
                    fontSize: 12,
                    color:
                        AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== Dashboard Tile ====================

  Widget _dashboardTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        borderRadius:
            BorderRadius.circular(16),

        onTap: onTap,

        child: Padding(
          padding:
              const EdgeInsets.all(16),

          child: Row(
            children: [

              Container(
                width: 50,
                height: 50,

                decoration:
                    BoxDecoration(
                  color:
                      color.withValues(alpha: 0.12),

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,

                  color: color,

                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      title,

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.w700,

                        fontSize: 16,

                        color:
                            AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      style:
                          const TextStyle(
                        fontSize: 12.5,

                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,

                size: 16,

                color:
                    AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }


// ==================== Stat Card ====================

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}