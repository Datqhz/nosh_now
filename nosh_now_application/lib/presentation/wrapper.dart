import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/streams/user_login_stream.dart';
import 'package:nosh_now_application/presentation/screens/main_screen.dart';
import 'package:nosh_now_application/presentation/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserLogin>(builder: (context, userState, _) {
      bool isLoggedIn = userState.isLogin;
      print("login: $isLoggedIn");
      return !isLoggedIn ? const OnboardingScreen() : MainScreen();
    });
  }
}
