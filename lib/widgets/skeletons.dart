import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer wrapper using Original Stock token palette.
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFECECEF),
      highlightColor: const Color(0xFFF8F8FA),
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}

/// Generic rounded grey skeleton box.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final BoxShape shape;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFECECEF),
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(radius ?? 8.r),
        ),
      ),
    );
  }
}

/// Skeleton matching the dimensions and layout of [ProductCard].
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton (rounded 20)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFECECEF),
                borderRadius: BorderRadius.circular(AppRadius.image),
              ),
            ),
          ),
          Gap(8.h),
          // Category line
          Container(
            height: 11.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: const Color(0xFFECECEF),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Gap(6.h),
          // Product name line
          Container(
            height: 14.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: const Color(0xFFECECEF),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Gap(6.h),
          // Price line
          Container(
            height: 15.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFECECEF),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2-column grid of [ProductCardSkeleton] matching catalog layout.
class ProductGridSkeleton extends StatelessWidget {
  final int itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ProductGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 18.h,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) => const ProductCardSkeleton(),
    );
  }
}

/// Horizontal list of category pills skeleton.
class CategoryRowSkeleton extends StatelessWidget {
  const CategoryRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final widths = [56.w, 72.w, 90.w, 80.w, 70.w];
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widths.length,
        separatorBuilder: (context, index) => Gap(8.w),
        itemBuilder: (context, index) {
          return AppShimmer(
            child: Container(
              height: 40.h,
              width: widths[index],
              decoration: BoxDecoration(
                color: const Color(0xFFECECEF),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Promo banner skeleton with rounded 24 container.
class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: 165.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFECECEF),
          borderRadius: BorderRadius.circular(AppRadius.banner),
        ),
      ),
    );
  }
}

/// Skeleton representing an order history tile.
class OrderTileSkeleton extends StatelessWidget {
  const OrderTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40.r,
                  width: 40.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFECECEF),
                    shape: BoxShape.circle,
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEF),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      Gap(4.h),
                      Container(
                        height: 11.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEF),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24.h,
                  width: 64.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEF),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ],
            ),
            Gap(12.h),
            const Divider(height: 1, color: AppColors.hairline),
            Gap(10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEF),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  height: 14.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECECEF),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full product details skeleton (big image, thumbnails, title, sizes, description).
class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                height: 380.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFECECEF),
                  borderRadius: BorderRadius.circular(AppRadius.banner),
                ),
              ),
            ),
            Gap(10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Container(
                      height: 52.r,
                      width: 52.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFECECEF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gap(20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECECEF),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          Gap(6.h),
                          Container(
                            height: 22.h,
                            width: 170.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECECEF),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 22.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECECEF),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  Gap(24.h),
                  Container(
                    height: 14.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECECEF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Gap(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => Container(
                        height: 48.r,
                        width: 48.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFECECEF),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Gap(24.h),
                  Container(
                    height: 14.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECECEF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Gap(8.h),
                  Container(
                    height: 14.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECECEF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  Gap(6.h),
                  Container(
                    height: 14.h,
                    width: 240.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECECEF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
