import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';

import 'provider_dashboard_screen.dart';
import '../../widgets/status_badge.dart';

//-----------ProvideRequestsScreen----------------//
class ProviderRequestsScreen extends StatefulWidget {
  const ProviderRequestsScreen({super.key});

  @override
  State<ProviderRequestsScreen> createState() =>
      _ProviderRequestsScreenState();
}

class _ProviderRequestsScreenState
    extends State<ProviderRequestsScreen> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await ApiService.getProviderRequests(
      email: email,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      requests = result;
      isLoading = false;
    });
  }

  Future<void> updateStatus(
    int requestId,
    String status,
  ) async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      return;
    }

    final success =
        await ApiService.updateServiceRequestStatus(
      requestId: requestId,
      email: email,
      status: status,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'ACCEPTED'
                ? 'Service request accepted.'
                : 'Service request rejected.',
          ),
          backgroundColor: status == 'ACCEPTED'
          ? AppColors.success
          : Colors.red,
        ),
      );

      await loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update service request.',
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
        title: const Text('Service Requests'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : requests.isEmpty
              ? const Center(
                  child: Text(
                    'No service requests available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadRequests,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final request = requests[index];

                      final customer =
                          request['customer'];

                      final service =
                          request['service'];

                      final customerName =
                          customer?['name']?.toString() ??
                              'Unknown Customer';

                      final serviceName =
                          service?['name']?.toString() ??
                              'Unknown Service';

                      final date =
                          request['requestedDate']
                                  ?.toString() ??
                              '';

                      final time =
                          request['requestedTime']
                                  ?.toString() ??
                              '';

                      final address =
                          request['address']?.toString() ??
                              '';

                      final description =
                          request['description']
                                  ?.toString() ??
                              '';

                      final status =
                          request['status']?.toString() ??
                              'PENDING';

                      final requestId =
                          int.tryParse(
                        request['id'].toString(),
                      );

                      final displayStatus =
                          status.isNotEmpty
                              ? status[0].toUpperCase() +
                                  status
                                      .substring(1)
                                      .toLowerCase()
                              : 'Pending';

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
                                            .withOpacity(0.1),
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
                                      customerName,
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
                                  height: 12),

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
                                  height: 18),

                              if (status == 'PENDING')
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          OutlinedButton.icon(
                                        onPressed:
                                            requestId ==
                                                    null
                                                ? null
                                                : () {
                                                    updateStatus(
                                                      requestId,
                                                      'REJECTED',
                                                    );
                                                  },
                                        icon: const Icon(
                                          Icons
                                              .close_rounded,
                                        ),
                                        label:
                                            const Text(
                                          'Reject',
                                        ),
                                        style:
                                            OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),      
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 12),
                                    Expanded(
                                      child:
                                          ElevatedButton
                                              .icon(
                                        onPressed:
                                            requestId ==
                                                    null
                                                ? null
                                                : () {
                                                    updateStatus(
                                                      requestId,
                                                      'ACCEPTED',
                                                    );
                                                  },
                                        icon: const Icon(
                                          Icons
                                              .check_rounded,
                                        ),
                                        label:
                                            const Text(
                                          'Accept',
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