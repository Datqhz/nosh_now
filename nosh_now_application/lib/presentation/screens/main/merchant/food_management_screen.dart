import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';
import 'package:nosh_now_application/presentation/widgets/food_management_item.dart';

class FoodManagementScreen extends StatefulWidget {
  const FoodManagementScreen({super.key});

  @override
  State<FoodManagementScreen> createState() => _FoodManagementScreenState();
}

class _FoodManagementScreenState extends State<FoodManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier _isShowSeachBar = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
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
                ValueListenableBuilder(
                    valueListenable: _isShowSeachBar,
                    builder: (context, value, child) {
                      if (value) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CupertinoIcons.xmark,
                                    color: Color.fromRGBO(49, 49, 49, 1),
                                    size: 18,
                                  )),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(159, 159, 159, 1),
                                    width: 1), // Màu viền khi không được chọn
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(159, 159, 159, 1),
                                  width: 1,
                                ),
                              ),
                              hintText: 'ex. Pho, Pizza',
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(49, 49, 49, 0.5)),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                color: Color.fromRGBO(49, 49, 49, 1),
                                fontSize: 14,
                                decoration: TextDecoration.none),
                            validator: (value) {},
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
                Row(
                  children: [
                    const Text(
                      'Your foods',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(49, 49, 49, 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          _isShowSeachBar.value = !_isShowSeachBar.value;
                        },
                        icon: const Icon(
                          CupertinoIcons.search,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                // list merchant
                ...List.generate(12, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FoodManagementItem(
                      food: dataTest,
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
                    size: 24,
                    color: Color.fromRGBO(49, 49, 49, 1),
                  ),
                ),
                // search merchant
                GestureDetector(
                  onTap: () {
                    // do something
                  },
                  child: const Icon(
                    CupertinoIcons.add,
                    size: 24,
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

Order orderFull = Order(
    orderId: 1,
    shipmentFee: 20000,
    eater: eater,
    merchant: merchants[0],
    coordinator: '232 - 234',
    orderedDate: DateTime.now(),
    orderStatus:
        OrderStatus(orderStatusId: 2, orderStatusName: 'Wait shipper', step: 1),
    totalPay: 100000,
    phone: '0947329732',
    shipper: shipper,
    paymentMethod: methods[0]);

Food dataTest = Food(
    foodId: 1,
    foodName: 'Pho',
    foodImage: 'assets/images/store_avatar.jpg',
    foodDescribe:
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
    price: 32000,
    status: 1);
