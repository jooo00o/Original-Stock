import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/money.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/checkout_screen.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:original_stock/widgets/skeletons.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<ProviderProduct>();
    final cartItems = cartProvider.cartItems;
    final isRootTab = !Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Navigation / Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  if (!isRootTab)
                    CircularIconButton(
                      iconData: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    )
                  else
                    SizedBox(width: 44.r),
                  const Spacer(),
                  Text(
                    'Shopping Bag',
                    style: AppText.titleMedium(color: AppColors.text),
                  ),
                  const Spacer(),
                  if (cartItems.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.card),
                            ),
                            title: Text(
                              'Clear Bag?',
                              style: AppText.titleSmall(),
                            ),
                            content: Text(
                              'Are you sure you want to remove all items from your bag?',
                              style: AppText.bodyMedium(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'Cancel',
                                  style: AppText.bodyMedium(),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  cartProvider.clearCart();
                                },
                                child: Text(
                                  'Clear',
                                  style: AppText.bodyMedium(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontFamily: AppText.fontFamily,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    )
                  else
                    SizedBox(width: 44.r),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 90.r,
                            width: 90.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 42.r,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            'Your bag is empty',
                            style: AppText.titleMedium(color: AppColors.text),
                          ),
                          Gap(6.h),
                          Text(
                            'Explore our new arrivals and add your favorite pieces.',
                            textAlign: TextAlign.center,
                            style: AppText.bodyMedium(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Gap(28.h),
                          SizedBox(
                            width: 180.w,
                            child: PillButton(
                              label: 'Explore Fashion',
                              height: 48.h,
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  mainNavController.goToTab(0);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      itemCount: cartItems.length,
                      separatorBuilder: (context, index) => Gap(14.h),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final product = item.product;
                        final dpr =
                            MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.5;
                        final int thumbCacheWidth =
                            (80.r * dpr).round().clamp(60, 600);

                        return RepaintBoundary(
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.card),
                              border: Border.all(
                                color: AppColors.hairline,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Product Thumbnail
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.image),
                                  child: SizedBox(
                                    height: 90.r,
                                    width: 80.r,
                                    child: product.image.startsWith('http')
                                        ? Image.network(
                                            product.image,
                                            fit: BoxFit.cover,
                                            cacheWidth: thumbCacheWidth,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return SkeletonBox(
                                                height: 90.r,
                                                width: 80.r,
                                                radius: AppRadius.image,
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                          )
                                        : Image.asset(
                                            product.image,
                                            fit: BoxFit.cover,
                                            cacheWidth: thumbCacheWidth,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                          ),
                                  ),
                                ),
                              Gap(14.w),

                              // Product Information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppText.titleSmall(
                                              color: AppColors.text,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            cartProvider.removeFromCart(item);
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 18.r,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(4.h),
                                    Text(
                                      'Size: ${item.size} • Color: ${item.color}',
                                      style: AppText.caption(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Gap(10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          egp(item.totalPrice),
                                          style: TextStyle(
                                            fontFamily: AppText.fontFamily,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        // Quantity Stepper
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(
                                              AppRadius.pill,
                                            ),
                                            border: Border.all(
                                              color: AppColors.hairline,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _stepperButton(
                                                icon: Icons.remove_rounded,
                                                onTap: () => cartProvider
                                                    .decrementQuantity(item),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                ),
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppText.fontFamily,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.text,
                                                  ),
                                                ),
                                              ),
                                              _stepperButton(
                                                icon: Icons.add_rounded,
                                                onTap: () => cartProvider
                                                    .incrementQuantity(item),
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
                    ),
            ),

            // Order Summary & Checkout Action Sheet
            if (cartItems.isNotEmpty)
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 16.h,
                  bottom: isRootTab ? AppSpacing.navClearance : 24.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: const Border(
                    top: BorderSide(color: AppColors.hairline, width: 1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total (${cartProvider.totalItemCount} items)',
                          style: AppText.bodyMedium(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          egp(cartProvider.subtotal),
                          style: TextStyle(
                            fontFamily: AppText.fontFamily,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    Gap(14.h),
                    PillButton(
                      label: 'Proceed to Checkout',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Icon(icon, size: 16.r, color: AppColors.text),
      ),
    );
  }
}
