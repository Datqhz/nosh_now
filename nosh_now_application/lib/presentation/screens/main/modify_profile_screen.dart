import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/core/utils/time_picker.dart';
import 'package:nosh_now_application/core/utils/validate.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/vehicle_type.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';
import 'package:nosh_now_application/data/repositories/vehicle_type_repository.dart';
import 'package:nosh_now_application/presentation/screens/auth/pick_location_register_screen.dart';

class ModifyProfileScreen extends StatefulWidget {
  const ModifyProfileScreen({super.key});

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  // final TextEditingController _momoPaymentController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();
  ValueNotifier<XFile?> avatar = ValueNotifier(null);
  ValueNotifier<String> coordinator = ValueNotifier('');
  List<dynamic> _dropdownItems = [];
  final ValueNotifier<String?> _itemSelected = ValueNotifier(null);

  Future<void> fetchDropdownData() async {
    if (GlobalVariable.roleId == 3) {
      _dropdownItems = await CategoryRepository().getAll();
      for (var item in _dropdownItems) {
        if (item.categoryId == GlobalVariable.user.category.categoryId) {
          _itemSelected.value = item.categoryName;
        }
      }
    } else if (GlobalVariable.roleId == 4) {
      _dropdownItems = await VehicleTypeRepository().getAll();
      for (var item in _dropdownItems) {
        if (item.typeId == GlobalVariable.user.vehicleType.typeId) {
          _itemSelected.value = item.typeName;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchDropdownData();
    super.initState();
  }

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
                                                : MemoryImage(
                                                    convertBase64ToUint8List(
                                                        GlobalVariable
                                                            .user.avatar)),
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
                                    if (GlobalVariable.roleId != 2)
                                      Text(
                                        GlobalVariable.roleId == 3
                                            ? 'Category'
                                            : 'Vehicle type',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromRGBO(55, 55, 55, 0.5),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    // category input
                                    if (GlobalVariable.roleId != 2)
                                      DropdownButtonFormField<String>(
                                        dropdownColor: Colors.white,
                                        style: const TextStyle(
                                          color: Color.fromRGBO(49, 49, 49, 1),
                                        ),
                                        icon: const Icon(
                                          CupertinoIcons.chevron_down,
                                          size: 14,
                                          color:
                                              Color.fromRGBO(118, 118, 118, 1),
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
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1)),
                                        ),
                                        value: _itemSelected.value,
                                        items: _dropdownItems
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value:
                                                      GlobalVariable.roleId == 3
                                                          ? item.categoryName
                                                          : item.typeName,
                                                  child: Text(
                                                    GlobalVariable.roleId == 3
                                                        ? item.categoryName
                                                        : item.typeName,
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          _itemSelected.value = value!;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select an option';
                                          }
                                          return null;
                                        },
                                      ),
                                    if (GlobalVariable.roleId == 3) ...[
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
                                      if (GlobalVariable.roleId == 3)
                                        TextFormField(
                                          onTap: () async {
                                            dynamic latlng = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PickLocationRegisterScreen()));
                                            String address =
                                                await getAddressFromLatLng(
                                                    latlng);
                                            _addressController.text = address;
                                            coordinator.value =
                                                '${latlng.latitude}-${latlng.longitude}';
                                          },
                                          controller: _addressController,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            suffixIcon: Icon(
                                                CupertinoIcons.map_pin_ellipse),
                                            suffixStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    49, 49, 49, 1)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      118, 118, 118, 1),
                                                  width:
                                                      1), // Màu viền khi không được chọn
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    35, 35, 35, 1),
                                                width: 1,
                                              ),
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    182, 0, 0, 1),
                                                width: 1,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    182, 0, 0, 1),
                                                width: 1,
                                              ),
                                            ),
                                            errorStyle: TextStyle(
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
                                            color:
                                                Color.fromRGBO(55, 55, 55, 0.5),
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
                                              color:
                                                  Color.fromRGBO(35, 35, 35, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1)),
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(49, 49, 49, 1),
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
                                            color:
                                                Color.fromRGBO(55, 55, 55, 0.5),
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
                                              color:
                                                  Color.fromRGBO(35, 35, 35, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1)),
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(49, 49, 49, 1),
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter choose your closing time.";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                    if (GlobalVariable.roleId == 4) ...[
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      const Text(
                                        'Vehicle name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromRGBO(55, 55, 55, 0.5),
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
                                              color:
                                                  Color.fromRGBO(35, 35, 35, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1),
                                              width: 1,
                                            ),
                                          ),
                                          errorStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(182, 0, 0, 1)),
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(49, 49, 49, 1),
                                            fontSize: 14,
                                            decoration: TextDecoration.none),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter your vehicle name.";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
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
