import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';

class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

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
                'assets/images/shoes-running-sneakers-design_849407-6889.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Gap(14.h),
        Text(
          'Shop The Season',
          style: AppText.titleLarge(fontSize: 22.sp),
        ),
        Gap(6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Free shipping across Egypt on orders over EGP 1,000. Easy exchanges within 14 days.',
            textAlign: TextAlign.center,
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
        ),
        Gap(14.h),
      ],
    );
  }
}
