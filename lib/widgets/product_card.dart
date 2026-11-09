import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_motion.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/money.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/screens/product_details.dart';
import 'package:original_stock/widgets/skeletons.dart';
import 'package:provider/provider.dart';

/// Reusable 2-column grid product card adhering to soft, modern design tokens.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final String heroScope;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.heroScope = '',
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<ProviderProduct, bool>(
      (p) => p.isProductInWishlist(product),
    );
    final hasDiscount = product.oldPrice != null;
    final heroTag =
        'product-image-${product.id.isNotEmpty ? product.id : product.name}-$heroScope';

    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.5;
    final int imageCacheWidth = (180.w * dpr).round().clamp(100, 1200);

    return RepaintBoundary(
      child: GestureDetector(
        onTap:
            onTap ??
            () {
              context.read<ProviderProduct>().selectedproduct(product);
              Navigator.push(
                context,
                productDetailsRoute(ProductDetails(heroScope: heroScope)),
              );
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image container with rounded 20, heart button & optional sale badge
          AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.image),
                color: AppColors.surface,
                border: Border.all(color: AppColors.hairline, width: 0.8),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    createRectTween: (begin, end) =>
                        MaterialRectCenterArcTween(begin: begin, end: end),
                    flightShuttleBuilder: (
                      flightContext,
                      animation,
                      flightDirection,
                      fromHeroContext,
                      toHeroContext,
                    ) {
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: kEmphasized,
                      );
                      return AnimatedBuilder(
                        animation: curvedAnimation,
                        builder: (context, child) {
                          final t = curvedAnimation.value.clamp(0.0, 1.0);
                          final currentRadius =
                              flightDirection == HeroFlightDirection.push
                                  ? 20.r + (24.r - 20.r) * t
                                  : 24.r - (24.r - 20.r) * (1.0 - t);
                          return Material(
                            type: MaterialType.transparency,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(currentRadius),
                              child: Image(
                                image: product.image.startsWith('http')
                                    ? NetworkImage(product.image)
                                        as ImageProvider
                                    : AssetImage(product.image),
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Material(
                      type: MaterialType.transparency,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.image),
                        child: product.image.startsWith('http')
                            ? Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                cacheWidth: imageCacheWidth,
                                gaplessPlayback: true,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return SkeletonBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    radius: AppRadius.image,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                              )
                            : Image.asset(
                                product.image,
                                fit: BoxFit.cover,
                                cacheWidth: imageCacheWidth,
                                gaplessPlayback: true,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                              ),
                      ),
                    ),
                  ),

                  // Sale / discount badge (optional secondary logo gold)
                  if (hasDiscount)
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Text(
                          'SALE',
                          style: TextStyle(
                            fontFamily: AppText.fontFamily,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                  // Circular white heart button on top-right
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () {
                        context.read<ProviderProduct>().toggleWishlist(product);
                      },
                      child: Container(
                        height: 34.r,
                        width: 34.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18.r,
                            color: isFavorite
                                ? AppColors.heart
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(8.h),

          // Category label (small grey)
          Text(
            product.category.isNotEmpty ? product.category : 'Original Stock',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.caption(color: AppColors.textSecondary),
          ),
          Gap(2.h),

          // Product name (bold)
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.titleSmall(color: AppColors.text),
          ),
          Gap(4.h),

          // Price row: bold price + red strikethrough old price if discount
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4.w,
                  children: [
                    Text(
                      egp(product.price),
                      style: TextStyle(
                        fontFamily: AppText.fontFamily,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    if (hasDiscount)
                      Text(
                        egp(product.oldPrice!),
                        style: TextStyle(
                          fontFamily: AppText.fontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 15.r, color: AppColors.gold),
                  Gap(2.w),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: AppText.fontFamily,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
