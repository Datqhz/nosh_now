import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/models/order_status.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/order_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';
import 'package:nosh_now_application/presentation/widgets/order_item.dart';

class ManageOrderScreen extends StatefulWidget {
  ManageOrderScreen({super.key, required this.type});

  int type; // 1 is eater, 2 is merchant, 3 is shipper

  @override
  State<ManageOrderScreen> createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<List<Order>> orders = ValueNotifier([]);
  ValueNotifier<Widget> header = ValueNotifier(const SizedBox());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      orders.value = [];
      header.value = buildHeader();
      if (_tabController.index == 0) {
        fetchData();
      } else {
        fetchOrderNearbyData();
      }
    });
    fetchData();
    header.value = buildHeader();
  }

  Future<void> fetchData() async {
    if (widget.type == 1) {
      orders.value =
          await OrderRepository().getByEater(GlobalVariable.currentUid);
    } else if (widget.type == 2) {
      orders.value =
          await OrderRepository().getByMerchant(GlobalVariable.currentUid);
    } else {
      orders.value =
          await OrderRepository().getByShipper(GlobalVariable.currentUid);
    }
  }

  void reload() {
    print("call to get data");
    fetchData();
  }

  Future<void> fetchOrderNearbyData() async {
    LatLng currentLocation = await getCurrentLocation();
    orders.value = await OrderRepository().getAllNearBy(
        "${currentLocation.latitude}-${currentLocation.longitude}");
  }

  Widget buildHeader() {
    if (widget.type == 3) {
      if (_tabController.index == 0) {
        return const Row(
          children: [
            Text(
              'Order received',
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
        );
      } else {
        return const Text(
          'Near your',
          maxLines: 1,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(49, 49, 49, 1),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    } else {
      return const Row(
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
      );
    }
  }

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
                SizedBox(
                  height: widget.type == 3 ? 100 : 70, // 70
                ),
                ValueListenableBuilder(
                    valueListenable: header,
                    builder: (context, value, child) {
                      return value;
                    }),
                const SizedBox(
                  height: 12,
                ),
                // list order
                ValueListenableBuilder(
                    valueListenable: orders,
                    builder: (context, value, child) {
                      if (value.isEmpty) {
                        return Center(
                          child: Text(
                            _tabController.index == 0
                                ? "You don't have any order."
                                : "Don't have any order near your in 3km.",
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: List.generate(value.length, (index) {
                            return GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailScreen(
                                      order: value[index],
                                      callback: fetchData,
                                    ),
                                  ),
                                )
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: OrderItem(
                                  order: value[index],
                                  type: widget.type,
                                ),
                              ),
                            );
                          }),
                        );
                      }
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
            color: const Color.fromRGBO(240, 240, 240, 1),
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Row(
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
                if (widget.type == 3) ...[
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(240, 240, 240, 1),
                        border: Border(
                            bottom: BorderSide(
                                width: 0.14,
                                color: Theme.of(context).dividerColor))),
                    child: TabBar(
                      unselectedLabelColor:
                          const Color.fromRGBO(170, 184, 194, 1),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                      controller: _tabController,
                      tabs: const [
                        Text(
                          'Received',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Near you',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ]
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
