import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/session.dart';
import '../../widgets/status_badge.dart';
import '../../utils/app_colors.dart';
import 'rate_provider_screen.dart';

//==================== Customer Bookings Screen ====================

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() =>
      _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState
    extends State<CustomerBookingsScreen> {

  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final email = Session.email;

    if (email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await ApiService.getCustomerRequests(
      email: email,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      bookings = result;
      isLoading = false;
    });
  }

  String formatDate(String date) {
    final parts = date.split('-');

    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }

    return date;
  }

  String formatTime(String time) {
    try {
      final parts = time.split(':');

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookings.isEmpty
              ? const Center(
                  child: Text(
                    'No bookings available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadBookings,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = bookings[index];

                      final provider =
                          booking['provider'];

                      final service =
                          booking['service'];

                      final providerName =
                          provider?['name']?.toString() ??
                              'Unknown Provider';

                      final serviceName =
                          service?['name']?.toString() ??
                              service?['category']?.toString() ??
                              'Unknown Service';

                      final date =
                          booking['requestedDate']?.toString() ??
                              '';

                      final time =
                          booking['requestedTime']?.toString() ??
                              '';

                      final address =
                          booking['address']?.toString() ??
                              '';

                      final status =
                          booking['status']?.toString() ??
                              'PENDING';

                      final requestId =
                          int.tryParse(booking['id'].toString());

                      final displayStatus =
                          status[0].toUpperCase() +
                              status.substring(1).toLowerCase();

                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColors.primary
                                            .withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons
                                          .person_rounded,
                                      color:
                                          AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 12),
                                  Expanded(
                                    child: Text(
                                      providerName,
                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                  ),
                                  StatusBadge(
                                    status:
                                        displayStatus,
                                  ),
                                ],
                              ),

                              const Divider(
                                height: 28,
                              ),

                              Text(
                                serviceName,
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors.primary,
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              _iconRow(
                                Icons
                                    .calendar_today_rounded,
                                formatDate(date),
                              ),

                              const SizedBox(
                                  height: 8),

                              _iconRow(
                                Icons
                                    .access_time_rounded,
                                formatTime(time),
                              ),

                              const SizedBox(
                                  height: 8),

                              _iconRow(
                                Icons
                                    .location_on_rounded,
                                address,
                              ),

                              const SizedBox(
                                  height: 18),

                              if (status == 'ACCEPTED')
                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 46,
                                  child:
                                      OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Contact feature will be added later.',
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons
                                          .phone_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Contact Provider',
                                    ),
                                  ),
                                ),

                              if (status == 'COMPLETED')
                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 46,
                                  child:
                                      OutlinedButton.icon(
                                    style:
                                        OutlinedButton
                                            .styleFrom(
                                      foregroundColor:
                                          AppColors
                                              .warning,
                                      side:
                                          const BorderSide(
                                        color: AppColors
                                            .warning,
                                      ),
                                    ),
                                    onPressed: requestId == null
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RateProviderScreen(
                                                serviceRequestId: requestId,
                                                providerName: providerName,
                                              ),
                                            ),
                                          ).then((_) {
                                            loadBookings();
                                          });
                                        },
                                    
                                    icon: const Icon(
                                      Icons
                                          .star_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Rate Provider',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _iconRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
