import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/widgets/gradient_box.dart';

/// Reusable circular 44 icon button with soft grey surface fill or brand gradient.
class CircularIconButton extends StatelessWidget {
  final Widget? icon;
  final IconData? iconData;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Gradient? gradient;
  final double? size;
  final double? iconSize;
  final String? tooltip;
  final Border? border;
  final int badgeCount;

  const CircularIconButton({
    super.key,
    this.icon,
    this.iconData,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.gradient,
    this.size,
    this.iconSize,
    this.tooltip,
    this.border,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final diameter = size ?? 44.r;
    final bg = backgroundColor ?? AppColors.surface;
    final fg = iconColor ?? AppColors.text;

    final deco = gradient != null
        ? GradientBox.decoration(
            gradient: gradient!,
            shape: BoxShape.circle,
            border: border,
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            border: border,
          );

    Widget button = SizedBox(
      height: diameter,
      width: diameter,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: Ink(
          decoration: deco,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: icon ??
                  Icon(
                    iconData ?? Icons.circle,
                    size: iconSize ?? 20.r,
                    color: fg,
                  ),
            ),
          ),
        ),
      ),
    );

    if (badgeCount > 0) {
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: 2.h,
            right: 2.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
              child: Center(
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppText.fontFamily,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

