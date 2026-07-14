import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/cart_screen.dart';
import 'package:original_stock/checkout_screen.dart';
import 'package:original_stock/home_screen.dart';
import 'package:original_stock/main.dart';
import 'package:original_stock/provider.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

List<String> size = ["M", "L", "XL", "XXL"];
List<Color> colorCont = [Colors.black, Colors.white, Colors.brown, Colors.grey];

class _ProductDetailsState extends State<ProductDetails> {
  int currentsize = 0;
  int checkicon = 0;
  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProviderProduct>().selectedProduct;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            color: backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(right: 11, left: 11, top: 10, bottom: 30),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return CartScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Add To Cart",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(5),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return CheckoutScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          "Buy Now",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: ThisPadding.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
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
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                    Spacer(),
                    Text(
                      'Product Details',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.favorite),
                  ],
                ),
                Gap(20),
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.05),
                    color: BackGroundProduct.color,
                  ),
                  child: ClipRRect(
                    child: Image.asset(height: double.infinity, product!.image),
                  ),
                ),
                Gap(10),
                Row(
                  children: [
                    Text('The North Face', style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Icon(Icons.share, size: 20),
                  ],
                ),
                Gap(10),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Gap(10),
                Divider(),
                Gap(10),
                Row(
                  children: [
                    Text(
                      product.price,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.star, color: Colors.orange),
                    Gap(5),
                    Text(
                      product.rating,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Gap(5),
                Divider(),
                Gap(5),
                Text(
                  'Size',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Gap(10),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentsize = index;
                          });
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: currentsize == index
                                ? Colors.black
                                : Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 0.15,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              size[index],
                              style: TextStyle(
                                color: currentsize == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Gap(10);
                    },
                    itemCount: size.length,
                  ),
                ),
                Gap(15),
                Text(
                  'Color',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Gap(10),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            checkicon = index;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(25),
                            color: colorCont[index],
                          ),
                          child: Center(
                            child: checkicon == index
                                ? Text(
                                    "√",
                                    style: TextStyle(
                                      color: checkicon == 0
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                : Text(""),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Gap(10);
                    },
                    itemCount: colorCont.length,
                  ),
                ),
                Gap(20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(10),
                        Text(
                          "The North Face's Tokyo Winter Jacket blends iconic outdoor heritage with a bold, ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
