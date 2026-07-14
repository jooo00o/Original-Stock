import 'package:original_stock/product_details.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/see_all_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackGroundColor.bcgcolor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: ThisPadding.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          fit: BoxFit.fitWidth,
                          'assets/images/nimble-made-7RIMS-NMsbc-unsplash.jpg',
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 35,
                                    spreadRadius: 15,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Discover \nSummer Collection',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  wordSpacing: -5,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "CourierPrime",
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 40,
                                width: 115,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'Shop Now',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(20),
                Row(
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 23,
                        wordSpacing: -5,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: "CourierPrime",
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SeeAllScreen();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(10),
                SizedBox(height: 140, child: ListviewProducts()),
                Gap(10),
                Text(
                  'Top Product',
                  style: TextStyle(
                    fontSize: 23,
                    wordSpacing: -5,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "CourierPrime",
                  ),
                ),
                Gap(10),
                GridviewConts(favorate: false),
                Gap(100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});
  final double iconsize = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: ThisPadding.padding,
          child: Row(
            children: [
              Icon(Icons.settings, size: iconsize),
              Spacer(),
              AppName.name,
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SearchScreen();
                      },
                    ),
                  );
                },
                child: Icon(Icons.search, size: iconsize),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

class CategoryCont extends StatefulWidget {
  const CategoryCont({
    super.key,
    this.width,
    this.color,
    this.height,
    required this.text,
    this.fontcolor,
    required this.border,
  });
  final double? height;
  final double? width;
  final Color? color;
  final String text;
  final Color? fontcolor;
  final double border;

  @override
  State<CategoryCont> createState() => _CategoryContState();
}

class _CategoryContState extends State<CategoryCont> {
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.border),
          color: widget.color,
          border: Border.all(color: Colors.black, width: 0.15),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: fontSize,
                color: widget.fontcolor,
                letterSpacing: -0.5,
                fontFamily: "CourierPrime",
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThisPadding {
  static const padding = EdgeInsets.symmetric(horizontal: 11);
}

class AppName {
  static const name = Text(
    'Original Stock',
    style: TextStyle(
      fontSize: 24,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}

class BackGroundProduct {
  static final color = Colors.grey[100];
}

class BackGroundColor {
  static const bcgcolor = Colors.white;
}

class LisvviewSaparated extends StatefulWidget {
  const LisvviewSaparated({super.key});

  @override
  State<LisvviewSaparated> createState() => _LisvviewSaparatedState();
}

int current = 0;
double border = 8;
final double widthcategorycont = 90;

List category = [
  "All",
  "Shirts",
  "Pants",
  "Blazers",
  "T-shirts",
  "Glasses",
  "Perfums",
];

class _LisvviewSaparatedState extends State<LisvviewSaparated> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
            },
            child: CategoryCont(
              color: current == index ? Colors.black : Colors.white,
              text: category[index],
              fontcolor: current == index ? Colors.white : Colors.black,
              border: index == 0 ? border + 2 : border,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 5);
        },
        itemCount: category.length,
      ),
    );
  }
}

class GridviewConts extends StatelessWidget {
  const GridviewConts({super.key, required this.favorate});
  final bool favorate;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        childAspectRatio: 0.650,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.read<ProviderProduct>().selectedproduct(products[index]);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProductDetails();
                },
              ),
            );
          },
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 190,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: const Color(0xFFBDBDBD)),
                        color: Colors.grey[200],
                      ),
                      child: Center(child: Image.asset(products[index].image)),
                    ),
                    ?favorate
                        ? Positioned(
                            top: 10,
                            right: 10,
                            child: Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.grey[700],
                            ),
                          )
                        : null,
                  ],
                ),
                Text(
                  'The North Face',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  products[index].name,
                  style: TextStyle(
                    fontSize: 17.7,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Text(
                      products[index].price,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.star, color: Colors.orange),
                    Text(
                      products[index].rating,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ListviewProducts extends StatelessWidget {
  const ListviewProducts({super.key});

  @override
  Widget build(BuildContext context) {
    List productsData = [
      {
        "img":
            "assets/images/vintageinspired-outerwear-designs_1104763-41888.jpg",
        "name": "Outerwear",
      },
      {
        "img":
            "assets/images/three-t-shirts-with-mountain-scene-them-are-hanging-wall-generative-ai_958098-68503.jpg",
        "name": "Shirts",
      },
      {
        "img":
            "assets/images/white-isolated-male-sweater-transparent-background_410516-125527.jpg",
        "name": "knitwear",
      },
      {
        "img": "assets/images/shoes-running-sneakers-design_849407-6889.jpg",
        "name": "Shoes",
      },
      {
        "img": "assets/images/fashionable-pants-isolated_23-2151336726.jpg",
        "name": "Jeans",
      },
    ];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(productsData[index]["img"]),
                ),
              ),
            ),
            Gap(5),
            Text(
              productsData[index]["name"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Gap(15);
      },
      itemCount: productsData.length,
    );
  }
}

List<ProductModel> products = [
  ProductModel(
    name: "Tokyo Winter Jacket",
    image:
        "assets/images/jacket-with-hood-that-says-winter_1277670-18691-removebg-preview.png",
    price: "\$ 640.00",
    rating: "4.8",
  ),
  ProductModel(
    name: "Tokyo Winter Jacket",
    image:
        "assets/images/stylish-black-grey-hooded-jacket-with-white-removebg-preview.png",
    price: "\$ 220.00",
    rating: "4.8",
  ),
  ProductModel(
    name: "Tokyo Winter Jacket",
    image: "assets/images/corduroy-jacket-isolated_624181-13371-Photoroom.png",
    price: "\$ 100.00",
    rating: "4.8",
  ),
];

class ProductModel {
  final String name;
  final String image;
  final String price;
  final String rating;

  ProductModel({
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
  });
}
