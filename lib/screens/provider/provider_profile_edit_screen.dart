import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';

//==================== Provider Profile Edit Screen ====================

class ProviderProfileEditScreen extends StatefulWidget {
  const ProviderProfileEditScreen({super.key});

  @override
  State<ProviderProfileEditScreen> createState() =>
      _ProviderProfileEditScreenState();
}

class _ProviderProfileEditScreenState
    extends State<ProviderProfileEditScreen> {

  // ==================== Controllers ====================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController experienceController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  // ==================== Variables ====================

  bool isLoading = false;

  File? selectedProfileImage;
  String? profileImageUrl;

  // ==================== Init ====================

  @override
  void initState() {
    super.initState();

    loadProviderProfile();
  }

  // ==================== Load Provider Profile ====================

  Future<void> loadProviderProfile() async {
    final email = Session.email;

    print('================================');
    print('LOADING PROVIDER PROFILE');
    print('PROFILE EMAIL: $email');
    print('================================');

    if (email == null || email.isEmpty) {
      print('PROFILE EMAIL IS NULL OR EMPTY');
      return;
    }

    try {
      final profile =
          await ApiService.getProviderProfile(email);

      print('PROFILE DATA: $profile');

      if (!mounted) return;

      if (profile != null) {
        setState(() {

          // ==================== User Data ====================

          final user = profile['user'];

          nameController.text =
              user?['name']?.toString() ?? '';

          phoneController.text =
              user?['phone']?.toString() ?? '';

          // ==================== Provider Data ====================

          locationController.text =
              profile['location']?.toString() ?? '';

          experienceController.text =
              profile['experience']?.toString() ?? '';

          descriptionController.text =
              profile['description']?.toString() ?? '';

          final imagePath =
              profile['profileImage']?.toString();

          if (imagePath != null && imagePath.isNotEmpty) {
            profileImageUrl =
                '${ApiService.baseUrl}$imagePath';
          }
        });

        print('PROVIDER PROFILE LOADED SUCCESSFULLY');
      } else {
        print('PROFILE DATA IS NULL');
      }
    } catch (e) {
      print(
        'Load Provider Profile Error: $e',
      );
    }
  }

  // ==================== Pick Profile Image ====================

  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image =
          await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedProfileImage =
            File(image.path);
      });

      print(
        'SELECTED PROFILE IMAGE: ${image.path}',
      );
    } catch (e) {
      print(
        'Pick Profile Image Error: $e',
      );
    }
  }

  // ==================== Save Profile ====================

  Future<void> saveProfile() async {
    final email = Session.email;

    // ==================== Check Session ====================

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

    // ==================== Validate Name ====================

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your full name.',
          ),
        ),
      );

      return;
    }

    // ==================== Validate Phone ====================

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your phone number.',
          ),
        ),
      );

      return;
    }

    // ==================== Validate Location ====================

    if (locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your location.',
          ),
        ),
      );

      return;
    }

    // ==================== Validate Experience ====================

    if (experienceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your years of experience.',
          ),
        ),
      );

      return;
    }

    final experience =
        int.tryParse(
      experienceController.text.trim(),
    );

    if (experience == null || experience < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid experience.',
          ),
        ),
      );

      return;
    }

    // ==================== Validate Description ====================

    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a description about yourself.',
          ),
        ),
      );

      return;
    }

    // ==================== Start Loading ====================

    setState(() {
      isLoading = true;
    });

    // ==================== Save Provider Profile ====================

    final success =
      await ApiService.saveProviderProfile(
        email: email,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        location: locationController.text.trim(),
        experience: experience,
        description: descriptionController.text.trim(),
      );

    if (!mounted) return;

    // ==================== Check Profile Save ====================

    if (!success) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save profile. Please try again.',
          ),
        ),
      );

      return;
    }

    // ==================== Upload Profile Image ====================

    if (selectedProfileImage != null) {

      print(
        'UPLOADING PROFILE IMAGE...',
      );

      final imageResult =
          await ApiService.uploadProviderProfileImage(
        email: email,
        image: selectedProfileImage!,
      );

      if (imageResult == null) {

        print(
          'PROFILE IMAGE UPLOAD FAILED',
        );

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile saved, but profile photo upload failed.',
            ),
          ),
        );

        return;
      }

      print(
        'PROFILE IMAGE UPLOAD SUCCESS: $imageResult',
      );
    }

    // ==================== Stop Loading ====================

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    // ==================== Success ====================

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile saved successfully!',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ==================== App Bar ====================

      appBar: AppBar(
        title: const Text(
          'My Provider Profile',
        ),
      ),

      // ==================== Body ====================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ==================== Profile Photo ====================

            Stack(
              children: [

                CircleAvatar(
                  radius: 55,

                  backgroundColor:
                      AppColors.primary.withOpacity(0.1),

                  backgroundImage:
                    selectedProfileImage != null
                        ? FileImage(
                            selectedProfileImage!,
                          )
                        : profileImageUrl != null
                            ? NetworkImage(
                                profileImageUrl!,
                              )
                            : null,

                child:
                    selectedProfileImage == null &&
                            profileImageUrl == null
                        ? const Icon(
                            Icons.person_rounded,
                            size: 58,
                            color: AppColors.primary,
                          )
                        : null,
                ),

                // ==================== Camera Icon ====================

                Positioned(
                  bottom: 0,
                  right: 0,

                  child: Container(
                    padding:
                        const EdgeInsets.all(6),

                    decoration:
                        const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ==================== Change Photo ====================

            TextButton.icon(
              onPressed:
                  isLoading
                      ? null
                      : pickProfileImage,

              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 18,
              ),

              label: const Text(
                'Change Profile Photo',
              ),
            ),

            const SizedBox(height: 20),

            // ==================== Full Name ====================

            TextField(
              controller:
                  nameController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Full Name',

                hintText:
                    'Enter your full name',

                prefixIcon:
                    Icon(
                  Icons.person_outline,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== Phone ====================

            TextField(
              controller:
                  phoneController,

              keyboardType:
                  TextInputType.phone,

              decoration:
                  const InputDecoration(
                labelText:
                    'Phone Number',

                hintText:
                    'Enter your phone number',

                prefixIcon:
                    Icon(
                  Icons.phone_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== Location ====================

            TextField(
              controller:
                  locationController,

              decoration:
                  const InputDecoration(
                labelText:
                    'Location',

                hintText:
                    'Enter your location',

                prefixIcon:
                    Icon(
                  Icons.location_on_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== Experience ====================

            TextField(
              controller:
                  experienceController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText:
                    'Experience',

                hintText:
                    'Years of experience',

                prefixIcon:
                    Icon(
                  Icons.work_outline,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== About Me ====================

            TextField(
              controller:
                  descriptionController,

              maxLines: 4,

              decoration:
                  const InputDecoration(
                labelText:
                    'About Me',

                hintText:
                    'Tell customers about your experience and services...',

                prefixIcon:
                    Icon(
                  Icons.description_outlined,
                ),
              ),
            ),

            const SizedBox(height: 25),

            

            // ==================== Save Button ====================

            SizedBox(
              width: double.infinity,
              height: 54,

              child:
                  ElevatedButton.icon(

                onPressed:
                    isLoading
                        ? null
                        : saveProfile,

                icon:
                    isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.save_rounded,
                            size: 18,
                          ),

                label:
                    Text(
                  isLoading
                      ? 'Saving Profile...'
                      : 'Save Profile',

                  style:
                      const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Dispose ====================

  @override
  void dispose() {

    nameController.dispose();

    phoneController.dispose();

    locationController.dispose();

    experienceController.dispose();

    descriptionController.dispose();

    super.dispose();
  }
}
