import 'package:flutter/material.dart';
import 'package:original_stock/onboarding/onboarding_screen.dart';

/// Second onboarding step (quiet luxury & premium materials).
class SecondOnboardingScreen extends StatelessWidget {
  const SecondOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPageWidget(item: OnboardingScreen.defaultItems[1]);
  }
}
