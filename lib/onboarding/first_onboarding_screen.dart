import 'package:flutter/material.dart';
import 'package:original_stock/onboarding/onboarding_screen.dart';

/// First onboarding step (curated menswear for the modern man).
class FirstOnboardingScreen extends StatelessWidget {
  const FirstOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWidget(item: OnboardingScreen.defaultItems[0]);
  }
}
