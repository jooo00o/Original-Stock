import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: ThisPadding.padding,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_alt, size: 30.r, color: Colors.white),
                    Spacer(),
                    Text(
                      'Wishlist',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.filter_alt, size: 30.r, color: Colors.white),
                  ],
                ),
                Gap(30.h),
                Text(
                  "6 saved items",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                Gap(20.h),
                GridviewConts(favorate: true),
                Gap(60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
