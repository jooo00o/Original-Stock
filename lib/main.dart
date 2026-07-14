import 'package:original_stock/wishlist_screen.dart';
import 'package:original_stock/profile_screen.dart';
import 'package:original_stock/search_screen.dart';
import 'package:original_stock/home_screen.dart';
import 'package:original_stock/cart_screen.dart';
import 'package:original_stock/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
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
double iconsDimentions = 28;
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
            padding: const EdgeInsets.only(bottom: 25, right: 40, left: 40),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
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
