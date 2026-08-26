import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/cart_screen.dart';
import 'package:original_stock/screens/checkout_screen.dart';
import 'package:original_stock/screens/home_screen.dart' hide AppBar;
import 'package:original_stock/main.dart';
import 'package:original_stock/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

List<String> size = ["M", "L", "XL", "XXL"];
List<Color> colorCont = [Colors.black, Colors.grey, Colors.grey[300]!];

class _ProductDetailsState extends State<ProductDetails> {
  int currentsize = 0;
  int checkicon = 0;
  bool isBlack = true;
  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProviderProduct>().selectedProduct;
    if (product == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Product Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: const Center(child: Text('No product selected')),
      );
    }
    return Scaffold(
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5.w),
            color: backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              right: 11.w,
              left: 11.w,
              top: 10.h,
              bottom: 30.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final colorNames = ["Black", "Grey", "Light Grey"];
                      final selectedColor = checkicon < colorNames.length
                          ? colorNames[checkicon]
                          : "Default";
                      final selectedSize = size[currentsize];
                      context.read<ProviderProduct>().addToCart(
                        product,
                        selectedSize,
                        selectedColor,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${product.name} added to cart!"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const CartScreen();
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
                          "Add To Cart",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(5.w),
                Expanded(
                  child: GestureDetector(
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
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          "Buy Now",
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                          ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.05.w),
                      color: BackGroundProduct.color,
                    ),
                    child: ClipRRect(
                      child:
                          product.image.startsWith('http://') ||
                              product.image.startsWith('https://')
                          ? Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.broken_image,
                                    size: 50.r,
                                    color: Colors.grey,
                                  ),
                            )
                          : Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.broken_image,
                                    size: 50.r,
                                    color: Colors.grey,
                                  ),
                            ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(10.r),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 28.r,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Spacer(),
                      Builder(
                        builder: (context) {
                          final isInWishlist = context
                              .watch<ProviderProduct>()
                              .isProductInWishlist(product);
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<ProviderProduct>()
                                  .toggleWishlist(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isInWishlist
                                        ? "${product.name} removed from wishlist"
                                        : "${product.name} added to wishlist!",
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(12.r),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(10.r),
                              child: Icon(
                                Icons.favorite,
                                size: 28.r,
                                color: isInWishlist ? Colors.red : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 20.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.black,
                          ),
                        ),
                        Gap(5.w),
                        Container(
                          height: 10.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Gap(5.w),
                        Container(
                          height: 10.h,
                          width: 10.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: ThisPadding.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(10.h),
                    Row(
                      children: [
                        Text(
                          'ORIGINAL STOCK',
                          style: TextStyle(
                            fontSize: 14.sp,
                            letterSpacing: 3,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700,
                            fontFamily: "CourierPrime",
                          ),
                        ),
                        Spacer(),
                        Text(
                          product.price,
                          style: TextStyle(
                            fontSize: 24.sp,
                            letterSpacing: -1,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 25.sp,
                        letterSpacing: -1,
                        wordSpacing: 0,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Gap(10.h),
                    Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(10.h),
                    SizedBox(
                      height: 50.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentsize = index;
                              });
                            },
                            child: Container(
                              width: 80.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: currentsize == index
                                    ? Colors.black
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.15.w,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  size[index],
                                  style: TextStyle(
                                    color: currentsize == index
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Gap(10.w);
                        },
                        itemCount: size.length,
                      ),
                    ),
                    Gap(15.h),
                    Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(10.h),
                    SizedBox(
                      height: 52.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                checkicon = index;
                              });
                            },
                            child: checkicon == index
                                ? Center(
                                    child: Container(
                                      height: 52.h,
                                      width: 52.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          25.r,
                                        ),
                                        color: Colors.black,
                                      ),
                                      child: Center(
                                        child: Container(
                                          height: 50.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              25.r,
                                            ),
                                            color: colorCont[index],
                                          ),
                                          child: Center(
                                            child: checkicon == index
                                                ? Text(
                                                    "√",
                                                    style: TextStyle(
                                                      color: checkicon == 0
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 16.sp,
                                                    ),
                                                  )
                                                : Text(""),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 50.h,
                                      width: 50.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(
                                          25.r,
                                        ),
                                        color: colorCont[index],
                                      ),
                                      child: Center(
                                        child: checkicon == index
                                            ? Text(
                                                "√",
                                                style: TextStyle(
                                                  color: checkicon == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 16.sp,
                                                ),
                                              )
                                            : Text(""),
                                      ),
                                    ),
                                  ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Gap(10.w);
                        },
                        itemCount: colorCont.length,
                      ),
                    ),
                    Gap(20.h),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.w),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          top: 10.h,
                          bottom: 10.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(10.h),
                            Text(
                              "The North Face's Tokyo Winter Jacket blends iconic outdoor heritage with a bold, ",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
