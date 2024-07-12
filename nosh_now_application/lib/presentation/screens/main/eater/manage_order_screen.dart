import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/order_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';
import 'package:nosh_now_application/presentation/widgets/category_item.dart';
import 'package:nosh_now_application/presentation/widgets/merchant_item.dart';
import 'package:nosh_now_application/presentation/widgets/order_item.dart';

class ManageOrderScreen extends StatelessWidget {
  const ManageOrderScreen({super.key});

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
                const Row(
                  children: [
                    Text(
                      'Your orders',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(49, 49, 49, 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      'Newest',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(49, 49, 49, 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.sort_down,
                      color: Color.fromRGBO(49, 49, 49, 1),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                // list merchant
                ...List.generate(12, (index) {
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(
                            order: orderFull,
                          ),
                        ),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: OrderItem(
                        order: orderFull,
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
