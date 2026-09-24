import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../widgets/info_tile.dart';
import '../../widgets/section_header.dart';



import 'provider_profile_screen.dart';

//==================== Request Service Screen ====================
class RequestServiceScreen extends StatefulWidget {
  final String providerName;
  final String serviceName;
  final String customerEmail;
  final String providerEmail;

  const RequestServiceScreen({
    super.key,
    required this.providerName,
    required this.serviceName,
    required this.customerEmail,
    required this.providerEmail,
  });

  @override
  State<RequestServiceScreen> createState() =>
      _RequestServiceScreenState();
}

class _RequestServiceScreenState
    extends State<RequestServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> submitRequest() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (selectedDate == null ||
      selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select date and time.',
        ),
      ),
    );
    return;
  }

  final requestedDate =
      '${selectedDate!.year}-'
      '${selectedDate!.month.toString().padLeft(2, '0')}-'
      '${selectedDate!.day.toString().padLeft(2, '0')}';

  final requestedTime =
      '${selectedTime!.hour.toString().padLeft(2, '0')}:'
      '${selectedTime!.minute.toString().padLeft(2, '0')}';

  final services =
      await ApiService.getProviderServices(
    email: widget.providerEmail,
  );

  if (services == null || services.isEmpty) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No services found for this provider.',
        ),
      ),
    );

    return;
  }

  final matchingServices = services.where((service) {
    return service['category']?.toString() ==
        widget.serviceName;
  }).toList();

  if (matchingServices.isEmpty) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected service is not available.',
        ),
      ),
    );

    return;
  }

  final serviceId =
      int.tryParse(
        matchingServices.first['id'].toString(),
      );

  if (serviceId == null) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Invalid service.',
        ),
      ),
    );

    return;
  }

  final result =
      await ApiService.createServiceRequest(
    customerEmail: widget.customerEmail,
    providerEmail: widget.providerEmail,
    serviceId: serviceId,
    requestedDate: requestedDate,
    requestedTime: requestedTime,
    address: addressController.text.trim(),
    description:
        descriptionController.text.trim(),
  );

  if (!mounted) return;

  if (result != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Service request submitted successfully!',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to submit service request.',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Service'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ==================== SERVICE DETAILS ====================

              const SectionHeader(
                title: 'Service Details',
              ),

              const SizedBox(height: 18),

              // ==================== PROVIDER ====================

              InfoTile(
                icon: Icons.person_rounded,
                title: 'Provider',
                subtitle: widget.providerName,
              ),

              // ==================== SERVICE ====================

              InfoTile(
                icon: Icons.build_rounded,
                title: 'Service',
                subtitle: widget.serviceName,
                iconColor: AppColors.secondary,
              ),

              const SizedBox(height: 12),

              // ==================== DATE ====================

              const Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: selectDate,

                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                  ),

                  label: Text(
                    selectedDate == null
                        ? 'Choose Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================== TIME ====================

              const Text(
                'Select Time',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: selectTime,

                  icon: const Icon(
                    Icons.access_time_rounded,
                    size: 18,
                  ),

                  label: Text(
                    selectedTime == null
                        ? 'Choose Time'
                        : selectedTime!.format(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================== ADDRESS ====================

              const Text(
                'Service Address',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: addressController,
                maxLines: 2,

                decoration: const InputDecoration(
                  hintText:
                      'Enter your service address',

                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ==================== PROBLEM ====================

              const Text(
                'Describe Your Problem',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    descriptionController,

                maxLines: 4,

                decoration: const InputDecoration(
                  hintText:
                      'Describe what service you need...',

                  prefixIcon: Icon(
                    Icons.description_outlined,
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please describe your problem';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // ==================== SUBMIT ====================

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton.icon(
                  onPressed: submitRequest,

                  icon: const Icon(
                    Icons.send_rounded,
                    size: 18,
                  ),

                  label: const Text(
                    'Submit Request',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}


 