import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondOnboardingScreen extends StatelessWidget {
  const SecondOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(15.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: Image.asset(
                fit: BoxFit.fitHeight,
                'assets/images/photo-1593030761757-71fae45fa0e7.avif',
                height: 390.h,
              ),
            ),
            Gap(35.h),
            Text(
              'Quiet luxury, every day',
              style: TextStyle(
                fontSize: 29.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            Gap(8.h),
            Text(
              "Premium materials, considered cuts, timeless silhouettes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.5.sp,
                fontFamily: "Cairo",
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
