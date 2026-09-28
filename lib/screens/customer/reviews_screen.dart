import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  final String providerEmail;

  const ReviewsScreen({
    super.key,
    required this.providerEmail,
  });

  @override
  State<ReviewsScreen> createState() =>
      _ReviewsScreenState();
}

class _ReviewsScreenState
    extends State<ReviewsScreen> {

  List<dynamic> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReviews();
  }

  Future<void> loadReviews() async {
    try {
      final result =
          await ApiService.getProviderReviews(
        widget.providerEmail,
      );

      if (!mounted) return;

      setState(() {
        reviews = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to load reviews.',
          ),
        ),
      );
    }
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) {
          return Icon(
            index < rating
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            color: AppColors.warning,
            size: 20,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : reviews.isEmpty
              ? RefreshIndicator(
                  onRefresh: loadReviews,
                  child: ListView(
                    children: const [
                      SizedBox(height: 180),
                      Center(
                        child: Text(
                          'No reviews yet.',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadReviews,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: reviews.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final review =
                          reviews[index];

                      final customer =
                          review['customer'];

                      final customerName =
                          customer?['name']
                                  ?.toString() ??
                              'Customer';

                      final rating =
                          int.tryParse(
                                review['rating']
                                    .toString(),
                              ) ??
                              0;

                      final comment =
                          review['comment']
                                  ?.toString() ??
                              '';

                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                        AppColors.primary
                                            .withValues(
                                      alpha: 0.1,
                                    ),
                                    child: const Icon(
                                      Icons
                                          .person_rounded,
                                      color:
                                          AppColors.primary,
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
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              buildStars(rating),

                              const SizedBox(height: 10),

                              if (comment.isNotEmpty)
                                Text(
                                  comment,
                                  style:
                                      const TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                    color: AppColors
                                        .textSecondary,
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
}