import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/screens/order_confirmed.dart';
import 'package:original_stock/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontsize = 18.sp;
    final FontWeight fontweight = FontWeight.w600;
    final color = Colors.grey[800];
    final product = context.watch<ProviderProduct>().selectedProduct;
    return Scaffold(
      backgroundColor: BackGroundProduct.color,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 20.h,
          right: 20.w,
          left: 20.w,
          top: 10.h,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OrderConfirmed();
                },
              ),
            );
          },
          child: Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(35.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: Center(
                child: Text(
                  "Palce order",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ThisPadding.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new, size: 24.r),
                    ),
                    Spacer(),
                    Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.favorite, color: BackGroundProduct.color, size: 24.r),
                  ],
                ),
                Gap(30.h),
                Text(
                  "Your Name",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20.r),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                Text(
                  "Your Phone",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20.r),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your phone",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                Text(
                  "Your Address",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20.r),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                Text(
                  "Your Email",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10.h),
                Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20.r),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                Container(
                  height: 40.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: Text(
                      "Defult Data",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Gap(20.h),
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey[500]!),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order sammery",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Total Items",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                            Spacer(),
                            Text(
                              product!.price,
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Tax",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "\$4.50",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Delivery Charge",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "\$00.00",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              "Total Payment:",
                              style: TextStyle(
                                fontSize: fontsize + 2.sp,
                                fontWeight: fontweight,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              product.price,
                              style: TextStyle(
                                fontSize: fontsize + 2.sp,
                                fontWeight: fontweight,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
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
