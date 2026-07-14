import 'package:original_stock/checkout_screen.dart';
import 'package:original_stock/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontsize = 18;
    final FontWeight fontweight = FontWeight.w600;
    final color = Colors.grey[800];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: Navigator.canPop(context) ? 20 : 100,
          right: 20,
          left: 20,
          top: 10,
        ),
        child: SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order sammery",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    "\$640.00",
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
              Gap(5),
              Divider(),
              Gap(5),
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
                    "\$640.00",
                    style: TextStyle(
                      fontSize: fontsize + 2,
                      fontWeight: fontweight,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Gap(10),
              GestureDetector(
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
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      "Checkout . \$640",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: ThisPadding.padding,
          child: Column(
            children: [
              Row(
                children: [
                  Navigator.canPop(context)
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios_new),
                        )
                      : Icon(Icons.favorite, color: Colors.white),
                  Spacer(),
                  Text(
                    'Cart',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.favorite, color: Colors.white),
                ],
              ),
              Gap(30),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.05,
                                ),
                                color: BackGroundProduct.color,
                              ),
                              child: ClipRRect(
                                child: Image.asset(
                                  height: double.infinity,
                                  'assets/images/jacket-with-hood-that-says-winter_1277670-18691-removebg-preview.png',
                                ),
                              ),
                            ),
                            Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tokyo Winter Jacket',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Size: L ,Grey',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$640,00',
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.remove_circle_outline,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    Gap(5),
                                    Text("1", style: TextStyle(fontSize: 20)),
                                    Gap(5),
                                    Icon(
                                      Icons.add_circle_outline,
                                      size: 30,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Gap(10);
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
