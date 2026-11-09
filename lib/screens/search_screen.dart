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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<ProductModel> _results = [];
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _recentSearches = [
    'Wool coat',
    'Oversized jacket',
    'Cotton shirt',
    'Running sneakers',
  ];

  List<String> _popularCategories = [
    'Outerwear',
    'Shirts',
    'Knitwear',
    'Shoes',
    'Jeans',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cats = await productRepository.getCategories();
      final prods = await productRepository.getProducts();
      if (mounted) {
        setState(() {
          _popularCategories = cats.where((c) => c != 'All').toList();
          _results = prods;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load catalog. Please check connection.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _executeSearch(String query) async {
    setState(() {
      _searchQuery = query;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await productRepository.search(query);
      if (mounted) {
        setState(() {
          _results = res;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Search failed. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchQuery.trim().isNotEmpty;
    final canGoBack = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              // Search input row
              Row(
                children: [
                  if (canGoBack) ...[
                    CircularIconButton(
                      iconData: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    Gap(10.w),
                  ],
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.input),
                        border: Border.all(color: AppColors.hairline, width: 1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          fontFamily: AppText.fontFamily,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                        onChanged: (val) {
                          _executeSearch(val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Explore Fashion...',
                          hintStyle: AppText.bodyMedium(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: AppColors.textSecondary,
                            size: 22.r,
                          ),
                          suffixIcon: isSearching
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _executeSearch('');
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: AppColors.textSecondary,
                                    size: 18.r,
                                  ),
                                )
                              : null,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ),
                  Gap(10.w),
                  CircularIconButton(
                    gradient: AppColors.primaryGradient,
                    iconColor: AppColors.white,
                    iconData: Icons.tune_rounded,
                    onTap: () {
                      // Filter action
                    },
                  ),
                ],
              ),
              Gap(16.h),

              // Search Suggestions (shown when query is empty)
              if (!isSearching) ...[
                Text(
                  'Recent searches',
                  style: AppText.titleSmall(fontSize: 15.sp),
                ),
                Gap(10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _recentSearches.map((term) {
                    return CategoryChip(
                      label: term,
                      isSelected: false,
                      onTap: () {
                        _searchController.text = term;
                        _executeSearch(term);
                      },
                    );
                  }).toList(),
                ),
                Gap(20.h),
                Text(
                  'Popular categories',
                  style: AppText.titleSmall(fontSize: 15.sp),
                ),
                Gap(10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _popularCategories.map((cat) {
                    return CategoryChip(
                      label: cat,
                      isSelected: false,
                      onTap: () {
                        _searchController.text = cat;
                        _executeSearch(cat);
                      },
                    );
                  }).toList(),
                ),
                Gap(20.h),
                Text(
                  'All items',
                  style: AppText.titleSmall(fontSize: 15.sp),
                ),
                Gap(10.h),
              ] else ...[
                Text(
                  'Results (${_results.length})',
                  style: AppText.titleSmall(fontSize: 15.sp),
                ),
                Gap(10.h),
              ],

              // Results View: Loading / Error / Empty / Grid
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
                                  'Search failed',
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
                                    onPressed: () =>
                                        _executeSearch(_searchQuery),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _results.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 48.r,
                                      color: AppColors.textSecondary,
                                    ),
                                    Gap(12.h),
                                    Text(
                                      'No matching pieces found',
                                      style: AppText.titleSmall(),
                                    ),
                                    Gap(4.h),
                                    Text(
                                      'Try checking spelling or search for categories',
                                      style: AppText.bodySmall(),
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
                                      itemCount: _results.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 14.w,
                                        mainAxisSpacing: 18.h,
                                        childAspectRatio: 0.58,
                                      ),
                                      itemBuilder: (context, index) {
                                        return ProductCard(
                                          product: _results[index],
                                          heroScope: 'search',
                                        );
                                      },
                                    ),
                                    Gap(AppSpacing.navClearance),
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
