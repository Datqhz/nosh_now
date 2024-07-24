import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/streams/user_login_stream.dart';
import 'package:nosh_now_application/data/providers/food_list_provider.dart';
import 'package:nosh_now_application/presentation/wrapper.dart';
import 'package:provider/provider.dart';

import 'presentation/themes/app_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserLogin(),
      ),
      ChangeNotifierProvider(create: (context) => FoodListProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nosh Now',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
