import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/home_screen.dart';
import 'package:original_stock/order_confirmed.dart';
import 'package:original_stock/provider.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontsize = 18;
    final FontWeight fontweight = FontWeight.w600;
    final color = Colors.grey[800];
    final product = context.watch<ProviderProduct>().selectedProduct;
    return Scaffold(
      backgroundColor: BackGroundProduct.color,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
          right: 20,
          left: 20,
          top: 10,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return OrderConfirmed();
                },
              ),
            );
          },
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Palce order",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
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
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                    Spacer(),
                    Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.favorite, color: BackGroundProduct.color),
                  ],
                ),
                Gap(30),
                Text(
                  "Your Name",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20),
                Text(
                  "Your Phone",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your phone",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20),
                Text(
                  "Your Address",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your address",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20),
                Text(
                  "Your Email",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20),
                    color: BackGroundProduct.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: "your email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Gap(20),
                Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Defult Data",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Gap(20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[500]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order sammery",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Total Items",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                            Spacer(),
                            Text(
                              product!.price,
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Tax",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "\$4.50",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Delivery Charge",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "\$00.00",
                              style: TextStyle(
                                fontSize: fontsize,
                                fontWeight: fontweight,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              "Total Payment:",
                              style: TextStyle(
                                fontSize: fontsize + 2,
                                fontWeight: fontweight,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              product.price,
                              style: TextStyle(
                                fontSize: fontsize + 2,
                                fontWeight: fontweight,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
