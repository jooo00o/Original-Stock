import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderConfirmed extends StatefulWidget {
  const OrderConfirmed({super.key});

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  @override
  Widget build(BuildContext context) {
    final double fontsize = 15.5.sp;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 11.w, left: 11.w, top: 20.h),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 150.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(80.r),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white, size: 80.r),
                  ),
                ),
                Gap(20.h),
                Text(
                  "Order Confirmed",
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Text(
                  "Thank you for shopping with Original Stock.\n We've sent a confirmation to your phone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(40.h),
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              "ORDER NUMBER",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "#OS-10298",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "ESTIMATED DELIVERY",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "18-22 Jun 2026",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "TOTAL",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "\$680",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    selectedPage = 0;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        "Back to Home",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
