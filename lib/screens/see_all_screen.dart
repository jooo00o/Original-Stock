import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: ThisPadding.padding,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, size: 30.r),
                  ),
                  Spacer(),
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.filter_alt, size: 30.r, color: Colors.white),
                ],
              ),
              Gap(30.h),
              Stack(
                alignment: AlignmentGeometry.centerRight,
                children: [
                  LisvviewSaparated(),
                  Container(
                    height: 40.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: BackGroundColor.bcgcolor,
                          offset: Offset(5.w, 0),
                          blurRadius: 10.r,
                          spreadRadius: 3.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(30.h),
              GridviewConts(favorate: true),
            ],
          ),
        ),
      ),
    );
  }
}
