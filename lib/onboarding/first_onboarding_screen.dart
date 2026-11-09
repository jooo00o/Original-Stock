import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';

class FirstOnboardingScreen extends StatelessWidget {
  const FirstOnboardingScreen({super.key});

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
                'assets/images/portrait-handsome-smiling-stylish-young-man-model-dressed-jeans-clothes-fashion-man-wearing-sunglasses.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Gap(14.h),
        Text('For the Modern Man', style: AppText.titleLarge(fontSize: 22.sp)),
        Gap(6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Discover curated menswear pieces from a wardrobe built for longevity and presence.',
            textAlign: TextAlign.center,
            style: AppText.bodyMedium(color: AppColors.textSecondary),
          ),
        ),
        Gap(14.h),
      ],
    );
  }
}
