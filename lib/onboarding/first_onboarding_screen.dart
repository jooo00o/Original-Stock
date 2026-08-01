import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstOnboardingScreen extends StatelessWidget {
  const FirstOnboardingScreen({super.key});

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
                'assets/images/portrait-handsome-smiling-stylish-young-man-model-dressed-jeans-clothes-fashion-man-wearing-sunglasses.jpg',
                height: 390.h,
              ),
            ),
            Gap(35.h),
            Text(
              'For modern man',
              style: TextStyle(
                fontSize: 29.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            Gap(8.h),
            Text(
              "Discover curated pieces from a wardrobe built to last.",
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
