import 'package:flutter/material.dart';
import 'package:original_stock/onboarding/onboarding_screen.dart';

/// Third onboarding step (shop the season & shipping perks).
class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWidget(item: OnboardingScreen.defaultItems[2]);
  }
}
