import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/onboarding/first_onboarding_screen.dart';
import 'package:original_stock/onboarding/second_onboarding_screen.dart';
import 'package:original_stock/onboarding/third_onboarding_screen.dart';
import 'package:original_stock/widgets/pill_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selecredOnboard = 0;
  final PageController pageController = PageController();

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

              // Page View
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      selecredOnboard = value;
                    });
                  },
                  children: const [
                    FirstOnboardingScreen(),
                    SecondOnboardingScreen(),
                    ThirdOnboardingScreen(),
                  ],
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
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
                label: selecredOnboard == 2 ? 'Get Started' : 'Next',
                onPressed: () {
                  if (selecredOnboard == 2) {
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
