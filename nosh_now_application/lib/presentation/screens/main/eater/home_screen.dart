import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/merchant_with_distance.dart';
import 'package:nosh_now_application/data/repositories/category_repository.dart';
import 'package:nosh_now_application/data/repositories/merchant_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/category_item.dart';
import 'package:nosh_now_application/presentation/widgets/merchant_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
      List<MerchantWithDistance> merchants =
          await MerchantRepository().getAllMerchantNearby('0-0');
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
                const Text(
                  'Categories for you',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(49, 49, 49, 1)),
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
                            itemBuilder: (context, index) => CategoryItem(
                              category: snapshot.data![index],
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
                const Text(
                  'Some merchants are near you',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(49, 49, 49, 1),
                    overflow: TextOverflow.ellipsis,
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
                  },
                  child: const Icon(
                    CupertinoIcons.bars,
                    size: 22,
                    color: Color.fromRGBO(49, 49, 49, 1),
                  ),
                ),
                // search merchant
                GestureDetector(
                  onTap: () {
                    // do something
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

List<Merchant> merchants = [
  Merchant(
      merchantId: 1,
      displayName: 'Pho 10 Ly Quoc Su',
      email: 'gatanai@gmail.com',
      phone: '0983473223',
      avatar: 'assets/images/store_avatar.jpg',
      openingTime: '7:30',
      closingTime: '18:00',
      coordinator: '322 - 455',
      category: categories[0])
];
List<FoodCategory> categories = [
  FoodCategory(
      categoryId: 1,
      categoryName: 'Pho - Chao - Hau',
      categoryImage: 'assets/images/pho.png')
];
