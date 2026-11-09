import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Eagle head logo
            Image.asset(
              'assets/images/logo.png',
              width: 110.w,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.local_mall_rounded,
                size: 80.r,
                color: AppColors.primary,
              ),
            ),
            Gap(20.h),
            Text(
              'Original Stock',
              style: TextStyle(
                fontFamily: AppText.fontFamily,
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
                letterSpacing: 0.5,
              ),
            ),
            Gap(6.h),
            Text(
              'Curated Menswear',
              style: TextStyle(
                fontFamily: AppText.fontFamily,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
