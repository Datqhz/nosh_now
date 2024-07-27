import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/merchant_with_distance.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';
import 'package:nosh_now_application/data/repositories/merchant_repository.dart';
import 'package:nosh_now_application/presentation/widgets/category_item.dart';
import 'package:nosh_now_application/presentation/widgets/merchant_item.dart';

class FilterMerchantByCategoryScreen extends StatefulWidget {
  const FilterMerchantByCategoryScreen({super.key, this.init});

  final FoodCategory? init;

  @override
  State<FilterMerchantByCategoryScreen> createState() => _FilterMerchantByCategoryScreenState();
}

class _FilterMerchantByCategoryScreenState extends State<FilterMerchantByCategoryScreen> {
  // final TextEditingController _controller = TextEditingController();
  ValueNotifier<List<MerchantWithDistance>> merchants = ValueNotifier([]);
  late ValueNotifier<bool> isLoading;
  late ValueNotifier<FoodCategory?> categorySelected;
  @override
  void initState() {
    super.initState();
    categorySelected = ValueNotifier(widget.init);
    if (widget.init != null) {
      initWidget();
    } else {
      isLoading = ValueNotifier(false);
    }
  }

  Future<void> initWidget() async {
    isLoading = ValueNotifier(true);
    LatLng currentCoord = await checkPermissions();
    merchants.value = await MerchantRepository().getAllMerchantByCategory(
        widget.init!.categoryId,
        '${currentCoord.latitude}-${currentCoord.longitude}');
    isLoading.value = false;
  }

  Future<List<FoodCategory>> _fetchCategoryData() async {
    try {
      List<FoodCategory> categories = await CategoryRepository().getAll();
      return categories;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Container(
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
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1)),
                    ),
                    FutureBuilder(
                        future: _fetchCategoryData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return SizedBox(
                              height: 110,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () async {
                                    categorySelected.value =
                                        snapshot.data![index];
                                    merchants.value = [];
                                    isLoading.value = true;
                                    LatLng currentCoord =
                                        await checkPermissions();
                                    merchants.value = await MerchantRepository()
                                        .getAllMerchantByCategory(
                                            snapshot.data![index].categoryId,
                                            '${currentCoord.latitude}-${currentCoord.longitude}');
                                    isLoading.value = false;
                                  },
                                  child: CategoryItem(
                                    category: snapshot.data![index],
                                  ),
                                ),
                                itemCount: snapshot.data!.length,
                              ),
                            );
                          } else {
                            return const Center(
                              child: SpinKitCircle(
                                color: Colors.black,
                                size: 20,
                              ),
                            );
                          }
                        }),
                    const SizedBox(
                      height: 12,
                    ),
                    ValueListenableBuilder(
                        valueListenable: categorySelected,
                        builder: (context, value, child) {
                          if (value != null) {
                            return Text(
                              'Merchant buy ${value.categoryName}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const SizedBox();
                        }),
                    ValueListenableBuilder(
                        valueListenable: merchants,
                        builder: (context, value, child) {
                          return Column(
                            children: List.generate(value.length, (index) {
                              return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: MerchantItem(merchant: value[index]));
                            }),
                          );
                        }),
                    ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, value, child) {
                          if (value) {
                            return const Center(
                              child: SpinKitCircle(
                                color: Colors.black,
                                size: 50,
                              ),
                            );
                          }
                          return const SizedBox();
                        })
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // back
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              CupertinoIcons.arrow_left,
                              size: 24,
                              color: Color.fromRGBO(49, 49, 49, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            'Filter merchant',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(49, 49, 49, 1)),
                          ),
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
        ),
      ),
    );
  }
}
