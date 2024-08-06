import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/merchant_with_distance.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';
import 'package:nosh_now_application/data/repositories/merchant_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/filter_merchant_by_category_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/search_merchant_screen.dart';
import 'package:nosh_now_application/presentation/widgets/category_item.dart';
import 'package:nosh_now_application/presentation/widgets/merchant_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<FoodCategory>> _fetchCategoryData() async {
    try {
      List<FoodCategory> types = await CategoryRepository().getAll();
      return types;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<MerchantWithDistance>> _fetchMerchantNearByData() async {
    try {
      LatLng currentCoord = await checkPermissions();
      print(currentCoord.toString());
      List<MerchantWithDistance> merchants = await MerchantRepository()
          .getAllMerchantNearby(
              '${currentCoord.latitude}-${currentCoord.longitude}');
      return merchants;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchCategoryData();
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          color: const Color.fromRGBO(240, 240, 240, 1),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: const Text(
                    'Categories for you',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(49, 49, 49, 1)),
                  ),
                ),
                FutureBuilder(
                    future: _fetchCategoryData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return SizedBox(
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FilterMerchantByCategoryScreen(
                                                init: snapshot.data![index])));
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
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: const Text(
                    'Some merchants near you',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(49, 49, 49, 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // list merchant
                ...[
                  FutureBuilder(
                      future: _fetchMerchantNearByData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Column(
                            children:
                                List.generate(snapshot.data!.length, (index) {
                              return GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MerchantDetailScreen(
                                        merchant: snapshot.data![index],
                                      ),
                                    ),
                                  )
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: MerchantItem(
                                    merchant: snapshot.data![index],
                                  ),
                                ),
                              );
                            }),
                          );
                        } else {
                          return const Center(
                            child: SpinKitCircle(
                              color: Colors.black,
                              size: 40,
                            ),
                          );
                        }
                      })
                ],
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            color: const Color.fromRGBO(240, 240, 240, 1),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // drawer
                GestureDetector(
                  onTap: () {
                    // do something
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(
                    CupertinoIcons.bars,
                    size: 22,
                    color: Color.fromRGBO(49, 49, 49, 1),
                  ),
                ),
                // search merchant
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SearchMerchantScreen()));
                  },
                  child: const Icon(
                    CupertinoIcons.search,
                    size: 22,
                    color: Color.fromRGBO(49, 49, 49, 1),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
