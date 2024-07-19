import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nosh_now_application/core/streams/change_stream.dart';
import 'package:nosh_now_application/core/utils/dash_line_painter.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/order.dart';
import 'package:nosh_now_application/data/models/location.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/data/models/payment_method.dart';
import 'package:nosh_now_application/data/models/shipper.dart';
import 'package:nosh_now_application/data/models/vehicle_type.dart';
import 'package:nosh_now_application/data/repositories/payment_method_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/order_process.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/pick_location.dart';
import 'package:nosh_now_application/presentation/widgets/order_detail_item.dart';

class PrepareOrderScreen extends StatefulWidget {
  PrepareOrderScreen({super.key, required this.order});

  Order order;

  @override
  State<PrepareOrderScreen> createState() => _PrepareOrderScreenState();
}

class _PrepareOrderScreenState extends State<PrepareOrderScreen> {
  ValueNotifier<PaymentMethod?> currentSelected = ValueNotifier(null);

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
                  const SizedBox(
                    height: 66,
                  ),
                  // current delivery infomation
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickLocationScreen(
                                  currentPick: location,
                                ))),
                    child: Container(
                      height: 80,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_sharp,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Home - 0348573134',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(49, 49, 49, 1),
                                    overflow: TextOverflow.ellipsis),
                              ),
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
                          Expanded(
                              child: SizedBox(
                            width: 12,
                          )),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.red,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // List detail item
                  ...List.generate(7, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: OrderDetailItem(
                        detail: details[0],
                        isEdit: true,
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 270,
                  )
                ],
              ),
            ),
            //app bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.order.merchant.displayName,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          'Distance to your location: ${calcDistanceInKm(coordinator1: widget.order.merchant.coordinator, coordinator2: '232 - 234')} km',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // substantial bill
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(
                      height: 12,
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
                    const SizedBox(
                      height: 20,
                    ),
                    CustomPaint(
                      size: const Size(double.infinity, 1),
                      painter: DashedLinePainter(
                          dashWidth: 5.0,
                          dashSpace: 3.0,
                          color: Colors.black,
                          strokeWidth: 1),
                    ),
                    const SizedBox(
                      height: 20,
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
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      child: const Text(
                        'Payment',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FutureBuilder(
                        future: PaymentMethodRepository().getAll(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(
                                    color: Color.fromRGBO(120, 120, 120, 1),
                                    width: 0.6),
                              )),
                              child: Row(
                                children: [
                                  Image.memory(
                                    convertBase64ToUint8List(
                                        snapshot.data![0].methodImage),
                                    height: 18,
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'Pay via ${snapshot.data![0].methodName}',
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  const Icon(
                                    CupertinoIcons.chevron_forward,
                                    color: Colors.black,
                                    size: 18,
                                  )
                                ],
                              ),
                            );
                          }
                          return Row(
                            children: [],
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 44,
                      child: TextButton(
                        onPressed: () {
                          Order tempOrder = widget.order;
                          tempOrder.coordinator = '232 - 234';
                          tempOrder.orderStatus = OrderStatus(
                              orderStatusId: 2,
                              orderStatusName: 'Wait shipper',
                              step: 1);
                          tempOrder.totalPay = 100000;
                          tempOrder.phone = '0947329732';
                          tempOrder.shipper = shipper;
                          tempOrder.paymentMethod = methods[0];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderProcessScreen(order: tempOrder)));
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: const Text('Checkout'),
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

Location location = Location(
    locationId: 1,
    locationName: 'Home',
    coordinator: '223 - 432',
    phone: '0943382223',
    defaultLocation: false);

Shipper shipper = Shipper(
    shipperId: 1,
    displayName: 'Dat',
    email: 'gatanai@gmail.com',
    phone: '0983473223',
    avatar: 'assets/images/avatar.jpg',
    vehicleName: 'YAMAHA SURIUS 2024',
    momoPayment: '0112548325',
    coordinator: '322 - 455',
    vehicleType: VehicleType(
        typeId: 1, typeName: 'Motobikes', icon: 'assets/images/motocycle.png'));
List<PaymentMethod> methods = [
  PaymentMethod(
      methodId: 1, methodName: 'Cash', methodImage: 'assets/images/wallet.png'),
  PaymentMethod(
      methodId: 2, methodName: 'Momo', methodImage: 'assets/images/momo.webp')
];
