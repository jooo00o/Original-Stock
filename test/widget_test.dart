import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:original_stock/core/app_motion.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/checkout_screen.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/screens/profile_screen.dart';
import 'package:original_stock/screens/search_screen.dart';
import 'package:original_stock/screens/wishlist_screen.dart';
import 'package:original_stock/widgets/product_card.dart';
import 'package:original_stock/widgets/skeletons.dart';
import 'package:provider/provider.dart';

void main() {
  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('App smoke test on standard viewport', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ProviderProduct(),
        child: const MyApp(),
      ),
    );

    // Initial frame on splash screen
    expect(find.text('Original Stock'), findsOneWidget);

    // Advance splash screen 2-second timer to settle
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  test('ProviderProduct unit tests for id matching and totalPayment', () {
    final provider = ProviderProduct();

    final p1 = ProductModel(
      id: 'item-1',
      name: 'Item A',
      image: 'assets/images/logo.png',
      price: 250.0,
      rating: 4.5,
    );

    final p1CopySameIdDifferentName = ProductModel(
      id: 'item-1',
      name: 'Item A Modified Name',
      image: 'assets/images/logo.png',
      price: 250.0,
      rating: 4.5,
    );

    final p2NoId = ProductModel(
      name: 'Item B',
      image: 'assets/images/logo.png',
      price: 150.0,
      rating: 4.0,
    );

    final p2CopyNoId = ProductModel(
      name: 'Item B',
      image: 'assets/images/logo.png',
      price: 150.0,
      rating: 4.0,
    );

    // 1. Wishlist comparison by ID
    expect(provider.isProductInWishlist(p1), isFalse);
    provider.toggleWishlist(p1);
    expect(provider.isProductInWishlist(p1), isTrue);
    expect(provider.isProductInWishlist(p1CopySameIdDifferentName), isTrue);

    // 2. Wishlist fallback to name + image
    expect(provider.isProductInWishlist(p2NoId), isFalse);
    provider.toggleWishlist(p2NoId);
    expect(provider.isProductInWishlist(p2CopyNoId), isTrue);

    // 3. Add to cart matching by ID and quantity calculation
    provider.addToCart(p1, 'M', 'Black');
    expect(provider.cartItems.length, 1);
    expect(provider.cartItems.first.quantity, 1);
    expect(provider.cartItems.first.unitPrice, 250.0);
    expect(provider.subtotal, 250.0);
    expect(provider.deliveryCharge, 0.0);
    expect(provider.totalPayment, 250.0);

    // Add same product with same id increases quantity
    provider.addToCart(p1CopySameIdDifferentName, 'M', 'Black');
    expect(provider.cartItems.length, 1);
    expect(provider.cartItems.first.quantity, 2);
    expect(provider.subtotal, 500.0);
    expect(provider.totalPayment, 500.0);
  });

  testWidgets('CheckoutScreen disabled when cart is empty',
      (WidgetTester tester) async {
    final provider = ProviderProduct();
    // Ensure selectedProduct is set, but cart is empty
    provider.selectedproduct(
      const ProductModel(
        id: 'test-1',
        name: 'Selected Only',
        image: 'assets/images/logo.png',
        price: 300.0,
        rating: 5.0,
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (context, child) => const MaterialApp(
            home: CheckoutScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify "Your cart is empty" is shown on the disabled button
    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('Responsive test on small phone (360x640)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = ProviderProduct();

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(360, 640),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp(
            theme: AppTheme.theme,
            home: const HomeScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify home screen renders without exceptions on 360x640
    expect(find.text('Original Stock'), findsOneWidget);
    expect(find.text('Explore Fashion'), findsOneWidget);
    expect(find.text('Super Sale'), findsOneWidget);
  });

  testWidgets('Hero transition QA: Home -> Product Details -> Back',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = ProviderProduct();

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.theme,
            home: const HomeScreen(),
          ),
        ),
      ),
    );

    // Initial load displays skeleton
    expect(find.byType(ProductGridSkeleton), findsOneWidget);

    // Settle network delay
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Scroll down to bring products grid into view
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    // Verify product card is rendered
    final productFinder = find.text('Oversized Wool Coat');
    expect(productFinder, findsOneWidget);

    // Tap product card to trigger Hero flight transition
    await tester.tap(productFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    // Verify ProductDetails opened
    expect(find.text('Select Size'), findsOneWidget);

    // Tap back button to trigger reverse Hero flight
    final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Verify back on Home without duplicate Hero tag errors
    expect(find.text('Super Sale'), findsOneWidget);
  });

  testWidgets('Hero transition QA: Search -> Product Details -> Back',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = ProviderProduct();

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.theme,
            home: const SearchScreen(),
          ),
        ),
      ),
    );

    // Initial load displays skeleton
    expect(find.byType(ProductGridSkeleton), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Scroll down to bring products grid into view
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -150),
    );
    await tester.pumpAndSettle();

    // Tap first product card to fly Hero into details
    final productCardFinder = find.byType(ProductCard).first;
    expect(productCardFinder, findsWidgets);
    await tester.tap(productCardFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Select Size'), findsOneWidget);

    // Tap back to return
    final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    await tester.tap(backBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Explore Fashion...'), findsOneWidget);
  });

  testWidgets('Hero transition QA: Wishlist -> Product Details -> Back',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = ProviderProduct();
    const demoItem = ProductModel(
      id: 'prod-001',
      name: 'Oversized Wool Coat',
      image: 'assets/images/686506127_18133742785562861_5213842607967549061_n.jpg',
      price: 450.0,
      category: 'Outerwear',
    );
    provider.toggleWishlist(demoItem);

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.theme,
            home: const WishlistScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final productFinder = find.text('Oversized Wool Coat');
    expect(productFinder, findsOneWidget);

    // Tap to fly Hero into details
    await tester.tap(productFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Select Size'), findsOneWidget);

    // Tap back
    final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
    await tester.tap(backBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Wishlist'), findsOneWidget);
  });

  testWidgets('Tapping heart button on ProductCard does NOT open details',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = ProviderProduct();

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.theme,
            home: const HomeScreen(),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    expect(provider.wishlistCount, 0);

    // Scroll down to bring products grid into view
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    // Tap first heart button
    final heartFinder = find.byIcon(Icons.favorite_border_rounded).first;
    await tester.tap(heartFinder);
    await tester.pumpAndSettle();

    // Verify wishlist toggled
    expect(provider.wishlistCount, 1);

    // Verify we are still on HomeScreen, NOT on details
    expect(find.text('Super Sale'), findsOneWidget);
    expect(find.text('Select Size'), findsNothing);
  });

  test('AppMotion tokens and route config match specifications', () {
    expect(kRouteForward, const Duration(milliseconds: 800));
    expect(kRouteReverse, const Duration(milliseconds: 650));
    expect(kTab, const Duration(milliseconds: 380));
    expect(kFast, const Duration(milliseconds: 220));
    expect(kEmphasized, Curves.easeInOutCubicEmphasized);
    expect(kDecel, Curves.easeOutCubic);

    final route = productDetailsRoute(const SizedBox()) as PageRouteBuilder;
    expect(route.transitionDuration, const Duration(milliseconds: 800));
    expect(route.reverseTransitionDuration, const Duration(milliseconds: 650));
  });

  testWidgets('Edge swipe from left bezel triggers pop',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navKey,
        home: const Scaffold(body: Text('Home Page')),
      ),
    );

    navKey.currentState!.push(
      productDetailsRoute(
        const Scaffold(body: Text('Details Page')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Details Page'), findsOneWidget);

    // Swipe from left edge (x=10) towards right (dx=+60)
    final gesture = await tester.startGesture(const Offset(10, 300));
    await gesture.moveBy(const Offset(60, 0));
    await gesture.up();
    await tester.pumpAndSettle();

    // Verify popped back to Home Page
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Details Page'), findsNothing);
  });

  test('PageTransitionsTheme and fadeScaleRoute match specifications', () {
    final theme = AppTheme.theme;
    final builders = theme.pageTransitionsTheme.builders;
    expect(builders[TargetPlatform.android], isA<CupertinoPageTransitionsBuilder>());
    expect(builders[TargetPlatform.iOS], isA<CupertinoPageTransitionsBuilder>());

    final fsRoute = fadeScaleRoute(const SizedBox()) as PageRouteBuilder;
    expect(fsRoute.transitionDuration, const Duration(milliseconds: 500));
  });

  testWidgets('MainNavController switches tabs via PageView and preserves state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = ProviderProduct();

    await tester.pumpWidget(
      ChangeNotifierProvider<ProviderProduct>.value(
        value: provider,
        child: ScreenUtilInit(
          designSize: const Size(402, 874),
          builder: (context, child) => MaterialApp(
            theme: AppTheme.theme,
            home: const MainScreen(),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    // Verify initially on Home
    expect(find.text('Super Sale'), findsOneWidget);
    expect(mainNavController.currentIndex, 0);

    // Switch to Cart (tab index 1)
    mainNavController.goToTab(1);
    await tester.pump();
    await tester.pump(kTab);
    expect(mainNavController.currentIndex, 1);
    expect(find.text('Shopping Bag'), findsOneWidget);

    // Switch to Wishlist (tab index 2)
    mainNavController.goToTab(2);
    await tester.pump();
    await tester.pump(kTab);
    expect(mainNavController.currentIndex, 2);
    expect(find.text('Wishlist'), findsWidgets);

    // Switch to Profile (tab index 3)
    mainNavController.goToTab(3);
    await tester.pump();
    await tester.pump(kTab);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(mainNavController.currentIndex, 3);
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('My Profile'), findsOneWidget);

    // Switch back to Home (distance 3 > 1) via goToTab
    mainNavController.goToTab(0);
    await tester.pump();
    await tester.pump(kTab);
    expect(mainNavController.currentIndex, 0);
    expect(find.text('Super Sale'), findsOneWidget);
  });
}
