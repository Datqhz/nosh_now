import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/validate.dart';

class ModifyProfileScreen extends StatefulWidget {
  const ModifyProfileScreen({super.key});

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  ValueNotifier<XFile?> avatar = ValueNotifier(null);
  ValueNotifier<String> coordinator = ValueNotifier('');
  final ValueNotifier<bool> _isObscure = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
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
                                avatar.value = img;
                              },
                              child: SizedBox(
                                height: 100,
                                child: Stack(
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable: avatar,
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
                                          color:
                                              Color.fromRGBO(240, 240, 240, 1),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Display name',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(55, 55, 55, 0.5),
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
                                            color:
                                                Color.fromRGBO(35, 35, 35, 1),
                                            width: 1,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(182, 0, 0, 1),
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(182, 0, 0, 1),
                                            width: 1,
                                          ),
                                        ),
                                        errorStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(182, 0, 0, 1)),
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
                                          color:
                                              Color.fromRGBO(55, 55, 55, 0.5),
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
                                            color:
                                                Color.fromRGBO(35, 35, 35, 1),
                                            width: 1,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(182, 0, 0, 1),
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(182, 0, 0, 1),
                                            width: 1,
                                          ),
                                        ),
                                        errorStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(182, 0, 0, 1)),
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
                                          color:
                                              Color.fromRGBO(55, 55, 55, 0.5),
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
                                                    ? const Icon(CupertinoIcons
                                                        .eye_slash)
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
                                                color: Color.fromRGBO(
                                                    49, 49, 49, 1),
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.none),
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
                                          color:
                                              Color.fromRGBO(55, 55, 55, 0.5),
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
                                            color:
                                                Color.fromRGBO(35, 35, 35, 1),
                                            width: 1,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(182, 0, 0, 1),
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromRGBO(182, 0, 0, 1),
                                            width: 1,
                                          ),
                                        ),
                                        errorStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(182, 0, 0, 1)),
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
                                      'Address',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(55, 55, 55, 0.5),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    // address input
                                    TextFormField(
                                      controller: _addressController,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(
                                            CupertinoIcons.map_pin_ellipse),
                                        suffixStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(49, 49, 49, 1)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  118, 118, 118, 1),
                                              width:
                                                  1), // Màu viền khi không được chọn
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(35, 35, 35, 1),
                                            width: 1,
                                          ),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                          color: Color.fromRGBO(49, 49, 49, 1),
                                          fontSize: 14,
                                          decoration: TextDecoration.none),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            CupertinoIcons.arrow_left,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          'Edit profile',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              final displayName =
                                  _displayNameController.text.trim();
                              final email = _displayNameController.text.trim();
                              final password = _passwordController.text.trim();
                              final phone = _displayNameController.text.trim();
                              print(
                                  'display name: $displayName - email: $email - password: $password - phone: $phone - address: ${coordinator.value}');
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Save',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
