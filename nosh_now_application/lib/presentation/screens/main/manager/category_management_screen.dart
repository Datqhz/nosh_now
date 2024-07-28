import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/providers/category_list_provider.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';
import 'package:nosh_now_application/presentation/widgets/category_management_item.dart';
import 'package:provider/provider.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<XFile?> image = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryListProvider>(context, listen: false).fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Categories',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: Color.fromRGBO(49, 49, 49, 1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Consumer<CategoryListProvider>(
                    builder: (context, provider, child) {
                  if (provider.isLoading == true) {
                    return const Center(
                      child: SpinKitCircle(
                        color: Colors.black,
                        size: 50,
                      ),
                    );
                  }
                  return Column(
                    children:
                        List.generate(provider.categories.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CategoryManagementItem(
                          category: provider.categories[index],
                        ),
                      );
                    }),
                  );
                }),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // drawer
                      GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Icon(
                          CupertinoIcons.bars,
                          size: 24,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      ),
                      // search merchant
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
                                    height: 320,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          "Create category",
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
                                                hintText: 'Category name',
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight
                                                        .w400),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
                                                            width: 1)),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.8),
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
                                              XFile? img =
                                                  await pickAnImageFromGallery();
                                              image.value = img;
                                            },
                                            child: ValueListenableBuilder(
                                                valueListenable: image,
                                                builder:
                                                    (context, value, child) {
                                                  return Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6)),
                                                    child: Image(
                                                      image: value != null
                                                          ? FileImage(File(
                                                                  value.path))
                                                              as ImageProvider<
                                                                  Object>
                                                          : const AssetImage(
                                                              'assets/images/add_image_icon.png'),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black
                                                    .withOpacity(0.6),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        153, 162, 232, 1)),
                                                backgroundColor:
                                                    Colors.transparent,
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
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final name =
                                                      _controller.text.trim();
                                                  String base64 = '';
                                                  if (image.value != null) {
                                                    base64 =
                                                        await convertToBase64(
                                                            image.value!);
                                                  } else {
                                                    showSnackBar(context,
                                                        'Please choose type image');
                                                    return;
                                                  }
                                                  final rs =
                                                      await CategoryRepository()
                                                          .create(FoodCategory(
                                                              categoryId: 0,
                                                              categoryName:
                                                                  name,
                                                              categoryImage:
                                                                  base64));
                                                  if (rs != null) {
                                                    Provider.of<CategoryListProvider>(
                                                            context,
                                                            listen: false)
                                                        .addCategory(rs);
                                                    Navigator.pop(context);
                                                    showSnackBar(context,
                                                        "Save successful");
                                                    _controller.text = '';
                                                    image.value = null;
                                                  } else {
                                                    showSnackBar(context,
                                                        "Can't save your data");
                                                  }
                                                }
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                textStyle: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        153, 162, 232, 1)),
                                                backgroundColor:
                                                    Colors.transparent,
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
                          CupertinoIcons.add,
                          size: 24,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
