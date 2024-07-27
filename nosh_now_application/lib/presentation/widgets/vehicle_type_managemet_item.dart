import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/models/vehicle_type.dart';
import 'package:nosh_now_application/data/providers/vehicle_type_provider.dart';
import 'package:nosh_now_application/data/repositories/vehicle_type_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/food_detail_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/modify_food_screen.dart';
import 'package:provider/provider.dart';

class VehicleTypeManagementItem extends StatelessWidget {
  VehicleTypeManagementItem({super.key, required this.vehicleType});

  VehicleType vehicleType;
  ValueNotifier<XFile?> image = ValueNotifier(null);
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(159, 159, 159, 1),
            width: 1,
          ),
        ),
      ),
      child: Row(children: [
        // food image
        Expanded(
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(
                          convertBase64ToUint8List(vehicleType.icon)),
                      fit: BoxFit.cover),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                vehicleType.typeName,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: Color.fromRGBO(49, 49, 49, 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                _controller.text = vehicleType.typeName;
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Update category",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _controller,
                                  decoration: InputDecoration(
                                      hintText: 'Vehicle type name',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              width: 1)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              width: 2))),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    decoration: TextDecoration.none,
                                    decorationThickness: 0,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Category name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    XFile? img = await pickAnImageFromGallery();
                                    image.value = img;
                                  },
                                  child: ValueListenableBuilder(
                                      valueListenable: image,
                                      builder: (context, value, child) {
                                        return Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Image(
                                            image: value != null
                                                ? FileImage(File(value.path))
                                                    as ImageProvider<Object>
                                                : MemoryImage(
                                                    convertBase64ToUint8List(
                                                        vehicleType.icon)),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              const Expanded(
                                  child: SizedBox(
                                height: 1,
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.black.withOpacity(0.6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(153, 162, 232, 1)),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "CANCEL",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        VehicleType temp = vehicleType;
                                        temp.typeName = _controller.text.trim();
                                        if (image.value != null) {
                                          temp.icon = await convertToBase64(
                                              image.value!);
                                        }
                                        final rs = await VehicleTypeRepository()
                                            .update(temp);
                                        if (rs) {
                                          Provider.of<VehicleTypeListProvider>(
                                                  context,
                                                  listen: false)
                                              .updateVehicleType(
                                                  temp.typeId, temp);
                                          Navigator.pop(context);
                                          showSnackBar(
                                              context, "Save successful");
                                        }
                                        showSnackBar(
                                            context, "Can't save your data");
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(153, 162, 232, 1)),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "SAVE",
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Icon(
                CupertinoIcons.pencil,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            GestureDetector(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Delete vehicle type",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Do you want remove ${vehicleType.typeName}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              const Expanded(
                                  child: SizedBox(
                                height: 1,
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.black.withOpacity(0.8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.8)),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "CANCEL",
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      bool rs = await VehicleTypeRepository()
                                          .deleteVehicleType(
                                              vehicleType.typeId);
                                      if (rs) {
                                        Provider.of<VehicleTypeListProvider>(
                                                context,
                                                listen: false)
                                            .deleteVehicleType(
                                                vehicleType.typeId);
                                        showSnackBar(
                                            context, "Delete successful");
                                      } else {
                                        showSnackBar(context,
                                            "Can't delete this category");
                                      }
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(15, 40, 232, 1)),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: const Text(
                                      "YES",
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Icon(
                CupertinoIcons.trash,
                color: Colors.red,
                size: 24,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
