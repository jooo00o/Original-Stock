import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:original_stock/widgets/product_card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderProduct>();
    final wishlist = provider.wishlist;
    final isRootTab = !Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(12.h),
              // Header
              Row(
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
                    'Wishlist',
                    style: AppText.titleMedium(color: AppColors.text),
                  ),
                  const Spacer(),
                  SizedBox(width: 44.r),
                ],
              ),
              Gap(16.h),

              // Saved items counter
              Row(
                children: [
                  Text(
                    '${provider.wishlistCount} ${provider.wishlistCount == 1 ? "saved item" : "saved items"}',
                    style: AppText.bodyMedium(color: AppColors.textSecondary),
                  ),
                ],
              ),
              Gap(14.h),

              // Wishlist Content
              Expanded(
                child: wishlist.isEmpty
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
                                Icons.favorite_border_rounded,
                                size: 42.r,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Gap(20.h),
                            Text(
                              'Your wishlist is empty',
                              style: AppText.titleMedium(color: AppColors.text),
                            ),
                            Gap(6.h),
                            Text(
                              'Save items you like to view and order them later.',
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
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: wishlist.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14.w,
                                mainAxisSpacing: 18.h,
                                childAspectRatio: 0.58,
                              ),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: wishlist[index],
                                  heroScope: 'wishlist',
                                );
                              },
                            ),
                            Gap(AppSpacing.navClearance), // Clearance for bottom nav
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
