import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/session.dart';
import '../../widgets/info_tile.dart';


import 'request_service_screen.dart';

//==================== Provider Profile Screen ====================

class ProviderProfileScreen extends StatefulWidget {
  final String name;
  final String location;
  final String experience;
  final String rating;
  final String serviceName;
  final String description;
  final String email;

  const ProviderProfileScreen({
    super.key,
    required this.name,
    required this.location,
    required this.experience,
    required this.rating,
    required this.serviceName,
    required this.description,
    required this.email,
  });

  @override
  State<ProviderProfileScreen> createState() =>
      _ProviderProfileScreenState();
}

class _ProviderProfileScreenState
    extends State<ProviderProfileScreen> {

  List<dynamic> services = [];
  List<dynamic> reviews = [];

  bool isLoadingServices = true;
  bool isLoadingReviews = true;

  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();

    print('================================');
    print('PROVIDER PROFILE OPENED');
    print('PROVIDER NAME: ${widget.name}');
    print('PROVIDER EMAIL: ${widget.email}');
    print('================================');

    loadProviderServices();
    loadProviderReviews();
  }

  // ==================== LOAD SERVICES ====================

  Future<void> loadProviderServices() async {
    try {
      final result = await ApiService.getProviderServices(
        email: widget.email,
      );

      if (!mounted) return;

      setState(() {
        services = result ?? [];
        isLoadingServices = false;
      });
    } catch (e) {
      print('SERVICES ERROR: $e');

      if (!mounted) return;

      setState(() {
        services = [];
        isLoadingServices = false;
      });
    }
  }

  // ==================== LOAD REVIEWS ====================

  Future<void> loadProviderReviews() async {
    print('================================');
    print('LOADING REVIEWS');
    print('EMAIL: ${widget.email}');
    print('================================');

    try {
      final result =
          await ApiService.getProviderReviews(widget.email);

      print('REVIEWS API RESULT: $result');
      print('NUMBER OF REVIEWS: ${result.length}');

      double totalRating = 0.0;

      for (final review in result) {
        print('REVIEW: $review');

        final ratingValue =
            double.tryParse(
                  review['rating']?.toString() ?? '0',
                ) ??
                0.0;

        print('RATING VALUE: $ratingValue');

        totalRating += ratingValue;
      }

      double calculatedAverage = 0.0;

      if (result.isNotEmpty) {
        calculatedAverage =
            totalRating / result.length;
      }

      print('TOTAL RATING: $totalRating');
      print('AVERAGE RATING: $calculatedAverage');

      if (!mounted) return;

      setState(() {
        reviews = result;
        averageRating = calculatedAverage;
        isLoadingReviews = false;
      });

      print('FINAL AVERAGE RATING: $averageRating');

    } catch (e) {
      print('================================');
      print('REVIEWS ERROR');
      print('$e');
      print('================================');

      if (!mounted) return;

      setState(() {
        reviews = [];
        averageRating = 0.0;
        isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ==================== PROFILE ICON ====================

            CircleAvatar(
              radius: 55,
              backgroundColor:
                  AppColors.primary.withOpacity(0.1),

              child: const Icon(
                Icons.person_rounded,
                size: 58,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            // ==================== NAME ====================

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            // ==================== SERVICE CATEGORY ====================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Text(
                widget.serviceName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ==================== RATING ====================

            if (isLoadingReviews)
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              )
            else
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 24,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    averageRating > 0
                        ? averageRating.toStringAsFixed(1)
                        : 'No ratings',

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  if (reviews.isNotEmpty) ...[
                    const SizedBox(width: 6),

                    Text(
                      '(${reviews.length})',

                      style: const TextStyle(
                        fontSize: 14,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),

            const SizedBox(height: 16),

            // ==================== LOCATION ====================

            InfoTile(
              icon: Icons.location_on_rounded,
              title: 'Location',
              subtitle: widget.location,
            ),

            // ==================== EXPERIENCE ====================

            InfoTile(
              icon: Icons.work_rounded,
              title: 'Experience',
              subtitle: widget.experience,
              iconColor: AppColors.secondary,
            ),

            // ==================== DESCRIPTION ====================

            InfoTile(
              icon: Icons.description_rounded,
              title: 'About',
              subtitle: widget.description,
              iconColor: AppColors.primary,
            ),

            const SizedBox(height: 20),

            // ==================== SERVICES ====================

            Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Services Offered',

                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (isLoadingServices)

              const Padding(
                padding: EdgeInsets.all(20),

                child: CircularProgressIndicator(),
              )

            else if (services.isEmpty)

              const Padding(
                padding: EdgeInsets.all(20),

                child: Text(
                  'No services available.',
                  style: TextStyle(
                    color:
                        AppColors.textSecondary,
                  ),
                ),
              )

            else

              Column(
                children:
                    services.map((service) {

                  final serviceName =
                      service['name']?.toString() ??
                          'Service';

                  final category =
                      service['category']?.toString() ??
                          '';

                  final description =
                      service['description']?.toString() ??
                          '';

                  final price =
                      service['price']?.toString() ??
                          '0';

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            serviceName,

                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 5),

                          if (category.isNotEmpty)
                            Text(
                              category,

                              style:
                                  const TextStyle(
                                fontSize: 13,
                                color:
                                    AppColors.secondary,
                              ),
                            ),

                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 8),

                            Text(
                              description,

                              style:
                                  const TextStyle(
                                fontSize: 13.5,
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],

                          const SizedBox(height: 10),

                          Text(
                            'Rs. $price',

                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // ==================== VERIFIED ====================

            InfoTile(
              icon: Icons.verified_rounded,
              title: 'Verified Provider',
              subtitle:
                  'Identity verification will be available later.',
              iconColor: AppColors.success,
            ),

            const SizedBox(height: 12),

            // ==================== REQUEST SERVICE ====================

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          RequestServiceScreen(
                        providerName:
                            widget.name,

                        serviceName:
                            widget.serviceName,

                        customerEmail:
                            Session.email ?? '',

                        providerEmail:
                            widget.email,
                      ),
                    ),
                  );
                },

                child: const Text(
                  'Request Service',

                  style: TextStyle(
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
}