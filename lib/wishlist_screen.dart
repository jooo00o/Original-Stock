import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/home_screen.dart';
import 'package:original_stock/main.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: ThisPadding.padding,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_alt, size: 30, color: Colors.white),
                  Spacer(),
                  Text(
                    'Wishlist',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.filter_alt, size: 30, color: Colors.white),
                ],
              ),
              Gap(30),
              Text(
                "6 saved items",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              Gap(20),
              GridviewConts(favorate: true),
            ],
          ),
        ),
      ),
    );
  }
}
