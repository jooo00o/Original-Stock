import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/widgets/gradient_box.dart';

/// Reusable fully rounded pill button with standard height 54 and gradient filled style.
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final Widget? icon;
  final bool isLoading;

  const PillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.width,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 54.h;
    final bool isDisabled = onPressed == null && !isLoading;
    final bool useGradient =
        !isDisabled && !isOutlined && backgroundColor == null;

    final bg = isDisabled
        ? (backgroundColor ?? AppColors.hairline)
        : (isOutlined
            ? (backgroundColor ?? Colors.transparent)
            : (backgroundColor ?? AppColors.primary));
    final fg = isDisabled
        ? (textColor ?? AppColors.textSecondary)
        : (isOutlined
            ? (textColor ?? AppColors.primary)
            : (textColor ?? AppColors.white));
    final border = isOutlined && !isDisabled
        ? Border.all(color: borderColor ?? AppColors.primary, width: 1.5)
        : (borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null);

    final borderRadius = BorderRadius.circular(AppRadius.pill);
    final BoxDecoration deco = useGradient
        ? GradientBox.decoration(
            gradient: AppColors.primaryGradient,
            borderRadius: borderRadius,
            border: border,
          )
        : BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: border,
          );

    return SizedBox(
      height: effectiveHeight,
      width: width ?? double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: Ink(
          decoration: deco,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: borderRadius,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      height: 22.r,
                      width: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(fg),
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            SizedBox(width: 8.w),
                          ],
                          Text(
                            label,
                            style: AppText.button(color: fg),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

