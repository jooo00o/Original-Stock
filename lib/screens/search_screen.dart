import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/screens/product_details.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double currentsize = 0;
  List<String> recent = ["Linen shirt", "Wool coat", "Sneakers", "Cashmere"];
  List<String> popular = [
    "Outerwear",
    "Trousers",
    "knitwear",
    "learther",
    "Minimal",
  ];
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black,
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
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 30.r,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.filter_alt,
                                  size: 30.r,
                                  color: Colors.black,
                                ),
                          Spacer(),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.filter_alt, size: 30.r, color: Colors.black),
                        ],
                      ),
                      Gap(25.h),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: BackGroundProduct.color,
                              ),
                              child: TextField(
                                focusNode: searchFocusNode,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: searchFocusNode.hasFocus
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: searchFocusNode.hasFocus
                                      ? Colors.white
                                      : Colors.black,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.5.w,
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  hintText: "Search...",
                                  hintStyle: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: searchFocusNode.hasFocus
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 25.r,
                                    color: searchFocusNode.hasFocus
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Gap(10.w),
                          Container(
                            height: 50.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.filter_alt,
                                color: Colors.white,
                                size: 24.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Gap(30.h),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: Navigator.canPop(context) ? 25.h : 100.h,
                    right: 11.w,
                    left: 11.w,
                    top: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Recent searches",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Clear",
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      Gap(15.h),
                      Wrap(
                        children: List.generate(recent.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 10.w,
                              bottom: 10.h,
                            ),
                            child: Container(
                              height: 45.h,
                              width: 116.5.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(color: Color(0xffe0e0e0)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.close, size: 20.r),
                                    Text(
                                      recent[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Gap(15.h),
                      Row(
                        children: [
                          Text(
                            "Popular",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gap(15.h),
                      Wrap(
                        children: List.generate(recent.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 10.w,
                              bottom: 10.h,
                            ),
                            child: Container(
                              height: 45.h,
                              width: 116.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(color: Color(0xffe0e0e0)),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  popular[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Gap(15.h),
                      Text(
                        "Best for you",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(20.h),
                      SizedBox(
                        height: 300.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ProductDetails();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                height: 250.h,
                                width: 170.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 170.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11.r),
                                        border: Border.all(
                                          color: const Color(0xFFBDBDBD),
                                        ),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(11.r),
                                        child: Image.asset(
                                          products[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0.w,
                                        vertical: 4.0.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            products[index].name,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Text(
                                                products[index].price,
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 40.h,
                                                width: 40.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40.r),
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/icons/shopping-bag.png",
                                                    height: iconsDimentions,
                                                    width: iconsDimentions,
                                                    color: Colors.white,
                                                  ),
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
                          }),
                          separatorBuilder: ((context, index) {
                            return Gap(10.w);
                          }),
                          itemCount: products.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
