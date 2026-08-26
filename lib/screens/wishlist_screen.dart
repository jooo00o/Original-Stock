import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/home_screen.dart' hide AppBar;
import 'package:original_stock/screens/product_details.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderProduct>();
    final wishlist = provider.wishlist;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: ThisPadding.padding,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_alt, size: 30.r, color: Colors.white),
                    const Spacer(),
                    Text(
                      'Wishlist',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.filter_alt, size: 30.r, color: Colors.white),
                  ],
                ),
                Gap(30.h),
                Text(
                  "${provider.wishlistCount} ${provider.wishlistCount == 1 ? 'saved item' : 'saved items'}",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                Gap(20.h),
                wishlist.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Gap(60.h),
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 80.r,
                              color: Colors.grey[400],
                            ),
                            Gap(15.h),
                            Text(
                              'Your wishlist is empty',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            Gap(5.h),
                            Text(
                              'Save items you like to view them later',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: wishlist.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 20.h,
                          childAspectRatio: 0.510,
                        ),
                        itemBuilder: (context, index) {
                          final product = wishlist[index];
                          return GestureDetector(
                            onTap: () {
                              context.read<ProviderProduct>().selectedproduct(
                                product,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const ProductDetails();
                                  },
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          11.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFBDBDBD),
                                        ),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          11.r,
                                        ),
                                        child:
                                            product.image.startsWith(
                                                  'http://',
                                                ) ||
                                                product.image.startsWith(
                                                  'https://',
                                                )
                                            ? Image.network(
                                                product.image,
                                                fit: BoxFit.fill,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons.broken_image,
                                                      size: 40.r,
                                                    ),
                                              )
                                            : Image.asset(
                                                product.image,
                                                fit: BoxFit.fill,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons.broken_image,
                                                      size: 40.r,
                                                    ),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.h,
                                      right: 10.w,
                                      child: GestureDetector(
                                        onTap: () {
                                          context
                                              .read<ProviderProduct>()
                                              .toggleWishlist(product);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.r),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 20.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Gap(5.h),
                                Text(
                                  'Original Stock',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 17.7.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Text(
                                      product.price,
                                      style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 20.r,
                                    ),
                                    Text(
                                      product.rating,
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                Gap(60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
