import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';

//==================== My Services Screen ====================
class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() =>
      _MyServicesScreenState();
}

class _MyServicesScreenState
    extends State<MyServicesScreen> {
  List<dynamic> services = [];

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  // ============================================================
  // LOAD SERVICES
  // ============================================================

  Future<void> loadServices() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final result =
          await ApiService.getProviderServices(
        email: email,
      );

      if (!mounted) return;

      setState(() {
        services = result ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Load Services Error: $e');

      if (!mounted) return;

      setState(() {
        services = [];
        isLoading = false;
      });
    }
  }
  

  // ============================================================
  // SERVICE FORM DIALOG
  // ============================================================
Future<Map<String, dynamic>?> showServiceForm({
  Map<String, dynamic>? service,
}) async {
  final bool isEditing = service != null;

  final nameController = TextEditingController(
    text: isEditing
        ? service!['name']?.toString() ?? ''
        : '',
  );

  final descriptionController = TextEditingController(
    text: isEditing
        ? service!['description']?.toString() ?? ''
        : '',
  );

  final priceController = TextEditingController(
    text: isEditing
        ? service!['price']?.toString() ?? ''
        : '',
  );

  String selectedCategory = isEditing
      ? service!['category']?.toString() ?? 'Electrician'
      : 'Electrician';

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (
          dialogContext,
          setDialogState,
        ) {
          return AlertDialog(
            title: Text(
              isEditing
                  ? 'Edit Service'
                  : 'Add Service',
            ),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ==================== SERVICE NAME ====================

                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Service Name',
                      hintText: 'e.g. House Wiring',
                      prefixIcon: Icon(
                        Icons.build_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================== CATEGORY ====================

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(
                        Icons.category_outlined,
                      ),
                    ),
                    items: const [
                      'Electrician',
                      'Plumber',
                      'Carpenter',
                      'Mason',
                      'Mechanic',
                      'AC Technician',
                      'Computer Technician',
                      'Phone Repair',
                      'Painter',
                    ].map(
                      (category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================== DESCRIPTION ====================

                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe your service',
                      prefixIcon: Icon(
                        Icons.description_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================== PRICE ====================

                  TextField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter service price',
                      prefixIcon: Icon(
                        Icons.payments_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================== ACTIONS ====================

            actions: [

              // ==================== CANCEL ====================

              TextButton(
                onPressed: () async {
                  // Close keyboard
                  FocusManager.instance.primaryFocus?.unfocus();

                  // Give Android keyboard time to close
                  await Future.delayed(
                    const Duration(milliseconds: 300),
                  );

                  // Close dialog
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text(
                  'Cancel',
                ),
              ),

              // ==================== ADD / UPDATE ====================

              ElevatedButton(
                onPressed: () async {
                  final name =
                      nameController.text.trim();

                  final description =
                      descriptionController.text.trim();

                  final priceText =
                      priceController.text.trim();

                  // ==================== VALIDATION ====================

                  if (name.isEmpty ||
                      description.isEmpty ||
                      priceText.isEmpty) {
                    FocusManager.instance
                        .primaryFocus
                        ?.unfocus();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all fields.',
                        ),
                      ),
                    );

                    return;
                  }

                  final price =
                      double.tryParse(priceText);

                  if (price == null || price < 0) {
                    FocusManager.instance
                        .primaryFocus
                        ?.unfocus();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid price.',
                        ),
                      ),
                    );

                    return;
                  }

                  // ==================== CLOSE KEYBOARD ====================

                  FocusManager.instance
                      .primaryFocus
                      ?.unfocus();

                  // Give Android keyboard time to close
                  await Future.delayed(
                    const Duration(milliseconds: 300),
                  );

                  // ==================== CLOSE DIALOG ====================

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop({
                      'name': name,
                      'category': selectedCategory,
                      'description': description,
                      'price': price,
                    });
                  }
                },
                child: Text(
                  isEditing
                      ? 'Update'
                      : 'Add Service',
                ),
              ),
            ],
          );
        },
      );
    },
  );

  // ==================== DISPOSE CONTROLLERS ====================

  nameController.dispose();
  descriptionController.dispose();
  priceController.dispose();

  return result;
}


  // ============================================================
  // ADD SERVICE
  // ============================================================

  Future<void> addService() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    final data =
        await showServiceForm();

    if (data == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isSaving = true;
    });

    final success =
        await ApiService.addService(
      email: email,
      name: data['name'],
      category: data['category'],
      description: data['description'],
      price: data['price'],
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Service added successfully!',
          ),
          backgroundColor:
              AppColors.success,
        ),
      );

      await loadServices();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Could not add service.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // EDIT SERVICE
  // ============================================================
  Future<void> editService(
  Map<String, dynamic> service,
) async {
  final email = Session.email;

  if (email == null || email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'User session not found. Please login again.',
        ),
      ),
    );
    return;
  }

  final serviceId = int.tryParse(
    service['id'].toString(),
  );

  if (serviceId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid service ID.'),
      ),
    );
    return;
  }

  // Open edit form
  final data = await showServiceForm(
    service: service,
  );

  // User cancelled
  if (data == null) {
    return;
  }

  // Make sure screen is still active
  if (!mounted) {
    return;
  }

  print('EDIT: FORM CLOSED');
  print('EDIT: API CALL STARTED');

  setState(() {
    isSaving = true;
  });

  try {
    final success = await ApiService.updateService(
      id: serviceId,
      email: email,
      name: data['name'].toString(),
      category: data['category'].toString(),
      description: data['description'].toString(),
      price: (data['price'] as num).toDouble(),
    );

    print('EDIT: API CALL FINISHED - $success');

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Service updated successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      await loadServices();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not update service.',
          ),
        ),
      );
    }
  } catch (e) {
    print('EDIT ERROR: $e');

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Update error: $e',
        ),
      ),
    );
  }
}
  
  // ============================================================
  // DELETE SERVICE
  // ============================================================

  Future<void> deleteService(
      Map<String, dynamic> service) async {

    final email = Session.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    final serviceId =
        int.tryParse(
      service['id'].toString(),
    );

    if (serviceId == null) {
      return;
    }

    final shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Service',
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${service['name']}"?',
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isSaving = true;
    });

    final success =
        await ApiService.deleteService(
      id: serviceId,
      email: email,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Service deleted successfully!',
          ),
          backgroundColor:
              AppColors.success,
        ),
      );

      await loadServices();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Could not delete service.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Services',
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            isSaving ? null : addService,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Service',
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : services.isEmpty

              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons
                            .build_circle_outlined,
                        size: 70,
                        color:
                            AppColors
                                .textSecondary,
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      Text(
                        'No services added yet.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      SizedBox(
                        height: 6,
                      ),

                      Text(
                        'Tap + Add Service to get started.',
                        style: TextStyle(
                          color:
                              AppColors
                                  .textSecondary,
                        ),
                      ),
                    ],
                  ),
                )

              : RefreshIndicator(
                  onRefresh:
                      loadServices,

                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    itemCount:
                        services.length,

                    itemBuilder:
                        (context, index) {

                      final service =
                          services[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              // ==================== SERVICE INFO ====================

                              Row(
                                children: [

                                  Container(
                                    width: 48,
                                    height: 48,

                                    decoration:
                                        BoxDecoration(
                                      color: AppColors
                                          .primary
                                          .withOpacity(
                                        0.1,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),

                                    child:
                                        const Icon(
                                      Icons
                                          .build_rounded,
                                      color:
                                          AppColors
                                              .primary,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  Expanded(
                                    child:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        Text(
                                          service[
                                                      'name']
                                                  ?.toString() ??
                                              '',
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                17,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          service[
                                                      'category']
                                                  ?.toString() ??
                                              '',
                                          style:
                                              const TextStyle(
                                            color:
                                                AppColors
                                                    .secondary,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    'Rs. ${service['price'] ?? 0}',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      fontSize:
                                          15,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 14,
                              ),

                              // ==================== DESCRIPTION ====================

                              Text(
                                service[
                                            'description']
                                        ?.toString() ??
                                    '',
                                style:
                                    const TextStyle(
                                  color:
                                      AppColors
                                          .textSecondary,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(
                                height: 14,
                              ),

                              // ==================== BUTTONS ====================

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,

                                children: [

                                  OutlinedButton.icon(
                                    onPressed:
                                        isSaving
                                            ? null
                                            : () {
                                                editService(
                                                  service,
                                                );
                                              },
                                    icon:
                                        const Icon(
                                      Icons
                                          .edit_outlined,
                                      size: 18,
                                    ),
                                    label:
                                        const Text(
                                      'Edit',
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  OutlinedButton.icon(
                                    onPressed:
                                        isSaving
                                            ? null
                                            : () {
                                                deleteService(
                                                  service,
                                                );
                                              },
                                    icon:
                                        const Icon(
                                      Icons
                                          .delete_outline,
                                      size: 18,
                                    ),
                                    label:
                                        const Text(
                                      'Delete',
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
}