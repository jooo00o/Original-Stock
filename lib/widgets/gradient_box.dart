import 'package:flutter/material.dart';
import 'package:original_stock/core/app_theme.dart';

/// Reusable helper widget and decoration for brand purple gradients.
class GradientBox extends StatelessWidget {
  final Widget? child;
  final Gradient gradient;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const GradientBox({
    super.key,
    this.child,
    this.gradient = AppColors.primaryGradient,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.border,
    this.boxShadow,
    this.padding,
    this.width,
    this.height,
    this.alignment,
  });

  /// Factory helper for creating consistent BoxDecoration with gradients.
  static BoxDecoration decoration({
    Gradient gradient = AppColors.primaryGradient,
    BorderRadiusGeometry? borderRadius,
    BoxShape shape = BoxShape.rectangle,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: shape == BoxShape.circle ? null : borderRadius,
      shape: shape,
      border: border,
      boxShadow: boxShadow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: decoration(
        gradient: gradient,
        borderRadius: borderRadius,
        shape: shape,
        border: border,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

