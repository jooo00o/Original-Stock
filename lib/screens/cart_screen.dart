import 'package:original_stock/screens/checkout_screen.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontsize = 18.sp;
    final FontWeight fontweight = FontWeight.w600;
    final color = Colors.grey[800];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: Navigator.canPop(context) ? 20.h : 100.h,
          right: 20.w,
          left: 20.w,
          top: 10.h,
        ),
        child: SizedBox(
          height: 250.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order sammery",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
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
                    "\$640.00",
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
              Gap(5.h),
              Divider(),
              Gap(5.h),
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
                    "\$640.00",
                    style: TextStyle(
                      fontSize: fontsize + 2.sp,
                      fontWeight: fontweight,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Gap(10.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return CheckoutScreen();
                      },
                    ),
                  );
                },
                child: Container(
                  height: 65.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      "Checkout . \$640",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: ThisPadding.padding,
          child: Column(
            children: [
              Row(
                children: [
                  Navigator.canPop(context)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios_new, size: 24.r),
                        )
                      : Icon(Icons.favorite, color: Colors.white, size: 24.r),
                  Spacer(),
                  Text(
                    'Cart',
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.favorite, color: Colors.white, size: 24.r),
                ],
              ),
              Gap(30.h),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 150.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.r),
                        child: Row(
                          children: [
                            Container(
                              height: 130.h,
                              width: 130.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.05.w,
                                ),
                                color: BackGroundProduct.color,
                              ),
                              child: ClipRRect(
                                child: Image.asset(
                                  height: double.infinity,
                                  'assets/images/jacket-with-hood-that-says-winter_1277670-18691-removebg-preview.png',
                                ),
                              ),
                            ),
                            Gap(10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tokyo Winter Jacket',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Size: L ,Grey',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$640,00',
                                  style: TextStyle(
                                    fontSize: 21.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.remove_circle_outline,
                                      size: 30.r,
                                      color: Colors.red,
                                    ),
                                    Gap(5.w),
                                    Text("1", style: TextStyle(fontSize: 20.sp)),
                                    Gap(5.w),
                                    Icon(
                                      Icons.add_circle_outline,
                                      size: 30.r,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Gap(10.h);
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
