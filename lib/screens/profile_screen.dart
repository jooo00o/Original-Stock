import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> lastcontnames = [
      "My orders",
      "Wishlist",
      "My reviews",
      "Followed Brands",
      "Notifications",
      "Address Book",
    ];
    double width = 100.h;
    return Scaffold(
      backgroundColor: BackGroundColor.bcgcolor,
      body: SafeArea(
        child: Padding(
          padding: ThisPadding.padding,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),
                Gap(20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Youssef Hany",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "youssef@example.com",
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            Text("01234567890", style: TextStyle(fontSize: 16.sp)),
                          ],
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 17.w,
                              vertical: 10.h,
                            ),
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(20.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "12",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "ORDERS",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: Container(
                        height: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "6",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(10.h),
                              Text(
                                "WISHLIST",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(10.w),
                    Expanded(
                      child: Container(
                        height: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "4",
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(10.h),
                              Text(
                                "REVIEWS",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lastcontnames.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 13.h,
                        ),
                        child: Row(
                          children: [
                            Text(
                              lastcontnames[index],
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, size: 20.r),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.grey),
                  ),
                ),
                Gap(100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
