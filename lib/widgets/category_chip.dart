import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:original_stock/core/app_theme.dart';

/// Reusable fully rounded pill chip for categories and filters.
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? leading;
  final double? height;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.leading,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppColors.primaryDark : AppColors.surface;
    final fg = isSelected ? AppColors.white : AppColors.text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height ?? 40.h,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: isSelected
                ? null
                : Border.all(color: AppColors.hairline, width: 0.8),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, SizedBox(width: 6.w)],
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppText.fontFamily,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
