import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/streams/user_login_stream.dart';
import 'package:nosh_now_application/presentation/screens/main_screen.dart';
import 'package:nosh_now_application/presentation/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userLoginState = Provider.of<UserLogin>(context);
    return !userLoginState.isLogin ? const OnboardingScreen() : MainScreen();
  }
}
