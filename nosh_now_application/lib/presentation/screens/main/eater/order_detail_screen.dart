import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/core/utils/order.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/repositories/order_detail_repository.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/order_process.dart';
import 'package:nosh_now_application/presentation/widgets/order_detail_item.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({super.key, required this.order, required this.callback});

  Order order;
  Function callback;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  ValueNotifier<List<OrderDetail>> details = ValueNotifier([]);
  late ValueNotifier<Order> order;

  @override
  void initState() {
    super.initState();
    order = ValueNotifier(widget.order);
    fetchOrderDetailData();
  }

  Future<void> fetchOrderDetailData() async {
    details.value =
        await OrderDetailRepository().getAllByOrderId(widget.order.orderId);
  }

  Future<void> fetchOrderData() async {
    order.value = await OrderRepository().getById(widget.order.orderId);
  }

  void reload() {
    widget.callback();
    fetchOrderData();
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
                    // eater
                    const Text(
                      'Eater',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Food orderer: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          widget.order.eater.displayName,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Order date: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          DateFormat.yMMMd("en_US")
                              .format(widget.order.orderedDate!)
                              .toString(),
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Delivery address: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: FutureBuilder(
                              future: getAddressFromLatLng(
                                  splitCoordinatorString(
                                      widget.order.coordinator!)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        overflow: TextOverflow.ellipsis),
                                  );
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Phone: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: Text(
                            widget.order.phone!,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    const Text(
                      'Merchant',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Name: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          widget.order.merchant.displayName,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const Text(
                          'Address: ',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          child: FutureBuilder(
                              future: getAddressFromLatLng(
                                  splitCoordinatorString(
                                      widget.order.merchant.coordinator)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(49, 49, 49, 1),
                                        overflow: TextOverflow.ellipsis),
                                  );
                                }
                                return const SizedBox();
                              }),
                        ),
                      ],
                    ),
                    if (widget.order.shipper != null) ...[
                      const Divider(
                        color: Color.fromRGBO(159, 159, 159, 1),
                      ),
                      const Text(
                        'Shipper',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Text(
                            widget.order.shipper!.displayName,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Vehicle: ',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Expanded(
                            child: Text(
                              widget.order.shipper!.vehicleName,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(
                      color: Color.fromRGBO(159, 159, 159, 1),
                    ),
                    ValueListenableBuilder(
                        valueListenable: details,
                        builder: (context, value, child) {
                          if (value.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(value.length, (index) {
                                return OrderDetailItem(detail: value[index]);
                              }),
                            );
                          }
                          return const SpinKitCircle(
                            color: Colors.black,
                            size: 50,
                          );
                        }),

                    const SizedBox(
                      height: 20,
                    ),
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
                            valueListenable: details,
                            builder: (context, value, child) {
                              if (value.isNotEmpty) {
                                return Text(
                                  '${calcSubtantial(value)}₫',
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(120, 120, 120, 1),
                                      overflow: TextOverflow.ellipsis),
                                );
                              }
                              return const SizedBox();
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 8,
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
                          '${widget.order.shipmentFee}₫',
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
                      height: 8,
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
                          '${widget.order.totalPay}₫',
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
                      height: 20,
                    ),
                    ValueListenableBuilder(
                        valueListenable: order,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              if (value.orderStatus.orderStatusId == 2 &&
                                  GlobalVariable.roleId != 3)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    // width: double.infinity,
                                    height: 44,
                                    child: TextButton(
                                      onPressed: () async {
                                        Order temp = widget.order;
                                        temp.orderStatus.orderStatusId = 6;
                                        bool rs = await OrderRepository()
                                            .update(temp);
                                        if (rs) {
                                          if (widget.callback != null) {
                                            reload();
                                          }
                                          showSnackBar(
                                              context, "Update successful");
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
                                  ),
                                ),
                              //see proccess
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  // width: double.infinity,
                                  height: 44,
                                  child: TextButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderProcessScreen(
                                                  order: widget.order,
                                                  type:
                                                      GlobalVariable.roleId != 4
                                                          ? 1
                                                          : 2,
                                                  callback:
                                                      GlobalVariable.roleId != 3
                                                          ? reload
                                                          : null,
                                                ))),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    child: const Text('See process'),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 50,
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
                    Text(
                      widget.order.merchant.displayName,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const Expanded(child: SizedBox()),
                    ValueListenableBuilder(
                        valueListenable: order,
                        builder: (context, value, child) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.circle_fill,
                                size: 10,
                                color:
                                    pickColorForStatus(value.orderStatus.step),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                value.orderStatus.orderStatusName,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        })
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
