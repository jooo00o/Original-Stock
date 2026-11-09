import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_motion.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/money.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/cart_screen.dart';
import 'package:original_stock/screens/checkout_screen.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/gradient_box.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:original_stock/widgets/skeletons.dart';
import 'package:provider/provider.dart';

// Public constants preserved for backwards compatibility
List<String> size = ["S", "M", "L", "XL", "XXL"];
List<Color> colorCont = [
  const Color(0xFF1E1E1E),
  const Color(0xFF8E8E93),
  const Color(0xFFE5E5EA),
  const Color(0xFF1B2A4A),
];

class ProductDetails extends StatefulWidget {
  final String heroScope;

  const ProductDetails({super.key, this.heroScope = ''});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentSizeIndex = 1; // Default "M"
  int _currentColorIndex = 0;
  int _currentImageIndex = 0;
  bool _isExpandedDescription = false;

  final List<Map<String, dynamic>> _namedColors = [
    {'name': 'Midnight Black', 'color': const Color(0xFF1E1E1E)},
    {'name': 'Heather Grey', 'color': const Color(0xFF8E8E93)},
    {'name': 'Off White', 'color': const Color(0xFFE5E5EA)},
    {'name': 'Deep Navy', 'color': const Color(0xFF1B2A4A)},
  ];

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProviderProduct>().selectedProduct;

