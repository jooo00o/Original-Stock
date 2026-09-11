import 'package:original_stock/screens/notifications_screen.dart';
import 'package:original_stock/screens/product_details.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/screens/see_all_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ScrollController _scrollController = ScrollController();
  // final ApiService _apiService = ApiService();

  // List<ProductModel> _products = [];
  // bool _isFirstLoading = true;
  // bool _isLoadingMore = false;
  // bool _hasMore = true;
  // int _page = 1;
  // String? _errorMessage;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadProducts();
  //   _scrollController.addListener(_onScroll);
  // }

  // @override
  // void dispose() {
  //   _scrollController.removeListener(_onScroll);
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  // void _onScroll() {
  //   if (!_scrollController.hasClients || _isLoadingMore || !_hasMore) return;

  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;

  //   if (currentScroll >= maxScroll - 250) {
  //     _loadProducts();
  //   }
  // }
  // Future<void> _loadProducts() async {
  //   if (_isLoadingMore && !_isFirstLoading) return;
  //   setState(() {
  //     _isLoadingMore = true;
  //     if (_isFirstLoading) {
  //       _isFirstLoading = false;
  //     }
  //   });
  //   try {
  //     final newProducts = await _apiService.fetchProducts(page: _page);
  //     if (!mounted) return;
  //     setState(() {
  //       if (_page == 1) {
  //         _products = newProducts;
  //       } else {
  //         _products.addAll(newProducts);
  //       }
  //       _hasMore = newProducts.isNotEmpty;
  //       _page += 1;
  //       _isLoadingMore = false;
  //       _errorMessage = null;
  //     });
  //   } catch (error) {
  //     if (!mounted) return;
  //     setState(() {
  //       _isLoadingMore = false;
  //       _errorMessage = error.toString();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor.bcgcolor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          // controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: ThisPadding.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(),
                Container(
                  height: 200.h,
                  width: double.infinity,
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          fit: BoxFit.fitWidth,
                          'assets/images/nimble-made-7RIMS-NMsbc-unsplash.jpg',
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 40.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 35.r,
                                    spreadRadius: 15.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: 10.w,
                            left: 10.w,
                            bottom: 10.h,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Discover \nSummer Collection',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  letterSpacing: 1,
                                  wordSpacing: -5,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "CourierPrime",
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 40.h,
                                width: 115.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'Shop Now',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(20.h),
                Row(
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 23.sp,
                        wordSpacing: -5,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "CourierPrime",
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SeeAllScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(10.h),
                SizedBox(height: 140.h, child: ListviewProducts()),
                Gap(10.h),
                Text(
                  'Top Product',
                  style: TextStyle(
                    fontSize: 23.sp,
                    wordSpacing: -5,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "CourierPrime",
                  ),
                ),
                Gap(10.h),
                GridviewConts(favorate: false),
                // if (_isLoadingMore)
                //   Padding(
                //     padding: EdgeInsets.symmetric(vertical: 16.h),
                //     child: const Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //   ),
                // if (!_hasMore && _products.isNotEmpty)
                //   Padding(
                //     padding: EdgeInsets.symmetric(vertical: 10.h),
                //     child: Center(
                //       child: Text(
                //         'لا توجد منتجات أكثر',
                //         style: TextStyle(
                //           color: Colors.grey,
                //           fontSize: 14.sp,
                //         ),
                //       ),
                //     ),
                //   ),
                Gap(60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});
  final double iconsize = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: ThisPadding.padding,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return NotificationsScreen();
                      },
                    ),
                  );
                },
                child: Icon(Icons.notifications, size: iconsize.r),
              ),
              Spacer(),
              Text(
                'Original Stock',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SearchScreen();
                      },
                    ),
                  );
                },
                child: Icon(Icons.search, size: iconsize.r),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class CategoryCont extends StatefulWidget {
  const CategoryCont({
    super.key,
    this.width,
    this.color,
    this.height,
    required this.text,
    this.fontcolor,
    required this.border,
  });
  final double? height;
  final double? width;
  final Color? color;
  final String text;
  final Color? fontcolor;
  final double border;

  @override
  State<CategoryCont> createState() => _CategoryContState();
}

class _CategoryContState extends State<CategoryCont> {
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.border.r),
          color: widget.color,
          border: Border.all(color: Colors.black, width: 0.15),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: fontSize.sp,
                color: widget.fontcolor,
                letterSpacing: -0.5,
                fontFamily: "CourierPrime",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThisPadding {
  static EdgeInsets get padding => EdgeInsets.symmetric(horizontal: 11.w);
}

class BackGroundProduct {
  static final color = Colors.grey[100];
}

class BackGroundColor {
  static const bcgcolor = Colors.white;
}

