import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/money.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/widgets/pill_button.dart';

class OrderConfirmed extends StatefulWidget {
  final double? total;
  final String? orderNumber;

  const OrderConfirmed({
    super.key,
    this.total,
    this.orderNumber,
  });

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  @override
  Widget build(BuildContext context) {
    final effectiveOrderNumber = widget.orderNumber ?? '#OS-10298';
    final effectiveTotal = widget.total != null ? egp(widget.total!) : egp(680);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.softGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(20.h),
              // Brand purple checkmark circle
              Container(
                height: 110.r,
                width: 110.r,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    height: 80.r,
                    width: 80.r,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 46.r,
                    ),
                  ),
                ),
              ),
              Gap(24.h),
              Text(
                'Order confirmed',
                style: AppText.titleLarge(color: AppColors.text, fontSize: 24.sp),
              ),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Thank you for shopping with Original Stock. We've sent an order confirmation to your WhatsApp.",
                  textAlign: TextAlign.center,
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                ),
              ),
              Gap(32.h),

              // Order summary details card (rounded 20, soft grey surface)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.hairline, width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    _buildRow('Order number', effectiveOrderNumber),
                    Gap(14.h),
                    const Divider(),
                    Gap(14.h),
                    _buildRow('Estimated delivery', '2 - 4 business days'),
                    Gap(14.h),
                    const Divider(),
                    Gap(14.h),
                    _buildRow('Payment method', 'Cash on delivery'),
                    Gap(14.h),
                    const Divider(),
                    Gap(14.h),
                    _buildRow(
                      'Total',
                      effectiveTotal,
                      isBold: true,
                      valueColor: AppColors.primary,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Back to Home button (pill height 54, purple fill)
              PillButton(
                label: 'Back to Home',
                onPressed: () {
                  mainNavController.goToTab(0, animate: false);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
                  );
                },
              ),
              Gap(10.h),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: isBold ? 16.sp : 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? AppColors.text,
          ),
        ),
      ],
    );
  }
}
