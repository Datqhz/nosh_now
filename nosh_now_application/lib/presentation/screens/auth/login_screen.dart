import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/streams/user_login_stream.dart';
import 'package:nosh_now_application/core/utils/notify.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/core/utils/validate.dart';
import 'package:nosh_now_application/data/repositories/account_repository.dart';
import 'package:nosh_now_application/presentation/screens/auth/question_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isObscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //thumbnail
                          Image.asset(
                            'assets/images/pork.png',
                            width: MediaQuery.of(context).size.width - 40,
                            height: MediaQuery.of(context).size.width - 100,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Sign in.',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(49, 49, 49, 1)),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // Email input
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                118, 118, 118, 1),
                                            width:
                                                1), // Màu viền khi không được chọn
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(35, 35, 35, 1),
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(182, 0, 0, 1),
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromRGBO(182, 0, 0, 1),
                                          width: 1,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your email.";
                                      } else if (!validateEmail(value)) {
                                        return "Email invalid.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // password input
                                  ValueListenableBuilder(
                                      valueListenable: _isObscure,
                                      builder: (context, value, child) {
                                        return TextFormField(
                                          controller: _passwordController,
                                          obscureText: value,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _isObscure.value =
                                                    !_isObscure.value;
                                              },
                                              icon: value
                                                  ? const Icon(
                                                      CupertinoIcons.eye_slash)
                                                  : const Icon(
                                                      CupertinoIcons.eye),
                                            ),
                                            suffixStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    49, 49, 49, 1)),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      118, 118, 118, 1),
                                                  width:
                                                      1), // Màu viền khi không được chọn
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    35, 35, 35, 1),
                                                width: 1,
                                              ),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    182, 0, 0, 1),
                                                width: 1,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    182, 0, 0, 1),
                                                width: 1,
                                              ),
                                            ),
                                            errorStyle: const TextStyle(
                                                color: Color.fromRGBO(
                                                    182, 0, 0, 1)),
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              color:
                                                  Color.fromRGBO(49, 49, 49, 1),
                                              fontSize: 14,
                                              decoration: TextDecoration.none),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter your password.";
                                            } else if (containsWhitespace(
                                                value)) {
                                              return "Password must not contain any whitespace.";
                                            } else if (value.length < 6) {
                                              return "Password must be at least 6 characters.";
                                            }
                                            return null;
                                          },
                                        );
                                      }),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  // forgot password
                                  Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(40, 40, 40, 0.7)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  //button sign in
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    width: double.infinity,
                                    height: 44,
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final email =
                                              _emailController.text.trim();
                                          final password =
                                              _passwordController.text.trim();
                                          bool rs = await AccountRepository()
                                              .signIn(email, password);
                                          if (rs) {
                                            Navigator.pop(context);
                                            final instance = FirebaseMessaging.instance;
                                            if(GlobalVariable.roleId == 2){
                                              instance.subscribeToTopic('tracking');
                                              instance.subscribeToTopic('order-status');
                                              FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
                                            }else if(GlobalVariable.roleId == 3){
                                              instance.subscribeToTopic('order-status');
                                              FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
                                            }else if(GlobalVariable.roleId == 4){
                                              instance.subscribeToTopic('shipper');
                                            }
                                            Provider.of<UserLogin>(context,
                                                    listen: false)
                                                .login();
                                          } else {
                                            showSnackBar(context,
                                                "Email or password incorrect!");
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          foregroundColor: const Color.fromRGBO(
                                              240, 240, 240, 1),
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      child: const Text('Sign in'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          // forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(40, 40, 40, 0.6)),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              // navigate to question screen
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const QuestionScreen()));
                                },
                                child: const Text(
                                  'Sign up.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(40, 40, 40, 1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // back button
                Positioned(
                  left: 0,
                  right: 0,
                  height: 50,
                  child: Container(
                    color: const Color.fromRGBO(240, 240, 240, 1),
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Color.fromRGBO(49, 49, 49, 1),
                        size: 22,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
