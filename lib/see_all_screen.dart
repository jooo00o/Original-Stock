import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/home_screen.dart';

class SeeAllScreen extends StatelessWidget {
  const SeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: ThisPadding.padding,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, size: 30),
                  ),
                  Spacer(),
                  Text(
                    "Categories",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(Icons.filter_alt, size: 30, color: Colors.white),
                ],
              ),
              Gap(30),
              LisvviewSaparated(),
              Gap(30),
              GridviewConts(favorate: true),
            ],
          ),
        ),
      ),
    );
  }
}
