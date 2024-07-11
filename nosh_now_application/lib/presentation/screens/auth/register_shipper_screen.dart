import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/validate.dart';
import 'package:nosh_now_application/presentation/screens/auth/login_screen.dart';
import 'package:nosh_now_application/presentation/screens/auth/register_success.dart';

class RegisterShipperScreen extends StatefulWidget {
  const RegisterShipperScreen({super.key});

  @override
  State<RegisterShipperScreen> createState() => _RegisterShipperScreenState();
}

class _RegisterShipperScreenState extends State<RegisterShipperScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final ValueNotifier<XFile?> _avatar = ValueNotifier(null);
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  final List<String> _vehicleTypes = ['Motobikes', 'Car'];
  final ValueNotifier<String?> _typeSelected = ValueNotifier(null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _vehicleNameController.dispose();
    _avatar.dispose();
    _isObscure.dispose();
    _typeSelected.dispose();
    super.dispose();
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 70,
                          ),
                          //avatar
                          GestureDetector(
                            onTap: () async {
                              XFile? img = await pickAnImageFromGallery();
                              _avatar.value = img;
                            },
                            child: SizedBox(
                              height: 100,
                              child: Stack(
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: _avatar,
                                      builder: (context, value, child) {
                                        return CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 50,
                                          backgroundImage: value != null
                                              ? FileImage(File(value.path))
                                                  as ImageProvider<Object>
                                              : const AssetImage(
                                                  "assets/images/avatar.jpg"),
                                        );
                                      }),
                                  Positioned(
                                    bottom: 0,
                                    right: 16,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: const Icon(
                                        CupertinoIcons.pencil,
                                        size: 16,
                                        color: Color.fromRGBO(240, 240, 240, 1),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
                                    'Vehicle type',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // vehicle type input
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
                                    value: _typeSelected.value,
                                    items: _vehicleTypes
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      _typeSelected.value = value!;
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
                                    'Vehicle name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(55, 55, 55, 0.5),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  // vehicle name input
                                  TextFormField(
                                    controller: _vehicleNameController,
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
                                        return "Please enter your vehicle name.";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //button sign up
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
                                          print(
                                              'display name: $displayName - email: $email - password: $password - phone: $phone');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterSuccessScreen()));
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
                                      child: const Text('Sign up'),
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
