export 'package:original_stock/models/product_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/models/product_model.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/repositories/product_repository.dart';
import 'package:original_stock/screens/cart_screen.dart';
import 'package:original_stock/screens/notifications_screen.dart';
import 'package:original_stock/screens/search_screen.dart';
import 'package:original_stock/screens/see_all_screen.dart';
import 'package:original_stock/widgets/category_chip.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/gradient_box.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:original_stock/widgets/product_card.dart';
import 'package:original_stock/widgets/skeletons.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  List<String> _categories = [
    'All',
    'Shirts',
    'Outerwear',
    'Knitwear',
    'Shoes',
    'Jeans',
  ];
  List<ProductModel> _allProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cats = await productRepository.getCategories();
      final prods = await productRepository.getProducts();
      if (mounted) {
        setState(() {
          if (cats.isNotEmpty) _categories = cats;
          _allProducts = prods;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load products. Please check your connection.';
          _isLoading = false;
        });
      }
    }
  }

  List<ProductModel> get _filteredProducts {
    if (_selectedCategoryIndex >= _categories.length || _selectedCategoryIndex == 0) {
      return _allProducts;
    }
    final category = _categories[_selectedCategoryIndex];
    return _allProducts
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<ProviderProduct>().totalItemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.softGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),

              // Top row: Small logo + title, and Bell + Cart icon buttons
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 32.h,
                    fit: BoxFit.contain,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'Original Stock',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppText.fontFamily,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Gap(8.w),
                  // Bell button
                  CircularIconButton(
                    iconData: Icons.notifications_none_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  Gap(8.w),
                  // Cart button with badge
                  CircularIconButton(
                    icon: Image.asset(
                      'assets/icons/shopping-bag.png',
                      height: 20.r,
                      width: 20.r,
                      color: AppColors.text,
                    ),
                    badgeCount: cartCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Gap(14.h),

              // Search field + purple circular filter button
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 48.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.input),
                          border: Border.all(
                            color: AppColors.hairline,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                              size: 22.r,
                            ),
                            Gap(10.w),
                            Expanded(
                              child: Text(
                                'Explore Fashion',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.bodyMedium(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(10.w),
                  // Purple circular filter button with primaryGradient
                  CircularIconButton(
                    gradient: AppColors.primaryGradient,
                    iconColor: AppColors.white,
                    iconData: Icons.tune_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Gap(18.h),

              // Promo banner with bannerGradient and decorative concentric circles
              GradientBox(
                height: 165.h,
                width: double.infinity,
                gradient: AppColors.bannerGradient,
                borderRadius: BorderRadius.circular(AppRadius.banner),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.banner),
                  child: Stack(
                    children: [
                      // Decorative concentric circles pattern (~10% opacity)
                      Positioned(
                        right: -30.w,
                        top: 0,
                        bottom: 0,
                        width: 220.w,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 210.r,
                                height: 210.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.r,
                                height: 150.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: 90.r,
                                height: 90.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right banner image
                      Positioned(
                        right: -10.w,
                        top: 0,
                        bottom: 0,
                        width: 175.w,
                        child: Image.asset(
                          'assets/images/stylish-black-grey-hooded-jacket-with-white-removebg-preview.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.centerRight,
                        ),
                      ),

                      // Left banner content
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 12.h,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            Text(
                              'Super Sale',
                              style: TextStyle(
                                fontFamily: AppText.fontFamily,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                height: 1.1,
                              ),
                            ),
                            Gap(4.h),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white.withValues(alpha: 0.9),
                                ),
                                children: const [
                                  TextSpan(text: 'Up to '),
                                  TextSpan(
                                    text: '50%',
                                    style: TextStyle(
                                      color: AppColors.highlightPurple,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(text: ' off'),
                                ],
                              ),
                            ),
                            Gap(14.h),
                            // "Shop Now" pill button with primaryGradient
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SeeAllScreen(),
                                  ),
                                );
                              },
                              child: GradientBox(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                child: Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    fontFamily: AppText.fontFamily,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
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
              Gap(20.h),

              // Category chips row (All, Shirts, Outerwear, Knitwear, Shoes, Jeans)
              if (_isLoading && _categories.length <= 1)
                const CategoryRowSkeleton()
              else
                SizedBox(
                  height: 42.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => Gap(8.w),
                    itemBuilder: (context, index) {
                      return CategoryChip(
                        label: _categories[index],
                        isSelected: _selectedCategoryIndex == index,
                        onTap: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
              Gap(20.h),

              // "Special For You" title + "See All" link
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Special For You',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMedium(color: AppColors.text),
                    ),
                  ),
                  Gap(12.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeeAllScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: AppText.fontFamily,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(14.h),

              // Products State: Loading / Error / Empty / Grid
              if (_isLoading)
                const ProductGridSkeleton()
              else if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_off_rounded,
                          size: 48.r,
                          color: AppColors.textSecondary,
                        ),
                        Gap(12.h),
                        Text(
                          'Failed to load products',
                          style: AppText.titleSmall(),
                        ),
                        Gap(4.h),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: AppText.bodySmall(),
                        ),
                        Gap(16.h),
                        SizedBox(
                          width: 140.w,
                          child: PillButton(
                            label: 'Try Again',
                            height: 44.h,
                            onPressed: _loadData,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_filteredProducts.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 44.r,
                          color: AppColors.textSecondary,
                        ),
                        Gap(12.h),
                        Text(
                          'No products in this category',
                          style: AppText.titleSmall(),
                        ),
                        Gap(4.h),
                        Text(
                          'Try selecting another category above.',
                          style: AppText.bodySmall(),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14.w,
                    mainAxisSpacing: 18.h,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: _filteredProducts[index],
                      heroScope: 'home',
                    );
                  },
                ),
              Gap(AppSpacing.navClearance), // Clearance for floating bottom nav
            ],
          ),
        ),
      ),
    ),
  );
  }
}

