import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/home_screen.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double currentsize = 0;
  List<String> recent = ["Linen shirt", "Wool coat", "Sneakers", "Cashmere"];
  List<String> popular = [
    "Outerwear",
    "Trousers",
    "knitwear",
    "learther",
    "Minimal",
  ];
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: ThisPadding.padding,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Navigator.canPop(context)
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return HomeScreen();
                                      },
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.filter_alt,
                                size: 30,
                                color: Colors.black,
                              ),
                        Spacer(),
                        Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.filter_alt, size: 30, color: Colors.black),
                      ],
                    ),
                    Gap(25),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: BackGroundProduct.color,
                            ),
                            child: TextField(
                              focusNode: searchFocusNode,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: searchFocusNode.hasFocus
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: searchFocusNode.hasFocus
                                    ? Colors.white
                                    : Colors.black,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Search...",
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: searchFocusNode.hasFocus
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: searchFocusNode.hasFocus
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(25),
                            // color: BackGroundProduct.color,
                          ),
                          child: Center(
                            child: Icon(Icons.filter_alt, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap(30),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 20,
                    right: 11,
                    left: 11,
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Recent searches",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Clear",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      Gap(15),
                      Wrap(
                        children: List.generate(recent.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              bottom: 10,
                            ),
                            child: Container(
                              height: 45,
                              width: 116.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Color(0xffe0e0e0)),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.close, size: 20),
                                    Text(
                                      recent[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Gap(15),
                      Row(
                        children: [
                          Text(
                            "Popular",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gap(15),
                      Wrap(
                        children: List.generate(recent.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              bottom: 10,
                            ),
                            child: Container(
                              height: 45,
                              width: 116,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Color(0xffe0e0e0)),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  popular[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Gap(15),
                      Text(
                        "Best for you",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(20),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ProductDetails();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                width: 170,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 170,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        border: Border.all(
                                          color: const Color(0xFFBDBDBD),
                                        ),
                                        color: Colors.grey[200],
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          products[index].image,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tokyo Winter Jacket',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '\$ 640.00',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/icons/shopping-bag.png",
                                                    height: iconsDimentions,
                                                    width: iconsDimentions,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          separatorBuilder: ((context, index) {
                            return Gap(10);
                          }),
                          itemCount: products.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
