import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';

//----------------RateProviderScreen----------------//
class RateProviderScreen extends StatefulWidget {
    final int serviceRequestId;
    final String providerName;

    const RateProviderScreen({
      super.key,
      required this.serviceRequestId,
      required this.providerName,
    });

    @override
    State<RateProviderScreen> createState() =>
        _RateProviderScreenState();
  }

  class _RateProviderScreenState
      extends State<RateProviderScreen> {
    int selectedRating = 0;

    final TextEditingController commentController =
        TextEditingController();

    bool isSubmitting = false;

    @override
    void dispose() {
      commentController.dispose();
      super.dispose();
    }

    Future<void> submitReview() async {
      final email = Session.email;

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

      if (selectedRating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select a rating.',
            ),
          ),
        );
        return;
      }

      if (commentController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a comment.',
            ),
          ),
        );
        return;
      }

      setState(() {
        isSubmitting = true;
      });

      final success = await ApiService.addReview(
        customerEmail: email,
        serviceRequestId:
            widget.serviceRequestId,
        rating: selectedRating,
        comment: commentController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Review submitted successfully.',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to submit review.',
            ),
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rate Provider'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 42,
                backgroundColor: Color(0x1A1F3A5F),
                child: Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.providerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'How was your experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) {
                    final starNumber = index + 1;

                    return IconButton(
                      onPressed: () {
                        setState(() {
                          selectedRating =
                              starNumber;
                        });
                      },
                      icon: Icon(
                        starNumber <=
                                selectedRating
                            ? Icons.star_rounded
                            : Icons
                                .star_border_rounded,
                        size: 45,
                        color: AppColors.warning,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Text(
                selectedRating == 0
                    ? 'Select a rating'
                    : '$selectedRating / 5',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Review',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: commentController,
                maxLines: 5,
                textInputAction:
                    TextInputAction.newline,
                decoration: InputDecoration(
                  hintText:
                      'Write your experience...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                      isSubmitting
                          ? null
                          : submitReview,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                        ),
                  label: Text(
                    isSubmitting
                        ? 'Submitting...'
                        : 'Submit Review',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor:
                        Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
