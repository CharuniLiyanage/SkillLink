import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';
import '../../widgets/status_badge.dart';

//==================== Provider Bookings Screen ====================
class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() =>
      _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState
    extends State<ProviderBookingsScreen> {
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

    final result =
        await ApiService.getProviderBookings(
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

  Future<void> completeBooking(
    int requestId,
  ) async {
    final email = Session.email;

    if(email.isEmpty) {
      return;
    }

    final success =
        await ApiService.updateServiceRequestStatus(
      requestId: requestId,
      email: email,
      status: 'COMPLETED',
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Booking marked as completed.',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      await loadBookings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to complete booking.',
          ),
        ),
      );
    }
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

      final period =
          hour >= 12 ? 'PM' : 'AM';

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
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadBookings,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    separatorBuilder:
                        (_, _) =>
                            const SizedBox(
                      height: 16,
                    ),
                    itemBuilder:
                        (context, index) {
                      final booking =
                          bookings[index];

                      final customer =
                          booking['customer'];

                      final service =
                          booking['service'];

                      final customerName =
                          customer?['name']
                                  ?.toString() ??
                              'Unknown Customer';

                      final serviceName =
                          service?['name']
                                  ?.toString() ??
                              'Unknown Service';

                      final date =
                          booking[
                                      'requestedDate']
                                  ?.toString() ??
                              '';

                      final time =
                          booking[
                                      'requestedTime']
                                  ?.toString() ??
                              '';

                      final address =
                          booking['address']
                                  ?.toString() ??
                              '';

                      final description =
                          booking['description']
                                  ?.toString() ??
                              '';

                      final status =
                          booking['status']
                                  ?.toString() ??
                              'ACCEPTED';

                      final requestId =
                          int.tryParse(
                        booking['id']
                            .toString(),
                      );

                      final displayStatus =
                          status.isNotEmpty
                              ? status[0]
                                      .toUpperCase() +
                                  status
                                      .substring(1)
                                      .toLowerCase()
                              : 'Accepted';

                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            18,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColors
                                            .primary
                                            .withValues(alpha: 0.1),
                                    child:
                                        const Icon(
                                      Icons
                                          .person_rounded,
                                      color: AppColors
                                          .primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      customerName,
                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight
                                                .w700,
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
                                height: 12,
                              ),

                              _iconRow(
                                Icons
                                    .calendar_today_rounded,
                                formatDate(date),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              _iconRow(
                                Icons
                                    .access_time_rounded,
                                formatTime(time),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              _iconRow(
                                Icons
                                    .location_on_rounded,
                                address,
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                description,
                                style:
                                    const TextStyle(
                                  fontSize: 14,
                                  color: AppColors
                                      .textSecondary,
                                ),
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              if (status ==
                                  'ACCEPTED')
                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 46,
                                  child:
                                      ElevatedButton
                                          .icon(
                                    onPressed:
                                        requestId ==
                                                null
                                            ? null
                                            : () {
                                                completeBooking(
                                                  requestId,
                                                );
                                              },
                                    icon: const Icon(
                                      Icons
                                          .check_circle_rounded,
                                    ),
                                    label: const Text(
                                      'Mark as Completed',
                                    ),
                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          AppColors
                                              .success,
                                      foregroundColor:
                                          Colors.white,
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