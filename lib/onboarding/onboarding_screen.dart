import 'package:original_stock/onboarding/first_onboarding_screen.dart';
import 'package:original_stock/onboarding/third_onboarding_screen.dart';
import 'package:original_stock/onboarding/second_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selecredOnboard = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.black, fontSize: 18.sp),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      selecredOnboard = value;
                    });
                  },
                  children: [
                    const FirstOnboardingScreen(),
                    const SecondOnboardingScreen(),
                    const ThirdOnboardingScreen(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIndicator(active: selecredOnboard == 0),
                  Gap(6.w),
                  CustomIndicator(active: selecredOnboard == 1),
                  Gap(6.w),
                  CustomIndicator(active: selecredOnboard == 2),
                ],
              ),
              Gap(50.h),
              GestureDetector(
                onTap: () {
                  if (selecredOnboard == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  } else {
                    pageController.animateToPage(
                      selecredOnboard + 1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                },
                child: Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                      top: 8.h,
                      bottom: 8.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Cairo",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key, required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      height: 10.h,
      width: active ? 30.w : 10.w,
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
