import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/core/utils/time_picker.dart';
import 'package:nosh_now_application/core/utils/validate.dart';
import 'package:nosh_now_application/data/models/account.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/repositories/account_repository.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';
import 'package:nosh_now_application/data/repositories/merchant_repository.dart';
import 'package:nosh_now_application/presentation/screens/auth/login_screen.dart';
import 'package:nosh_now_application/presentation/screens/auth/register_success.dart';

class RegisterMerchantStep1Screen extends StatefulWidget {
  const RegisterMerchantStep1Screen({super.key});

  @override
  State<RegisterMerchantStep1Screen> createState() =>
      _RegisterMerchantStep1ScreenState();
}

class _RegisterMerchantStep1ScreenState
    extends State<RegisterMerchantStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  List<FoodCategory> _categories = [];
  final ValueNotifier<String?> _categorySelected = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _fetchCategoryData();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _isObscure.dispose();
    _categorySelected.dispose();
    super.dispose();
  }

  Future<void> _fetchCategoryData() async {
    try {
      List<FoodCategory> types = await CategoryRepository().getAll();
      _categories = types;
      setState(() {});
    } catch (e) {
      print('Error converting image to base64: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 70,
                            ),
                            const Text(
                              'Your food store infomation',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(49, 49, 49, 1)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Display name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // display name input
                                  TextFormField(
                                    controller: _displayNameController,
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your display name.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter email.";
                                      } else if (!validateEmail(value)) {
                                        return "Email invalid";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
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
                                  const Text(
                                    'Phone',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // phone input
                                  TextFormField(
                                    controller: _phoneController,
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your phone.";
                                      } else if (containsWhitespace(value)) {
                                        return "Phone must not contain any whitespace.";
                                      } else if (!validatePhone(value)) {
                                        return "Phone invalid.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    'Category',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // category input
                                  DropdownButtonFormField<String>(
                                    dropdownColor: Colors.white,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(49, 49, 49, 1),
                                    ),
                                    icon: const Icon(
                                      CupertinoIcons.chevron_down,
                                      size: 14,
                                      color: Color.fromRGBO(118, 118, 118, 1),
                                    ),
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                118, 118, 118, 1),
                                            width:
                                                1), // Màu viền khi không được chọn
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                    ),
                                    value: _categorySelected.value,
                                    items: _categories
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.categoryName,
                                              child: Text(
                                                item.categoryName,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      _categorySelected.value = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    'Address',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // address input
                                  TextFormField(
                                    readOnly: true,
                                    initialValue: "d",
                                    decoration: const InputDecoration(
                                      suffixIcon:
                                          Icon(CupertinoIcons.map_pin_ellipse),
                                      suffixStyle: TextStyle(
                                          color: Color.fromRGBO(49, 49, 49, 1)),
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please choose your address.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    'Opening time',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // opening time input
                                  TextFormField(
                                    onTap: () async {
                                      TimeOfDay? time =
                                          await selectTime(context);
                                      if (time != null) {
                                        _openingTimeController.text =
                                            formatTimeOfDay(time);
                                      }
                                    },
                                    controller: _openingTimeController,
                                    readOnly: true,
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter choose your opening time.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const Text(
                                    'Closing time',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // closing time input
                                  TextFormField(
                                    onTap: () async {
                                      TimeOfDay? time =
                                          await selectTime(context);
                                      if (time != null) {
                                        _closingTimeController.text =
                                            formatTimeOfDay(time);
                                      }
                                    },
                                    controller: _closingTimeController,
                                    readOnly: true,
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
                                      errorStyle: TextStyle(
                                          color: Color.fromRGBO(182, 0, 0, 1)),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        fontSize: 14,
                                        decoration: TextDecoration.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter choose your closing time.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //button next
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    width: double.infinity,
                                    height: 44,
                                    child: TextButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final displayName =
                                              _displayNameController.text
                                                  .trim();
                                          final email =
                                              _emailController.text.trim();
                                          final password =
                                              _passwordController.text.trim();
                                          final phone =
                                              _phoneController.text.trim();
                                          final openingTime =
                                              _openingTimeController.text;
                                          final closingTime =
                                              _closingTimeController.text;
                                          final address = '0 - 0';
                                          FoodCategory? category = null;
                                          _categories.forEach((e) {
                                            if (e.categoryName ==
                                                _categorySelected.value) {
                                              category = e;
                                            }
                                          });
                                          Merchant merchant = Merchant(
                                              merchantId: 0,
                                              displayName: displayName,
                                              email: email,
                                              phone: phone,
                                              avatar: '',
                                              openingTime: openingTime,
                                              closingTime: closingTime,
                                              coordinator: address,
                                              category: category);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterMerchantStep2Screen(
                                                        merchant: merchant,
                                                        password: password,
                                                      )));
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
                                      child: const Text('Next'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Do you have an account?",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(40, 40, 40, 0.6)),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                // navigate to sign up
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: const Text(
                                    'Sign in.',
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
                ),
                // back button
                Positioned(
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    color: const Color.fromRGBO(240, 240, 240, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            CupertinoIcons.arrow_left,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          'Fill your shipper profile',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1)),
                        )
                      ],
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

class RegisterMerchantStep2Screen extends StatefulWidget {
  RegisterMerchantStep2Screen(
      {super.key, required this.merchant, required this.password});

  Merchant merchant;
  String password;

  @override
  State<RegisterMerchantStep2Screen> createState() =>
      _RegisterMerchantStep2ScreenState();
}

class _RegisterMerchantStep2ScreenState
    extends State<RegisterMerchantStep2Screen> {
  final ValueNotifier<XFile?> _avatar = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    const Text(
                      'Choosing an avatar for your food store',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1)),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: _avatar,
                              builder: (context, value, child) {
                                return GestureDetector(
                                  onTap: () async {
                                    XFile? img = await pickAnImageFromGallery();
                                    _avatar.value = img;
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height:
                                        MediaQuery.of(context).size.width - 100,
                                    decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            240, 240, 240, 1),
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                49, 49, 49, 1)),
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: value != null
                                                ? FileImage(File(value.path))
                                                    as ImageProvider<Object>
                                                : const AssetImage(
                                                    'assets/images/add_image_icon.png'))),
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                // back button
                Positioned(
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    color: const Color.fromRGBO(240, 240, 240, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            CupertinoIcons.arrow_left,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            size: 22,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          'Choose avatar',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1)),
                        ),
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () async {
                            int createdAccountResult = await AccountRepository()
                                .signUp(
                                    widget.merchant.email, widget.password, 3);
                            print(
                                "create account result: $createdAccountResult");
                            if (createdAccountResult != 0) {
                              String avatar = '';
                              if (_avatar.value != null) {
                                avatar = await convertToBase64(_avatar.value!);
                              } else {
                                avatar = defaultImage;
                              }
                              print(widget.merchant.category!.categoryId);
                              Merchant eater = Merchant(
                                  merchantId: 0,
                                  displayName: widget.merchant.displayName,
                                  email: widget.merchant.email,
                                  phone: widget.merchant.phone,
                                  avatar: avatar,
                                  openingTime: widget.merchant.openingTime,
                                  closingTime: widget.merchant.closingTime,
                                  coordinator: '0 - 0',
                                  category: widget.merchant.category);
                              bool rs = await MerchantRepository()
                                  .create(eater, createdAccountResult);
                              if (rs) {
                                print("success");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterSuccessScreen()));
                              } else {
                                showSnackBar(context, "Fail to register");
                              }
                            } else {
                              showSnackBar(context, "Email is used");
                            }
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(49, 49, 49, 1)),
                          ),
                        ),
                      ],
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
