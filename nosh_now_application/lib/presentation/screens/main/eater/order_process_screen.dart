import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/dash_line_painter.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/core/utils/order.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/repositories/order_detail_repository.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/data/repositories/order_status_repository.dart';
import 'package:nosh_now_application/presentation/widgets/order_detail_item.dart';
import 'package:nosh_now_application/presentation/widgets/status_item.dart';

class OrderProcessScreen extends StatefulWidget {
  OrderProcessScreen({super.key, required this.order, this.callback});

  Order order;
  Function? callback;

  @override
  State<OrderProcessScreen> createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> {
  late ValueNotifier<Order?> order = ValueNotifier(null);
  ValueNotifier<List<OrderDetail>> orderDetails = ValueNotifier([]);
  MapController mapController = MapController();
  ValueNotifier<List<Polyline>> polylines = ValueNotifier([]);
  ValueNotifier<LatLng?> shipperCoord = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    fetchOrderData();
    fetchOrderDetailData();
    polylines.value = [
      Polyline(
        points: [], // Initial empty coordinates for the first polyline
        strokeWidth: 4.0,
        color: Colors.green,
      ),
      Polyline(
        points: [], // Initial empty coordinates for the second polyline
        strokeWidth: 4.0,
        color: Colors.blue,
      ),
    ];

    // route from merchant to eater
    if (widget.order.orderStatus.orderStatusId < 5) {
      updatePolylineFromStartToTarget(
          splitCoordinatorString(widget.order.merchant.coordinator),
          splitCoordinatorString(widget.order.coordinator!),
          0);
    }
  }

  Future<void> updatePolylineFromStartToTarget(
      LatLng start, LatLng end, int idx) async {
    List<Polyline> currentPolylines = List.from(polylines.value);
    List<LatLng> route = await getRouteCoordinates(start, end);
    currentPolylines[idx] = Polyline(
      points: route,
      strokeWidth: 4.0,
      color: Colors.blue,
    );
    polylines.value = currentPolylines;
  }

  Future<LatLng> loadRoute() async {
    LatLng currentLocation = await checkPermissions();
    if (order.value!.orderStatus.orderStatusId == 3) {
      updatePolylineFromStartToTarget(currentLocation,
          splitCoordinatorString(widget.order.merchant.coordinator), 1);
    } else if (order.value!.orderStatus.orderStatusId == 4) {
      hiddenPolyline(1);
      updatePolylineFromStartToTarget(currentLocation,
          splitCoordinatorString(widget.order.coordinator!), 0);
    } else {
      hiddenPolyline(0);
    }
    shipperCoord.value = currentLocation;
    return currentLocation;
  }

