import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/widgets/pill_button.dart';

/// Clean immutable data model representing an onboarding slide.
class OnboardingItem {
  final String title;
  final String description;
  final String image;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}

/// Unified, high-performance page widget for an onboarding slide.
/// Uses downscaled decoding bounds (cacheWidth) and gapless playback
/// for instant image rendering without main-thread decode stutter.
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final double pixelRatio =
        MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final int targetCacheWidth =
        (380.w * pixelRatio).round().clamp(400, 1080);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.banner),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                cacheWidth: targetCacheWidth,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 64.r,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
        Gap(14.h),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: AppText.titleLarge(fontSize: 22.sp),
        ),
        Gap(6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            item.description,
            textAlign: TextAlign.center,
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
        ),
        Gap(14.h),
      ],
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  /// The list of default onboarding items. Exposed publicly so Splash / App
  /// can pre-cache images ahead of time.
  static const List<OnboardingItem> defaultItems = [
    OnboardingItem(
      title: 'For the Modern Man',
      description:
          'Discover curated menswear pieces from a wardrobe built for longevity and presence.',
      image:
          'assets/images/portrait-handsome-smiling-stylish-young-man-model-dressed-jeans-clothes-fashion-man-wearing-sunglasses.jpg',
    ),
    OnboardingItem(
      title: 'Quiet Luxury, Everyday',
      description:
          'Premium Egyptian materials, considered cuts, and architectural silhouettes.',
      image: 'assets/images/photo-1593030761757-71fae45fa0e7.jpg',
    ),
    OnboardingItem(
      title: 'Shop The Season',
      description:
          'Free shipping across Egypt on orders over EGP 1,000. Easy exchanges within 14 days.',
      image: 'assets/images/shoes-running-sneakers-design_849407-6889.jpg',
    ),
  ];

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selecredOnboard = 0;
  final PageController pageController = PageController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm up the image cache for all onboarding slides immediately
    for (final item in OnboardingScreen.defaultItems) {
      precacheImage(AssetImage(item.image), context);
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = OnboardingScreen.defaultItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Skip button
              TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily: AppText.fontFamily,
                    color: AppColors.textSecondary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Page View builder for fast lazy loading
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  onPageChanged: (value) {
                    setState(() {
                      selecredOnboard = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(item: items[index]);
                  },
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(items.length, (index) {
                  final isActive = selecredOnboard == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 6.h,
                    width: isActive ? 24.w : 6.w,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.hairline,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }),
              ),
              Gap(32.h),

              // Next / Get Started button (Pill height 54, purple fill)
              PillButton(
                label: selecredOnboard == items.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: () {
                  if (selecredOnboard == items.length - 1) {
                    _finishOnboarding();
                  } else {
                    pageController.animateToPage(
                      selecredOnboard + 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  }
                },
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Preserved for backwards compatibility
class CustomIndicator extends StatelessWidget {
  final bool active;
  const CustomIndicator({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 6.h,
      width: active ? 24.w : 6.w,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.hairline,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}
