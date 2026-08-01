import 'package:original_stock/screens/splash_screen.dart';
import 'package:original_stock/screens/wishlist_screen.dart';
import 'package:original_stock/screens/profile_screen.dart';
import 'package:original_stock/screens/search_screen.dart';
import 'package:original_stock/screens/home_screen.dart';
import 'package:original_stock/screens/cart_screen.dart';
import 'package:original_stock/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
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
          theme: ThemeData(scaffoldBackgroundColor: Colors.black),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}

List screens = [
  HomeScreen(),
  SearchScreen(),
  WishlistScreen(),
  CartScreen(),
  ProfileScreen(),
];
const List icons = [
  "assets/icons/home (1).png",
  "assets/icons/search.png",
  "assets/icons/heart (1).png",
  "assets/icons/shopping-bag.png",
  "assets/icons/people.png",
];
int selectedPage = 0;
double get iconsDimentions => 28.r;
final Color backgroundColor = BackGroundColor.bcgcolor;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          screens[selectedPage],
          Padding(
            padding: EdgeInsets.only(bottom: 25.h, right: 40.w, left: 40.w),
            child: Container(
              height: 65.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  icons.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPage = index;
                      });
                    },
                    child: Container(
                      height: 45.h,
                      width: 45.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        color: selectedPage == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Center(
                        child: Image.asset(
                          icons[index],
                          height: iconsDimentions,
                          width: iconsDimentions,
                          color: selectedPage == index
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
