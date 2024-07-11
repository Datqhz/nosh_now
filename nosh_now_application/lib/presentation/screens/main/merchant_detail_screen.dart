import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/presentation/screens/main/food_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/food_item.dart';

class MerchantDetailScreen extends StatefulWidget {
  MerchantDetailScreen(
      {super.key,
      required this.avatar,
      required this.merchantName,
      required this.address,
      required this.distance,
      required this.category});

  String avatar;
  String merchantName;
  String address;
  double distance;
  String category;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // merchant avatar
                  Image(
                    image: AssetImage(widget.avatar),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width - 40,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color.fromRGBO(159, 159, 159, 1),
                            width: 0.4)),
                    transform: Matrix4.translationValues(0, -70, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // merchant name
                        Text(
                          widget.merchantName,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 80,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(159, 159, 159, 1),
                                ),
                                top: BorderSide(
                                  color: Color.fromRGBO(159, 159, 159, 1),
                                )),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_sharp,
                                color: Colors.red,
                                size: 20,
                              ),
                              //address
                              Text(
                                widget.address,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(49, 49, 49, 1),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            // distance to merchant
                            Text(
                              '${widget.distance} km',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Icon(
                              CupertinoIcons.circle_fill,
                              size: 4,
                              color: Color.fromRGBO(49, 49, 49, 1),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            // category name
                            Text(
                              widget.category,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        children: List.generate(12, (index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDetailScreen(
                                        foodImage:
                                            'assets/images/store_avatar.jpg',
                                        foodName: 'Pho',
                                        describe:
                                            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
                                        price: 32000,
                                        quantity: 4))),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: FoodItem(
                                imgPath: 'assets/images/store_avatar.jpg',
                                foodName: "Snacks",
                                price: 2.4,
                              ),
                            ),
                          );
                        })),
                  ),
                ],
              ),
            ),
            // App bar
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
