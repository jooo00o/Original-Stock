import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

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
                fit: BoxFit.fill,
                'assets/images/shoes-running-sneakers-design_849407-6889.jpg',
                height: 390.h,
              ),
            ),
            Gap(35.h),
            Text(
              'Shop the season',
              style: TextStyle(
                fontSize: 29.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            Gap(8.h),
            Text(
              "Free shipping over \$100. Easy returns within 30 days.",
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