// -----------------------------------------------------------------------------
// Backwards Compatibility Aliases and Existing Classes
// -----------------------------------------------------------------------------

class ThisPadding {
  static EdgeInsets get padding => EdgeInsets.symmetric(horizontal: 16.w);
}

class BackGroundProduct {
  static Color get color => AppColors.surface;
}

class BackGroundColor {
  static const Color bcgcolor = AppColors.background;
}

/// Backwards compatibility accessor for demo products
List<ProductModel> get products => MockProductRepository.demoProducts;

// Preserved classes for backwards compatibility
class AppBar extends StatelessWidget {
  const AppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 28.h),
          Gap(8.w),
          Text(
            'Original Stock',
            style: AppText.titleMedium(color: AppColors.text),
          ),
        ],
      ),
    );
  }
}

class CategoryCont extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final String text;
  final Color? fontcolor;
  final double border;

  const CategoryCont({
    super.key,
    this.width,
    this.color,
    this.height,
    required this.text,
    this.fontcolor,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryChip(
      label: text,
      isSelected: color == AppColors.primary || color == Colors.black,
      height: height,
    );
  }
}

int current = 0;
double border = 8;
const double widthcategorycont = 90;
List category = [
  "All",
  "Shirts",
  "Outerwear",
  "Knitwear",
  "Shoes",
  "Jeans",
];

class LisvviewSaparated extends StatefulWidget {
  const LisvviewSaparated({super.key});
  @override
  State<LisvviewSaparated> createState() => _LisvviewSaparatedState();
}

class _LisvviewSaparatedState extends State<LisvviewSaparated> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        separatorBuilder: (context, index) => Gap(8.w),
        itemBuilder: (context, index) {
          return CategoryChip(
            label: category[index],
            isSelected: current == index,
            onTap: () {
              setState(() {
                current = index;
              });
            },
          );
        },
      ),
    );
  }
}

class GridviewConts extends StatelessWidget {
  final bool favorate;
  const GridviewConts({super.key, required this.favorate});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 18.h,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}

class ListviewProducts extends StatelessWidget {
  const ListviewProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
