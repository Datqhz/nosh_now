import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/providers/user_state_provider.dart';
import 'package:nosh_now_application/presentation/screens/main_screen.dart';
import 'package:nosh_now_application/presentation/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userLoginState = Provider.of<UserStateProvider>(context);
    return !userLoginState.isLogin ? const OnboardingScreen() : MainScreen();
  }
}
