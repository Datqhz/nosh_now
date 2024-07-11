import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/category_item.dart';
import 'package:nosh_now_application/presentation/widgets/merchant_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                // list category
                SizedBox(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => CategoryItem(
                        imgPath: 'assets/images/pho.png',
                        categoryName: 'Pho - Chao - Hau'),
                    itemCount: 12,
                  ),
                ),
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
                ...List.generate(12, (index) {
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MerchantDetailScreen(
                                    avatar: 'assets/images/store_avatar.jpg',
                                    merchantName: "Pho 10 Ly Quoc Su",
                                    distance: 2.4,
                                    address:
                                        '97 Man Thien - Hiep Phu ward - Thu Duc city',
                                    category: 'Snacks',
                                  )))
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: MerchantItem(
                        imgPath: 'assets/images/store_avatar.jpg',
                        categoryName: "Snacks",
                        km: 2.4,
                        merchantName: 'Pho 10 Ly Quoc Su',
                      ),
                    ),
                  );
                }),
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
                    size: 20,
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
                    size: 20,
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
