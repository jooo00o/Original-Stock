import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';

class SecondOnboardingScreen extends StatelessWidget {
  const SecondOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.banner),
              child: Image.asset(
                'assets/images/photo-1593030761757-71fae45fa0e7.avif',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Gap(14.h),
        Text(
          'Quiet Luxury, Everyday',
          style: AppText.titleLarge(fontSize: 22.sp),
        ),
        Gap(6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Premium Egyptian materials, considered cuts, and architectural silhouettes.',
            textAlign: TextAlign.center,
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
        ),
        Gap(14.h),
      ],
    );
  }
}
