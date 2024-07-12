import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/utils/dash_line_painter.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/core/utils/order.dart';
import 'package:nosh_now_application/data/models/location.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/order_detail_item.dart';
import 'package:nosh_now_application/presentation/widgets/status_item.dart';

class OrderProcessScreen extends StatefulWidget {
  OrderProcessScreen({super.key, required this.order});

  Order order;

  @override
  State<OrderProcessScreen> createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 66,
                    ),
                    // current delivery infomation
                    Stack(
                      children: [
                        Positioned(
                          top: 88,
                          left: 0,
                          right: 0,
                          child: CustomPaint(
                            size: const Size(double.infinity, 1),
                            painter: DashedLinePainter(
                                dashWidth: 8.0,
                                dashSpace: 5.0,
                                color: Color.fromRGBO(247, 205, 99, 1),
                                strokeWidth: 3),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusItem(
                              status: OrderStatus(
                                  orderStatusId: 1,
                                  orderStatusName: 'Waiting shipper',
                                  step: 1),
                              content: 'Eater orders',
                              icon: CupertinoIcons.device_phone_portrait,
                              isActive: true,
                            ),
                            StatusItem(
                              status: OrderStatus(
                                  orderStatusId: 2,
                                  orderStatusName: 'Waiting shipper',
                                  step: 2),
                              content:
                                  'Merchant start cooking without waiting for driver to arrives',
                              icon: Icons.cookie_outlined,
                              isActive: false,
                            ),
                            StatusItem(
                              status: OrderStatus(
                                  orderStatusId: 3,
                                  orderStatusName: 'Waiting shipper',
                                  step: 3),
                              content:
                                  'Driver pickup food and deliver to the eater',
                              icon: Icons.delivery_dining_outlined,
                              isActive: false,
                            ),
                            StatusItem(
                              status: OrderStatus(
                                  orderStatusId: 4,
                                  orderStatusName: 'Waiting shipper',
                                  step: 4),
                              content: 'Eater receives and enjoy your food!',
                              icon: CupertinoIcons.cube,
                              isActive: false,
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    // delivery infomation
                    const Text(
                      'Delivery info',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        // eater avatar
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(widget.order.eater.avatar),
                                fit: BoxFit.cover),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // phone
                              Text(
                                'Phone: ${widget.order.phone!}',
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
                                height: 6,
                              ),
                              const Text(
                                'Address: 97 Man Thien, Hiep Phu ward, Thu Duc city',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    // shipper infomation
                    const Text(
                      'Driver',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        // shipper avatar
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(widget.order.shipper!.avatar),
                                fit: BoxFit.cover),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // shipper name
                              Text(
                                widget.order.shipper!.displayName,
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
                              const SizedBox(
                                height: 6,
                              ),
                              //vehicle name
                              Text(
                                widget.order.shipper!.vehicleName,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Expanded(
                            child: SizedBox(
                          width: 12,
                        )),
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    // List detail item
                    ...List.generate(7, (index) {
                      return OrderDetailItem(detail: details[0]);
                    }),
                    const SizedBox(
                      height: 270,
                    )
                  ],
                ),
              ),
            ),
            //app bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Text(
                      'Pho 10 Ly Quoc Su',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
            // substantial bill
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 260,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            color: Color.fromRGBO(159, 159, 159, 1))),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Substantial',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(120, 120, 120, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          '${calcSubtantial(details)}₫',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(120, 120, 120, 1),
                              overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(120, 120, 120, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          '${calcSubtantial(details)}₫',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(120, 120, 120, 1),
                              overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: DashedLinePainter(
                          dashWidth: 5.0,
                          dashSpace: 3.0,
                          color: Colors.black,
                          strokeWidth: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          '${calcTotalPay(details, widget.order.shipmentFee!)}₫',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 44,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
