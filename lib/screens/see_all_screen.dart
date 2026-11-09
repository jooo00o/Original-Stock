import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/models/product_model.dart';
import 'package:original_stock/widgets/category_chip.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:original_stock/widgets/product_card.dart';
import 'package:original_stock/widgets/skeletons.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
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
          _errorMessage = 'Unable to load products. Please try again.';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              // Header
              Row(
                children: [
                  CircularIconButton(
                    iconData: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    'All Products',
                    style: AppText.titleMedium(color: AppColors.text),
                  ),
                  const Spacer(),
                  SizedBox(width: 44.r),
                ],
              ),
              Gap(16.h),

              // Category chips row
              SizedBox(
                height: 40.h,
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
              Gap(16.h),

              // Products State: Loading / Error / Empty / Grid
              Expanded(
                child: _isLoading
                    ? const SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: ProductGridSkeleton(itemCount: 6),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          )
                        : _filteredProducts.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 44.r,
                                      color: AppColors.textSecondary,
                                    ),
                                    Gap(12.h),
                                    Text(
                                      'No products found',
                                      style: AppText.titleSmall(),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _filteredProducts.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 14.w,
                                        mainAxisSpacing: 18.h,
                                        childAspectRatio: 0.58,
                                      ),
                                      itemBuilder: (context, index) {
                                        return ProductCard(
                                          product: _filteredProducts[index],
                                          heroScope: 'seeall',
                                        );
                                      },
                                    ),
                                    Gap(24.h),
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
