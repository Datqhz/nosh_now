import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/streams/change_stream.dart';
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
import 'package:nosh_now_application/data/repositories/order_detail_repository.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/data/repositories/order_status_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/order_detail_item.dart';
import 'package:nosh_now_application/presentation/widgets/status_item.dart';

class OrderProcessScreen extends StatefulWidget {
  OrderProcessScreen(
      {super.key, required this.order, required this.type, this.callback});

  Order order;
  int type; // 1 is eater, 2 is shipper
  Function? callback;

  @override
  State<OrderProcessScreen> createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> {
  late ValueNotifier<Order?> order = ValueNotifier(null);
  ValueNotifier<List<OrderDetail>> orderDetails = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    fetchOrderData();
    fetchOrderDetailData();
  }

  Future<void> fetchOrderData() async {
    order.value = await OrderRepository().getById(widget.order.orderId);
  }

  Future<void> fetchOrderDetailData() async {
    orderDetails.value =
        await OrderDetailRepository().getAllByOrderId(widget.order.orderId);
  }

  IconData pickItemForStatus(int step) {
    switch (step) {
      case 1:
        return CupertinoIcons.device_phone_portrait;
      case 2:
        return Icons.cookie_outlined;
      case 3:
        return Icons.delivery_dining_outlined;
      case 4:
        return CupertinoIcons.cube;
      default:
        return CupertinoIcons.device_phone_portrait;
    }
  }

  Future<void> reload() async {
    if (widget.callback != null) {
      print("step 1");
      widget.callback!();
    }
    print("step 2");
    await fetchOrderData();
    print("done");
  }

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
                    // current order infomation
                    //buider
                    ValueListenableBuilder(
                        valueListenable: order,
                        builder: (context, value, child) {
                          if (value != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                            color:
                                                Color.fromRGBO(247, 205, 99, 1),
                                            strokeWidth: 3),
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: OrderStatusRepository()
                                            .getAllWithoutInitStatusAndCancel(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                snapshot.data!.length,
                                                (index) => StatusItem(
                                                  status: snapshot.data![index],
                                                  content: snapshot.data![index]
                                                      .orderStatusName,
                                                  icon: pickItemForStatus(
                                                      snapshot
                                                          .data![index].step),
                                                  isActive: (snapshot
                                                              .data![index]
                                                              .step <=
                                                          value.orderStatus
                                                              .step &&
                                                      value.orderStatus.step !=
                                                          5),
                                                ),
                                              ),
                                            );
                                          }
                                          return const SpinKitThreeInOut(
                                            color: Colors.black,
                                            size: 30,
                                          );
                                        })
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
                                            image: MemoryImage(
                                                convertBase64ToUint8List(
                                                    value.eater.avatar)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //eater name
                                          Text(
                                            'Name: ${value.eater.displayName}',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                              color:
                                                  Color.fromRGBO(49, 49, 49, 1),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          // phone
                                          Text(
                                            'Phone: ${value.phone!}',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                              color:
                                                  Color.fromRGBO(49, 49, 49, 1),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          FutureBuilder(
                                              future: getAddressFromLatLng(
                                                  splitCoordinatorString(
                                                      value.coordinator!)),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState.done &&
                                                    snapshot.hasData) {
                                                  return Text(
                                                    snapshot.data!,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.2,
                                                      color: Color.fromRGBO(
                                                          49, 49, 49, 1),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // value builder
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
                                if (widget.order.shipper != null)
                                  Row(
                                    children: [
                                      // shipper avatar
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: MemoryImage(
                                                  convertBase64ToUint8List(
                                                      widget.order.shipper!
                                                          .avatar)),
                                              // image:
                                              //     AssetImage(widget.order.shipper!.avatar),
                                              fit: BoxFit.cover),
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                color: Color.fromRGBO(
                                                    49, 49, 49, 1),
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
                                                color: Color.fromRGBO(
                                                    49, 49, 49, 1),
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
                                if (widget.order.shipper == null)
                                  const Text(
                                    "Your order hasn't been picked up yet",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        overflow: TextOverflow.ellipsis),
                                  )
                              ],
                            );
                          }
                          return const SpinKitCircle(
                            color: Colors.black,
                            size: 50,
                          );
                        }),

                    const Divider(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    // List detail item
                    ValueListenableBuilder(
                        valueListenable: orderDetails,
                        builder: (context, value, child) {
                          return Column(
                            children: List.generate(value.length, (index) {
                              return OrderDetailItem(detail: value[index]);
                            }),
                          );
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
                    ValueListenableBuilder(
                        valueListenable: order,
                        builder: (context, value, chid) {
                          if (value != null) {
                            return Text(
                              value.merchant.displayName,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis),
                            );
                          }
                          return const SizedBox();
                        }),
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
                        ValueListenableBuilder(
                            valueListenable: orderDetails,
                            builder: (context, value, child) {
                              return Text(
                                '${calcSubtantial(value)}₫',
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
                        ValueListenableBuilder(
                            valueListenable: order,
                            builder: (context, value, child) {
                              return Text(
                                '${value != null ? value.shipmentFee : ''}₫',
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
                        ValueListenableBuilder(
                            valueListenable: order,
                            builder: (context, value, child) {
                              if (value != null) {
                                return Text(
                                  '${double.parse((value!.totalPay).toStringAsFixed(2))}₫',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(49, 49, 49, 1),
                                      overflow: TextOverflow.ellipsis),
                                );
                              }
                              return const SpinKitCircle(
                                color: Colors.black,
                                size: 10,
                              );
                            })
                      ],
                    ),
                    if (GlobalVariable.roleId != 3)
                      ValueListenableBuilder(
                          valueListenable: order,
                          builder: (context, value, child) {
                            if (value != null && value.orderStatus.step < 2) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                height: 44,
                                child: TextButton(
                                  onPressed: () async {
                                    if (order.value != null) {
                                      if (widget.type == 1) {
                                        Order temp = order.value!;
                                        temp.orderStatus.orderStatusId = 6;
                                        bool rs = await OrderRepository()
                                            .update(temp);
                                        if (rs) {
                                          reload();
                                          showSnackBar(
                                              context, "Update successful");
                                        } else {
                                          showSnackBar(
                                              context, "Something is wrong");
                                        }
                                      } else {
                                        Order temp = order.value!;
                                        temp.orderStatus.orderStatusId =
                                            temp.orderStatus.orderStatusId + 1;
                                        bool rs = await OrderRepository()
                                            .update(temp);
                                        if (rs) {
                                          print("begin reload");
                                          reload();
                                          print("done reload");
                                          showSnackBar(
                                              context, "Update successful");
                                        } else {
                                          showSnackBar(
                                              context, "Something is wrong");
                                        }
                                      }
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: widget.type == 1
                                          ? Colors.red
                                          : Colors.black,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: widget.type == 1
                                                  ? Colors.red
                                                  : Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  child: Text(widget.type == 1
                                      ? 'Cancel'
                                      : "Next step"),
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
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