class LisvviewSaparated extends StatefulWidget {
  const LisvviewSaparated({super.key});

  @override
  State<LisvviewSaparated> createState() => _LisvviewSaparatedState();
}

int current = 0;
double border = 8;
final double widthcategorycont = 90;

List category = [
  "All",
  "Shirts",
  "Pants",
  "Blazers",
  "T-shirts",
  "Glasses",
  "Perfums",
];

class _LisvviewSaparatedState extends State<LisvviewSaparated> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
            },
            child: CategoryCont(
              color: current == index ? Colors.black : Colors.white,
              text: category[index],
              fontcolor: current == index ? Colors.white : Colors.black,
              border: index == 0 ? border + 2 : border,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 5.w);
        },
        itemCount: category.length,
      ),
    );
  }
}

class GridviewConts extends StatelessWidget {
  const GridviewConts({super.key, required this.favorate});
  final bool favorate;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 0.520,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            context.read<ProviderProduct>().selectedproduct(product);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProductDetails();
                },
              ),
            );
          },
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.r),
                        border: Border.all(color: const Color(0xFFBDBDBD)),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.r),
                        child: Image.asset(
                          product.image,
                          fit: BoxFit.fill,
                          // loadingBuilder: (context, child, loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return const Center(
                          //     child: CircularProgressIndicator(strokeWidth: 2),
                          //   );
                          // },
                          // errorBuilder: (context, error, stackTrace) =>
                          //     Icon(Icons.broken_image, size: 40.r),
                        ),
                      ),
                    ),
                    if (favorate)
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.grey[700],
                          size: 24.r,
                        ),
                      ),
                  ],
                ),
                Gap(5),
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
                Divider(),
                Row(
                  children: [
                    Text(
                      product.price,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.star, color: Colors.orange, size: 20.r),
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
          ),
        );
      },
    );
  }
}

class ListviewProducts extends StatelessWidget {
  const ListviewProducts({super.key});

  @override
  Widget build(BuildContext context) {
    List productsData = [
      {
        "img":
            "assets/images/vintageinspired-outerwear-designs_1104763-41888.jpg",
        "name": "Outerwear",
      },
      {
        "img":
            "assets/images/three-t-shirts-with-mountain-scene-them-are-hanging-wall-generative-ai_958098-68503.jpg",
        "name": "Shirts",
      },
      {
        "img":
            "assets/images/white-isolated-male-sweater-transparent-background_410516-125527.jpg",
        "name": "knitwear",
      },
      {
        "img": "assets/images/shoes-running-sneakers-design_849407-6889.jpg",
        "name": "Shoes",
      },
      {
        "img": "assets/images/fashionable-pants-isolated_23-2151336726.jpg",
        "name": "Jeans",
      },
    ];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: Image.asset(productsData[index]["img"]),
                ),
              ),
            ),
            Gap(5.h),
            Text(
              productsData[index]["name"],
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Gap(15.w);
      },
      itemCount: productsData.length,
    );
  }
}

List<ProductModel> products = [
  ProductModel(
    name: "Oversized Wool",
    image:
        "assets/images/686506127_18133742785562861_5213842607967549061_n.jpg",
    price: "EGP450",
    rating: "4.8",
  ),
  ProductModel(
    name: "Red t-shirt",
    image:
        "assets/images/696679803_18133742905562861_8782142470978230832_n.jpg",
    price: "EGP220",
    rating: "4.0",
  ),
  ProductModel(
    name: "Tokyo Winter Jacket",
    image:
        "assets/images/703796768_18133742803562861_1683141948809483400_n.jpg",
    price: "EGP160",
    rating: "4.2",
  ),
  ProductModel(
    name: "Tokyo Winter Jacket",
    image:
        "assets/images/705968716_18133742740562861_1785207526640979999_n.jpg",
    price: "EGP390",
    rating: "4.2",
  ),
];

class ProductModel {
  final String name;
  final String image;
  final String price;
  final String rating;
  ProductModel({
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
  });
}

// class ProductModel {
//   final int id;
//   final String name;
//   final String image;
//   final String price;
//   final String? originalPrice;
//   final bool isOffer;
//   final String rating;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.price,
//     required this.isOffer,
//     required this.rating,
//     this.originalPrice,
//   });
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     final num priceValue = json['discounted_price'] ?? json['price'] ?? 0;
//     final bool offer = json['is_offer'] ?? false;

//     return ProductModel(
//       id: json['id'],
//       name: json['name'],
//       image: json['cover_image'],
//       price: 'EGP $priceValue',
//       originalPrice: offer ? 'EGP ${json['price']}' : null,
//       isOffer: offer,
//       rating: '4.5',
//     );
//   }
// }
