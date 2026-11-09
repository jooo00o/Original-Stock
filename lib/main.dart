import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_motion.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/cart_screen.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/screens/profile_screen.dart';
import 'package:original_stock/screens/splash_screen.dart';
import 'package:original_stock/screens/wishlist_screen.dart';
import 'package:original_stock/widgets/gradient_box.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProviderProduct(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Original Stock',
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// Controller for bottom nav tab switching and sliding transitions
// -----------------------------------------------------------------------------

/// Controller to drive smooth PageView tab switching across the application.
class MainNavController {
  MainNavController._();
  static final MainNavController instance = MainNavController._();

  final ValueNotifier<int> currentTab = ValueNotifier<int>(0);
  PageController? pageController;

  int get currentIndex => currentTab.value;

  /// Navigates to [targetIndex] with a smooth slide transition.
  /// If the target tab is more than 1 page away, avoids flashing intermediate
  /// pages by jumping to the neighbor of the target first, then animating the last step.
  void goToTab(int targetIndex, {bool animate = true}) {
    if (targetIndex < 0 || targetIndex > 3) return;
    if (targetIndex == currentTab.value) return;

    final controller = pageController;
    final int fromIndex = currentTab.value;

    currentTab.value = targetIndex;

    if (controller == null || !controller.hasClients || !animate) {
      return;
    }

    final int step = (targetIndex - fromIndex).abs();

    if (step > 1) {
      // Jump to the neighbour of the target first to avoid flashing intermediate tabs
      final int neighbour =
          targetIndex > fromIndex ? targetIndex - 1 : targetIndex + 1;
      controller.jumpToPage(neighbour);
    }

    controller.animateToPage(
      targetIndex,
      duration: kTab,
      curve: kDecel,
    );
  }
}

final MainNavController mainNavController = MainNavController.instance;

// Backward-compatibility accessors
int get selectedPage => mainNavController.currentIndex;
set selectedPage(int index) => mainNavController.goToTab(index);

const List<Widget> screens = [
  HomeScreen(),
  CartScreen(),
  WishlistScreen(),
  ProfileScreen(),
];

const List<String> icons = [
  "assets/icons/home (1).png",
  "assets/icons/shopping-bag.png",
  "assets/icons/heart (1).png",
  "assets/icons/people.png",
];

double get iconsDimentions => 24.r;
Color get backgroundColor => AppColors.background;

/// Wraps tab pages in [AutomaticKeepAliveClientMixin] so their state,
/// scroll offset, and loaded data are preserved across tab switches.
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  const KeepAlivePage({super.key, required this.child});

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;

  // 4 primary navigation items matching the PageView tab order
  final List<Map<String, dynamic>> _navItems = const [
    {
      'label': 'Home',
      'icon': 'assets/icons/home (1).png',
      'fallbackIcon': Icons.home_rounded,
    },
    {
      'label': 'Cart',
      'icon': 'assets/icons/shopping-bag.png',
      'fallbackIcon': Icons.shopping_bag_outlined,
    },
    {
      'label': 'Wishlist',
      'icon': 'assets/icons/heart (1).png',
      'fallbackIcon': Icons.favorite_border_rounded,
    },
    {
      'label': 'Profile',
      'icon': 'assets/icons/people.png',
      'fallbackIcon': Icons.person_outline_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: mainNavController.currentIndex);
    mainNavController.pageController = _pageController;
  }

  @override
  void dispose() {
    if (mainNavController.pageController == _pageController) {
      mainNavController.pageController = null;
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<ProviderProduct>().totalItemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Content pages inside PageView with state preservation
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              KeepAlivePage(child: HomeScreen()),
              KeepAlivePage(child: CartScreen()),
              KeepAlivePage(child: WishlistScreen()),
              KeepAlivePage(child: ProfileScreen()),
            ],
          ),

          // Floating rounded pill bottom nav
          ValueListenableBuilder<int>(
            valueListenable: mainNavController.currentTab,
            builder: (context, activeIndex, _) {
              return Padding(
                padding: EdgeInsets.only(bottom: 24.h, left: 24.w, right: 24.w),
                child: Container(
                  height: 64.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.hairline, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_navItems.length, (index) {
                      final item = _navItems[index];
                      final bool isSelected = activeIndex == index;
                      final String label = item['label'] as String;
                      final String iconPath = item['icon'] as String;
                      final IconData fallbackIcon =
                          item['fallbackIcon'] as IconData;

                      return GestureDetector(
                        onTap: () => mainNavController.goToTab(index),
                        child: AnimatedContainer(
                          duration: kTab,
                          curve: kDecel,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSelected ? 16.w : 12.w,
                            vertical: 8.h,
                          ),
                          decoration: isSelected
                              ? GradientBox.decoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.pill),
                                )
                              : BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.pill),
                                ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.asset(
                                    iconPath,
                                    height: 22.r,
                                    width: 22.r,
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textSecondary,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) => Icon(
                                      fallbackIcon,
                                      size: 22.r,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  if (label == 'Cart' &&
                                      cartCount > 0 &&
                                      !isSelected)
                                    Positioned(
                                      top: -4.h,
                                      right: -6.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                          vertical: 1.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 14.r,
                                          minHeight: 14.r,
                                        ),
                                        child: Text(
                                          cartCount > 9 ? '9+' : '$cartCount',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: AppText.fontFamily,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.white,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              AnimatedSize(
                                duration: kTab,
                                curve: kDecel,
                                child: isSelected
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Gap(6.w),
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontFamily: AppText.fontFamily,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