    if (product == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: ProductDetailsSkeleton(),
        ),
      );
    }

    // Build image list from product metadata or fallback
    final List<String> displayImages = product.images.isNotEmpty
        ? product.images
        : [product.image];

    final activeImage = displayImages.length > _currentImageIndex
        ? displayImages[_currentImageIndex]
        : product.image;

    final isInWishlist = context.watch<ProviderProduct>().isProductInWishlist(
      product,
    );

    final selectedColorName =
        _namedColors[_currentColorIndex]['name'] as String;

    final heroTag =
        'product-image-${product.id.isNotEmpty ? product.id : product.name}-${widget.heroScope}';

    final routeAnim = ModalRoute.of(context)?.animation;

    final Widget mainImageWidget = activeImage.startsWith('http')
        ? Image.network(
            activeImage,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SkeletonBox(
                width: double.infinity,
                height: double.infinity,
                radius: 24,
              );
            },
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image,
                color: AppColors.textSecondary,
              ),
            ),
          )
        : Image.asset(
            activeImage,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image,
                color: AppColors.textSecondary,
              ),
            ),
          );

    final Widget previewChild = _currentImageIndex == 0
        ? Hero(
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
                      borderRadius: BorderRadius.circular(currentRadius),
                      child: Image(
                        image: activeImage.startsWith('http')
                            ? NetworkImage(activeImage) as ImageProvider
                            : AssetImage(activeImage),
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
              child: mainImageWidget,
            ),
          )
        : mainImageWidget;

    final hasThumbnails = displayImages.length > 1;
    final double infoBase = hasThumbnails ? 0.51 : 0.45;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image Container with rounded 24
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  height: 380.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.banner),
                    border: Border.all(color: AppColors.hairline, width: 1),
                  ),
                  child: Stack(
                    children: [
                      // Active preview image (with Hero for first image)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.banner),
                        child: SizedBox(
                          height: 380.h,
                          width: double.infinity,
                          child: previewChild,
                        ),
                      ),

                      // Top navigation row with circular 44 buttons (fades in slightly after hero lands)
                      Positioned(
                        top: 14.h,
                        left: 14.w,
                        right: 14.w,
                        child: StaggeredMotionSection(
                          animation: routeAnim,
                          startInterval: 0.6,
                          slideOffset: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Circular back button
                              CircularIconButton(
                                backgroundColor: AppColors.white,
                                iconData: Icons.arrow_back_ios_new_rounded,
                                iconColor: AppColors.text,
                                onTap: () => Navigator.pop(context),
                              ),
                              // Circular wishlist heart button
                              CircularIconButton(
                                backgroundColor: AppColors.white,
                                iconData: isInWishlist
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                iconColor: isInWishlist
                                    ? AppColors.heart
                                    : AppColors.text,
                                onTap: () {
                                  context.read<ProviderProduct>().toggleWishlist(
                                    product,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Dots indicator
                      if (displayImages.length > 1)
                        Positioned(
                          bottom: 16.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(displayImages.length, (i) {
                              final isSelected = _currentImageIndex == i;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                height: 6.h,
                                width: isSelected ? 22.w : 6.w,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Row of small circular thumbnails under it (selected has purple ring)
              if (displayImages.length > 1) ...[
                Gap(10.h),
                StaggeredMotionSection(
                  animation: routeAnim,
                  startInterval: 0.45,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      height: 52.r,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: displayImages.length,
                        separatorBuilder: (context, index) => Gap(12.w),
                        itemBuilder: (context, index) {
                          final isSelected = _currentImageIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            child: Container(
                              height: 52.r,
                              width: 52.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.hairline,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                              ),
                              child: ClipOval(
                                child: displayImages[index].startsWith('http')
                                    ? Image.network(
                                        displayImages[index],
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return SkeletonBox(
                                            width: 52.r,
                                            height: 52.r,
                                            shape: BoxShape.circle,
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                      )
                                    : Image.asset(
                                        displayImages[index],
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
              Gap(16.h),

              // Product Info & Details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Category on left, Price on right
                    StaggeredMotionSection(
                      animation: routeAnim,
                      startInterval: infoBase,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.category.isNotEmpty
                                      ? product.category
                                      : 'Original Stock',
                                  style: AppText.caption(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Gap(4.h),
                                Text(
                                  product.name,
                                  style: AppText.titleMedium(
                                    color: AppColors.text,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                egp(product.price),
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (product.oldPrice != null)
                                Text(
                                  egp(product.oldPrice!),
                                  style: TextStyle(
                                    fontFamily: AppText.fontFamily,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.error,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),

                    // "Select Size" row of circular size chips (S, M, L, XL, XXL)
                    StaggeredMotionSection(
                      animation: routeAnim,
                      startInterval: infoBase + 0.06,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Select Size',
                                style: AppText.titleSmall(color: AppColors.text),
                              ),
                              Text(
                                'Size Guide',
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Gap(12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(size.length, (index) {
                              final isSelected = _currentSizeIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentSizeIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: 48.r,
                                  width: 48.r,
                                  decoration: isSelected
                                      ? GradientBox.decoration(
                                          gradient: AppColors.primaryGradient,
                                          shape: BoxShape.circle,
                                        )
                                      : BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.surface,
                                          border: Border.all(
                                            color: AppColors.hairline,
                                            width: 1,
                                          ),
                                        ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    size[index],
                                    style: TextStyle(
                                      fontFamily: AppText.fontFamily,
                                      fontSize: 14.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.text,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),

                    // Colors row with named colors
                    StaggeredMotionSection(
                      animation: routeAnim,
                      startInterval: infoBase + 0.12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Color: ',
                                style: AppText.titleSmall(color: AppColors.text),
                              ),
                              Text(
                                selectedColorName,
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Gap(12.h),
                          Row(
                            children: List.generate(_namedColors.length, (index) {
                              final isSelected = _currentColorIndex == index;
                              final color =
                                  _namedColors[index]['color'] as Color;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentColorIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 14.w),
                                  height: 38.r,
                                  width: 38.r,
                                  padding: EdgeInsets.all(3.r),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color,
                                      border: Border.all(
                                        color: AppColors.hairline,
                                        width: 1,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                            Icons.check_rounded,
                                            size: 16.r,
                                            color: color.computeLuminance() > 0.6
                                                ? Colors.black
                                                : Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),

                    // Short description with "Learn More"
                    StaggeredMotionSection(
                      animation: routeAnim,
                      startInterval: infoBase + 0.18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: AppText.titleSmall(color: AppColors.text),
                          ),
                          Gap(8.h),
                          Text(
                            product.description.isNotEmpty
                                ? product.description
                                : "Premium tailored garment from Original Stock, blending modern architectural cuts with timeless menswear details.",
                            maxLines: _isExpandedDescription ? 10 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyMedium(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Gap(4.h),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpandedDescription =
                                    !_isExpandedDescription;
                              });
                            },
                            child: Text(
                              _isExpandedDescription
                                  ? 'Show Less'
                                  : 'Learn More',
                              style: TextStyle(
                                fontFamily: AppText.fontFamily,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(110.h), // Space for bottom action bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom bar: circular share button + full-width purple pill "Add To Cart" + outlined "Buy Now"
      bottomSheet: StaggeredMotionSection(
        animation: routeAnim,
        startInterval: infoBase + 0.24,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: const Border(
              top: BorderSide(color: AppColors.hairline, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // Circular share button
                    CircularIconButton(
                      iconData: Icons.share_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sharing link copied to clipboard.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    Gap(12.w),
                    // Full-width purple pill "Add To Cart" button
                    Expanded(
                      child: PillButton(
                        label: 'Add To Cart',
                        onPressed: () {
                          context.read<ProviderProduct>().addToCart(
                            product,
                            size[_currentSizeIndex],
                            selectedColorName,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart!'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'View Cart',
                                textColor: AppColors.white,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                // Outlined purple pill "Buy Now" button
                PillButton(
                  label: 'Buy Now',
                  isOutlined: true,
                  onPressed: () {
                    context.read<ProviderProduct>().addToCart(
                      product,
                      size[_currentSizeIndex],
                      selectedColorName,
                    );
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
        ),
      ),
    );
  }
}
