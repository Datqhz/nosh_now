// ignore_for_file: unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/dash_line_painter.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/core/utils/order.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/location.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/data/models/payment_method.dart';
import 'package:nosh_now_application/data/repositories/location_repository.dart';
import 'package:nosh_now_application/data/repositories/order_detail_repository.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/data/repositories/payment_method_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/choose_payment_method_screen.dart';
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
  ValueNotifier<List<GlobalKey<OrderDetailItemState>>> detailItemKeys =
      ValueNotifier([]);
  ValueNotifier<PaymentMethod?> currentSelected = ValueNotifier(null);
  ValueNotifier<double> substantial = ValueNotifier(0);
  ValueNotifier<double> delivery = ValueNotifier(0);
  ValueNotifier<double> total = ValueNotifier(0);
  ValueNotifier<Location?> currentLocationPicked = ValueNotifier(null);
  ValueNotifier<bool> isInit = ValueNotifier(true);

  void calcSubstantialOnChange() {
    double subs = 0;
    if (detailItemKeys.value.isEmpty) {
      return;
    }
    for (var i in detailItemKeys.value) {
      subs += i.currentState!.calcTotal();
    }
    substantial.value = subs;
    total.value = subs + delivery.value;
    isInit.value = false;
  }

  List<OrderDetail> getFinalDetails() {
    List<OrderDetail> rs = [];
    for (var i in detailItemKeys.value) {
      rs.add(i.currentState!.getCurrentDetail());
    }
    return rs;
  }

  void calcDeliveryOnChange() {
    if (currentLocationPicked.value != null) {
      getRouteCoordinates(
              splitCoordinatorString(widget.order.merchant.coordinator),
              splitCoordinatorString(currentLocationPicked.value!.coordinator))
          .then((route) {
        double distance = calculateTotalDistanceByRoute(route);
        if (distance < 1) {
          delivery.value = 15000;
        } else {
          delivery.value = distance * 15000;
        }
        double shipmentFee = distance * 15000;

        delivery.value = shipmentFee;
      });
    } else {
      delivery.value = 0;
    }
  }

  void calcTotal() {
    total.value = substantial.value + delivery.value;
  }

  // void calcDelivery(){
  //   double de = 0;
  //   substantial.value = subs;
  //   total.value = subs + delivery.value;
  // }
  @override
  void initState() {
    super.initState();
    currentLocationPicked.addListener(calcDeliveryOnChange);
    substantial.addListener(calcTotal);
    delivery.addListener(calcTotal);
  }

  @override
  void dispose() {
    detailItemKeys.removeListener(calcSubstantialOnChange);
    currentLocationPicked.removeListener(calcDeliveryOnChange);
    substantial.removeListener(calcTotal);
    delivery.removeListener(calcTotal);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 66,
                    ),
                    // current delivery infomation
                    FutureBuilder(
                        future: LocationRepository().getDefaultLocationByEater(
                            GlobalVariable.currentUid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            currentLocationPicked.value ??= snapshot.data!;
                            return GestureDetector(
                              onTap: () async {
                                var newPicked = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PickLocationScreen(
                                      currentPick: currentLocationPicked.value!,
                                    ),
                                  ),
                                );
                                if (newPicked != null) {
                                  currentLocationPicked.value = newPicked;
                                }
                              },
                              child: ValueListenableBuilder(
                                  valueListenable: currentLocationPicked,
                                  builder: (context, value, child) {
                                    return Container(
                                      height: 80,
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on_sharp,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${value!.locationName} - ${value.phone}',
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        49, 49, 49, 1),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              FutureBuilder(
                                                  future: getAddressFromLatLng(
                                                      splitCoordinatorString(
                                                          value.coordinator)),
                                                  builder: (context,
                                                      addressSnapshot) {
                                                    if (addressSnapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done &&
                                                        addressSnapshot
                                                            .hasData) {
                                                      return Text(
                                                        addressSnapshot.data!,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Color.fromRGBO(
                                                                    49,
                                                                    49,
                                                                    49,
                                                                    1),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      );
                                                    }
                                                    return const Text('');
                                                  }),
                                            ],
                                          ),
                                          const Expanded(
                                              child: SizedBox(
                                            width: 12,
                                          )),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                          return const SpinKitThreeInOut(
                            color: Colors.black,
                            size: 30,
                          );
                        }),
                    const SizedBox(
                      height: 12,
                    ),
                    // List detail item
                    FutureBuilder(
                        future: OrderDetailRepository()
                            .getAllByOrderId(widget.order.orderId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            detailItemKeys.value = List.generate(
                                snapshot.data!.length,
                                (index) => GlobalKey<OrderDetailItemState>());
                            detailItemKeys.addListener(calcSubstantialOnChange);
                            return Column(
                                children: List.generate(
                              snapshot.data!.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: OrderDetailItem(
                                    key: detailItemKeys.value[index],
                                    detail: snapshot.data![index],
                                    isEdit: true,
                                    onChange: calcSubstantialOnChange),
                              ),
                            ));
                          }
                          return const Center(
                            child: SpinKitCircle(
                              color: Colors.black,
                              size: 30,
                            ),
                          );
                        }),

                    const SizedBox(
                      height: 320,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 50),
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
                          FutureBuilder(
                              future: checkPermissions(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Text(
                                    'Distance to your location: ${calcDistanceInKm(coordinator1: widget.order.merchant.coordinator, coordinator2: '${snapshot.data!.latitude}-${snapshot.data!.longitude}')} km',
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        overflow: TextOverflow.ellipsis),
                                  );
                                }
                                return const SizedBox();
                              })
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
                          ValueListenableBuilder(
                              valueListenable: substantial,
                              builder: (context, value, child) {
                                if (isInit.value == true) {
                                  calcDeliveryOnChange();
                                }
                                return Text(
                                  '$value₫',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(120, 120, 120, 1),
                                      overflow: TextOverflow.ellipsis),
                                );
                              })
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
                          ValueListenableBuilder<double>(
                            valueListenable: delivery,
                            builder: (context, value, child) {
                              return Text(
                                NumberFormat.simpleCurrency(
                                        locale: 'vi_VN', decimalDigits: 0)
                                    .format(value),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(120, 120, 120, 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
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
                          ValueListenableBuilder<double>(
                            valueListenable: total,
                            builder: (context, value, child) {
                              return Text(
                                NumberFormat.simpleCurrency(
                                        locale: 'vi_VN', decimalDigits: 0)
                                    .format(value),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
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
                              currentSelected.value ??= snapshot.data![0];
                              return GestureDetector(
                                onTap: () async {
                                  PaymentMethod method = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChoosePaymentMethodScreen(
                                                  currentPick:
                                                      currentSelected.value!)));
                                  currentSelected.value = method;
                                },
                                child: ValueListenableBuilder(
                                    valueListenable: currentSelected,
                                    builder: (context, value, child) {
                                      return Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  120, 120, 120, 1),
                                              width: 0.6),
                                        )),
                                        child: Row(
                                          children: [
                                            Image.memory(
                                              convertBase64ToUint8List(
                                                  value!.methodImage),
                                              height: 18,
                                              width: 18,
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              'Pay via ${value.methodName}',
                                              maxLines: 1,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color.fromRGBO(
                                                      49, 49, 49, 1),
                                                  overflow:
                                                      TextOverflow.ellipsis),
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
                                    }),
                              );
                            }
                            return const Row(
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
                          onPressed: () async {
                            List<OrderDetail> list = getFinalDetails();

                            Order tempOrder = widget.order;
                            tempOrder.coordinator =
                                currentLocationPicked.value!.coordinator;
                            tempOrder.orderStatus = OrderStatus(
                                orderStatusId: 2,
                                orderStatusName: 'Wait shipper',
                                step: 1);
                            tempOrder.totalPay = 0;
                            tempOrder.shipmentFee = 20000;
                            tempOrder.phone =
                                currentLocationPicked.value!.phone;
                            tempOrder.paymentMethod = currentSelected.value;
                            bool updateDetailsRs = await OrderDetailRepository()
                                .updateMultiple(list);
                            if (updateDetailsRs) {
                              bool updateOrder =
                                  await OrderRepository().update(tempOrder);
                              if (updateOrder) {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrderProcessScreen(
                                              order: widget.order,
                                              type: 1,
                                            )));
                              } else {
                                showSnackBar(context,
                                    'Something error when order foods');
                              }
                            }
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             OrderProcessScreen(order: tempOrder, type: 1,)));
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
      ),
    );
  }
}