  Future<void> hiddenPolyline(int idx) async {
    List<Polyline> currentPolylines = List.from(polylines.value);
    currentPolylines[idx] = Polyline(
      points: [],
      strokeWidth: 4.0,
      color: Colors.blue,
    );
    polylines.value = currentPolylines;
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
      widget.callback!();
    }
    await fetchOrderData();
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
                                            color: const Color.fromRGBO(
                                                247, 205, 99, 1),
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
                                ValueListenableBuilder(
                                    valueListenable: order,
                                    builder: (context, value, child) {
                                      if (value == null) {
                                        return const Center(
                                            child: SpinKitCircle(
                                          color: Colors.black,
                                          size: 30,
                                        ));
                                      }
                                      if (value.shipper == null) {
                                        return const Text(
                                          "Your order hasn't been picked up yet",
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Color.fromRGBO(49, 49, 49, 1),
                                              overflow: TextOverflow.ellipsis),
                                        );
                                      }
                                      return Row(
                                        children: [
                                          // shipper avatar
                                          Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: MemoryImage(
                                                      convertBase64ToUint8List(
                                                          value.shipper!
                                                              .avatar)),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // shipper name
                                                Text(
                                                  value.shipper!.displayName,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.2,
                                                    color: Color.fromRGBO(
                                                        49, 49, 49, 1),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                //vehicle name
                                                Text(
                                                  value.shipper!.vehicleName,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.2,
                                                    color: Color.fromRGBO(
                                                        49, 49, 49, 1),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                      );
                                    }),
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
                    const Text(
                      'Order detail',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
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
                    // route to merchant, to eater
                    if (GlobalVariable.roleId == 4)
                      SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width - 40,
                        child: FutureBuilder(
                          future: loadRoute(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return FlutterMap(
                                  mapController: mapController,
                                  options: MapOptions(
                                    initialCenter: snapshot.data!,
                                    initialZoom: 16,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: shipperCoord,
                                        builder: (context, value, child) {
                                          if (value != null) {
                                            return MarkerLayer(
                                                rotate: true,
                                                markers: [
                                                  // eater
                                                  Marker(
                                                    point:
                                                        splitCoordinatorString(
                                                            order.value!
                                                                .coordinator!),
                                                    child: Stack(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Colors.red,
                                                          size: 40,
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          left: 12,
                                                          child: Container(
                                                            height: 16,
                                                            width: 16,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: const Icon(
                                                              CupertinoIcons
                                                                  .person_fill,
                                                              color: Colors.red,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // merchant
                                                  Marker(
                                                    point:
                                                        splitCoordinatorString(
                                                            order
                                                                .value!
                                                                .merchant
                                                                .coordinator),
                                                    child: Stack(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          color: Colors
                                                              .yellow.shade900,
                                                          size: 40,
                                                        ),
                                                        Positioned(
                                                          top: 8,
                                                          left: 12,
                                                          child: Container(
                                                            height: 16,
                                                            width: 16,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Icon(
                                                              Icons
                                                                  .shopping_bag,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade900,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // shipper
                                                  if (order.value!.orderStatus
                                                          .orderStatusId <
                                                      5)
                                                    Marker(
                                                      height: 20,
                                                      width: 20,
                                                      point: value,
                                                      child: Container(
                                                        height: 20,
                                                        width: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                        child: const Icon(
                                                          Icons.circle,
                                                          size: 18,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    )
                                                ]);
                                          }
                                          return const SizedBox();
                                        }),
                                    // route
                                    ValueListenableBuilder(
                                        valueListenable: polylines,
                                        builder: (context, value, child) {
                                          if (value.isNotEmpty) {
                                            return PolylineLayer(
                                              polylines: value,
                                            );
                                          }
                                          return const SizedBox();
                                        }),
                                  ]);
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
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
                                NumberFormat.currency(
                                        locale: 'vi_VN', symbol: '₫')
                                    .format(calcSubtantial(value)),
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
                                value != null
                                    ? NumberFormat.currency(
                                            locale: 'vi_VN', symbol: '₫')
                                        .format(value.shipmentFee!)
                                    : '',
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
                                  NumberFormat.currency(
                                          locale: 'vi_VN', symbol: '₫')
                                      .format(value.totalPay),
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
                    if (GlobalVariable.roleId == 2)
                      ValueListenableBuilder(
                          valueListenable: order,
                          builder: (context, value, child) {
                            if (value != null &&
                                value.orderStatus.orderStatusId == 2) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                height: 44,
                                child: TextButton(
                                  onPressed: () async {
                                    Order temp = value;
                                    temp.orderStatus.orderStatusId = 6;
                                    bool rs =
                                        await OrderRepository().update(temp);
                                    if (rs) {
                                      reload();
                                      showSnackBar(
                                          context, "Order is canceled");
                                    } else {
                                      showSnackBar(
                                          context, "Something is wrong");
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.red,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  child: const Text('Cancel'),
                                ),
                              );
                            }
                            return const SizedBox();
                          }),
                    if (GlobalVariable.roleId == 4)
                      ValueListenableBuilder(
                          valueListenable: order,
                          builder: (context, value, child) {
                            if (value != null &&
                                value.orderStatus.orderStatusId < 5) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                height: 44,
                                child: TextButton(
                                  onPressed: () async {
                                    Order temp = value;
                                    int shipperId = 0;
                                    if (temp.orderStatus.orderStatusId == 2) {
                                      shipperId = GlobalVariable.currentUid;
                                    }
                                    temp.orderStatus.orderStatusId =
                                        temp.orderStatus.orderStatusId + 1;
                                    bool rs = await OrderRepository()
                                        .update(temp, shipperId: shipperId);
                                    if (rs) {
                                      reload();
                                      showSnackBar(
                                          context, "Update successful");
                                    } else {
                                      showSnackBar(
                                          context, "Something is wrong");
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  child: Text(
                                      value.orderStatus.orderStatusId == 2
                                          ? 'Pick up'
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
