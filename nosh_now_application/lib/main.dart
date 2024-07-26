import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nosh_now_application/core/streams/user_login_stream.dart';
import 'package:nosh_now_application/data/providers/food_list_provider.dart';
import 'package:nosh_now_application/data/providers/timer_provider.dart';
import 'package:nosh_now_application/presentation/wrapper.dart';
import 'package:provider/provider.dart';

import 'presentation/themes/app_theme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserLogin()
      ),
      ChangeNotifierProvider(create: (context) => FoodListProvider()),
      ChangeNotifierProvider(create: (context) => TimerProvider()),
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
