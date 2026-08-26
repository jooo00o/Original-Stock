import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/checkout_screen.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontsize = 18.sp;
    final FontWeight fontweight = FontWeight.w600;
    final color = Colors.grey[800];
    final cartProvider = context.watch<ProviderProduct>();
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
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
                      "Order summary",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Items (${cartProvider.totalItemCount})",
                          style: TextStyle(
                            fontSize: fontsize,
                            fontWeight: fontweight,
                            color: color,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "\$${cartProvider.subtotal.toStringAsFixed(2)}",
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
                        const Spacer(),
                        Text(
                          "\$${cartProvider.tax.toStringAsFixed(2)}",
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
                        const Spacer(),
                        Text(
                          "\$${cartProvider.deliveryCharge.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: fontsize,
                            fontWeight: fontweight,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    Gap(5.h),
                    const Divider(),
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
                        const Spacer(),
                        Text(
                          "\$${cartProvider.totalPayment.toStringAsFixed(2)}",
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
                              return const CheckoutScreen();
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
                            "Checkout . \$${cartProvider.totalPayment.toStringAsFixed(2)}",
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
                  const Spacer(),
                  Text(
                    'Cart',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.favorite, color: Colors.white, size: 24.r),
                ],
              ),
              Gap(30.h),
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 80.r,
                              color: Colors.grey[400],
                            ),
                            Gap(15.h),
                            Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Gap(5.h),
                            Text(
                              'Add items to start shopping',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            height: 145.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.r),
                              child: Row(
                                children: [
                                  Container(
                                    height: 120.h,
                                    width: 105.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: Colors.grey[100],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child:
                                          item.product.image.startsWith(
                                                'http://',
                                              ) ||
                                              item.product.image.startsWith(
                                                'https://',
                                              )
                                          ? Image.network(
                                              item.product.image,
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.image,
                                                    size: 40.r,
                                                    color: Colors.grey,
                                                  ),
                                            )
                                          : Image.asset(
                                              item.product.image,
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Icon(
                                                    Icons.image,
                                                    size: 40.r,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                    ),
                                  ),
                                  Gap(12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ORIGINAL STOCK",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey[400],
                                                letterSpacing: 1.2,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                cartProvider.removeFromCart(
                                                  item,
                                                );
                                              },
                                              child: Icon(
                                                Icons.delete_outline_rounded,
                                                size: 22.r,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          item.product.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'Size ${item.size}',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '\$${item.totalPrice.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              height: 42.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25.r),
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                  width: 1.w,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartProvider
                                                          .decrementQuantity(
                                                            item,
                                                          );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                          ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 18.r,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${item.quantity}",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Gap(6.w),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartProvider
                                                          .incrementQuantity(
                                                            item,
                                                          );
                                                    },
                                                    child: Container(
                                                      height: 32.h,
                                                      width: 32.w,
                                                      margin: EdgeInsets.only(
                                                        right: 4.w,
                                                        top: 3.h,
                                                        bottom: 3.h,
                                                        left: 2.w,
                                                      ),
                                                      decoration:
                                                          const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 18.r,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Gap(12.h);
                        },
                        itemCount: cartItems.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
