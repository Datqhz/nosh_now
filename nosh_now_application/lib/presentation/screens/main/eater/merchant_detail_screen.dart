import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/data/models/eater.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/food_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';
import 'package:nosh_now_application/presentation/widgets/food_item.dart';

class MerchantDetailScreen extends StatefulWidget {
  MerchantDetailScreen({super.key, required this.merchant});

  Merchant merchant;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  Order? order;

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
                    image: AssetImage(widget.merchant.avatar),
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
                          widget.merchant.displayName,
                          maxLines: 1,
                          style: const TextStyle(
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
                          child: const Row(
                            children: [
                              Icon(
                                Icons.location_on_sharp,
                                color: Colors.red,
                                size: 20,
                              ),
                              //address
                              Text(
                                '97 Man Thien, Hiep Phu ward, Thu Duc city',
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
                              '${calcDistanceInKm(coordinator1: widget.merchant.coordinator, coordinator2: '324 - 323')} km',
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
                              widget.merchant.category!.categoryName,
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
                                  food: foods[0],
                                  orderDetail: details[0],
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: FoodItem(
                                food: foods[0],
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
            ),
            // preview order
            Positioned(
              bottom: 80,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrepareOrderScreen(
                                order: orderData,
                              )));
                },
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        CupertinoIcons.news,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          height: 22,
                          width: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 163, 59, 1),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            '${details.length}',
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<Food> foods = [
  Food(
      foodId: 1,
      foodName: 'Pho',
      foodImage: 'assets/images/store_avatar.jpg',
      foodDescribe:
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
      price: 32000,
      status: 1)
];
List<OrderDetail> details = [
  OrderDetail(odId: 1, orderId: 1, price: 32000, quantity: 3, food: foods[0])
];
Order orderData = Order(
    orderId: 1,
    totalPay: 0,
    shipmentFee: 20000,
    orderStatus:
        OrderStatus(orderStatusId: 1, orderStatusName: 'Initialize', step: 0),
    eater: eater,
    merchant: merchants[0]);
Eater eater = Eater(
  eaterId: 1,
  displayName: 'Pho 10 Ly Quoc Su',
  email: 'gatanai@gmail.com',
  phone: '0983473223',
  avatar: 'assets/images/store_avatar.jpg',
);
