import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';

class CustomerEditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const CustomerEditProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<CustomerEditProfileScreen> createState() =>
      _CustomerEditProfileScreenState();
}

class _CustomerEditProfileScreenState
    extends State<CustomerEditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  bool isSaving = false;
  bool isPickingImage = false;

  File? selectedImage;

  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.name);

    emailController =
        TextEditingController(text: widget.email);

    phoneController =
        TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  // ================= PICK PROFILE IMAGE =================

  Future<void> pickProfileImage() async {
    if (isPickingImage) return;

    setState(() {
      isPickingImage = true;
    });

    try {
      final XFile? image =
          await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return;

      if (!mounted) return;

      setState(() {
        selectedImage = File(image.path);
      });
    } catch (e) {
      debugPrint(
        'Image Picker Error: $e',
      );

      if (!mounted) return;

      showMessage(
        'Unable to select image. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isPickingImage = false;
        });
      }
    }
  }

  // ================= SAVE PROFILE =================

  Future<void> saveProfile() async {
    final name =
        nameController.text.trim();

    final phone =
        phoneController.text.trim();

    // Validate name
    if (name.isEmpty) {
      showMessage(
        'Please enter your full name',
      );
      return;
    }

    // Validate phone
    if (phone.isEmpty) {
      showMessage(
        'Please enter your phone number',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // ================= UPDATE PROFILE DETAILS =================

      final profileUpdated =
          await ApiService.updateUserProfile(
        email: widget.email,
        name: name,
        phone: phone,
      );

      if (!profileUpdated) {
        if (!mounted) return;

        showMessage(
          'Failed to update profile details',
        );

        return;
      }

      // ================= UPLOAD PROFILE IMAGE =================

      if (selectedImage != null) {
        final imagePath =
            await ApiService.uploadCustomerProfileImage(
          email: widget.email,
          image: selectedImage!,
        );

        if (imagePath == null) {
          if (!mounted) return;

          showMessage(
            'Profile details saved, but image upload failed',
          );

          return;
        }
      }

      // ================= SUCCESS =================

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      debugPrint(
        'Save Profile Error: $e',
      );

      if (!mounted) return;

      showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ================= MESSAGE =================

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ================= PROFILE HEADER =================

              Center(
                child: Column(
                  children: [

                    Stack(
                      children: [

                        CircleAvatar(
                          radius: 58,
                          backgroundColor:
                              AppColors.primary
                                  .withValues(
                            alpha: 0.1,
                          ),
                          backgroundImage:
                              selectedImage != null
                                  ? FileImage(
                                      selectedImage!,
                                    )
                                  : null,
                          child:
                              selectedImage == null
                                  ? const Icon(
                                      Icons
                                          .person_rounded,
                                      size: 62,
                                      color:
                                          AppColors
                                              .primary,
                                    )
                                  : null,
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child:
                              GestureDetector(
                            onTap:
                                isPickingImage
                                    ? null
                                    : pickProfileImage,
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration:
                                  BoxDecoration(
                                color:
                                    AppColors.primary,
                                shape:
                                    BoxShape.circle,
                                border:
                                    Border.all(
                                  color:
                                      Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons
                                    .camera_alt_rounded,
                                color:
                                    Colors.white,
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    const Text(
                      'Profile Photo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    const Text(
                      'Tap the camera icon to change your photo',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            AppColors
                                .textSecondary,
                      ),
                      textAlign:
                          TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              // ================= PERSONAL INFORMATION =================

              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      AppColors.textPrimary,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              const Text(
                'Update your personal details below.',
                style: TextStyle(
                  fontSize: 13,
                  color:
                      AppColors.textSecondary,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ================= FULL NAME =================

              const Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      AppColors.textPrimary,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              TextField(
                controller:
                    nameController,
                textCapitalization:
                    TextCapitalization
                        .words,
                decoration:
                    InputDecoration(
                  hintText:
                      'Enter your full name',
                  prefixIcon:
                      const Icon(
                    Icons
                        .person_outline_rounded,
                  ),
                  filled: true,
                  fillColor:
                      Colors.white,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(14),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ================= EMAIL =================

              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      AppColors.textPrimary,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              TextField(
                controller:
                    emailController,
                readOnly: true,
                decoration:
                    InputDecoration(
                  hintText:
                      'Email address',
                  prefixIcon:
                      const Icon(
                    Icons
                        .email_outlined,
                  ),
                  suffixIcon:
                      const Icon(
                    Icons
                        .lock_outline_rounded,
                    size: 20,
                  ),
                  filled: true,
                  fillColor:
                      const Color(
                    0xFFF0F2F5,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(14),
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              const Text(
                'Email address cannot be changed.',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      AppColors
                          .textSecondary,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ================= PHONE =================

              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                  color:
                      AppColors.textPrimary,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              TextField(
                controller:
                    phoneController,
                keyboardType:
                    TextInputType.phone,
                decoration:
                    InputDecoration(
                  hintText:
                      'Enter your phone number',
                  prefixIcon:
                      const Icon(
                    Icons
                        .phone_outlined,
                  ),
                  filled: true,
                  fillColor:
                      Colors.white,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(14),
                  ),
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              // ================= SAVE BUTTON =================

              SizedBox(
                width:
                    double.infinity,
                height: 54,
                child:
                    ElevatedButton(
                  onPressed:
                      isSaving
                          ? null
                          : saveProfile,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor:
                        Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary
                            .withValues(
                      alpha: 0.6,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(14),
                    ),
                  ),
                  child:
                      isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2.5,
                                color:
                                    Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Icon(
                                  Icons
                                      .save_rounded,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Save Changes',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}