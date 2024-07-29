import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/order_detail_screen.dart';
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
  ValueNotifier<List<Order>?> orders = ValueNotifier(null);
  ValueNotifier<List<Order>?> tempOrders = ValueNotifier(null);
  ValueNotifier<Widget> header = ValueNotifier(const SizedBox());
  late TextEditingController _controller;
  ValueNotifier<int> option = ValueNotifier(1);

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
    if (GlobalVariable.roleId == 2) {
      _controller = TextEditingController();
    }
  }

  Future<void> fetchData() async {
    if (widget.type == 1) {
      List<Order> list =
          await OrderRepository().getByEater(GlobalVariable.currentUid);
      orders.value = list;
      tempOrders.value = list;
    } else if (widget.type == 2) {
      List<Order> list =
          await OrderRepository().getByMerchant(GlobalVariable.currentUid);
      orders.value = list;
      tempOrders.value = list;
    } else {
      List<Order> list =
          await OrderRepository().getByShipper(GlobalVariable.currentUid);
      orders.value = list;
      tempOrders.value = list;
    }
  }

  void filterOrderByMerchantName() {
    List<Order> afterFilter = [];
    String regex = _controller.text.trim();
    for (var order in tempOrders.value!) {
      if (order.merchant.displayName.contains(regex)) {
        afterFilter.add(order);
      }
    }
    sortOrder(afterFilter);
    orders.value = afterFilter;
  }

  void sortOrder(List<Order> data) {
    if (option.value == 2) {
      data.sort((a, b) {
        return a.orderedDate!.compareTo(b.orderedDate!);
      });
    } else {
      data.sort((a, b) {
        return b.orderedDate!.compareTo(a.orderedDate!);
      });
    }
  }

  void reload() {
    fetchData();
  }

//  need edit
  Future<void> fetchOrderNearbyData() async {
    LatLng currentLocation = await getCurrentCoordinator();
    orders.value = await OrderRepository().getAllNearBy(
        '${currentLocation.latitude}-${currentLocation.longitude}');
  }

  Widget buildHeader() {
    if (widget.type == 3) {
      if (_tabController.index == 0) {
        return Row(
          children: [
            const Text(
              'Order received',
              maxLines: 1,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(49, 49, 49, 1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Expanded(child: SizedBox()),
            ValueListenableBuilder(
                valueListenable: option,
                builder: (context, value, child) {
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 220,
                              color: Colors.black,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.minus,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 40,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  const Text(
                                    "Sort",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      option.value = 1;
                                      if (GlobalVariable.roleId != 2) {
                                        List<Order> temp =
                                            List.from(orders.value!);
                                        sortOrder(temp);
                                        orders.value = temp;
                                      } else {
                                        filterOrderByMerchantName();
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Newest",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        if (value == 1)
                                          const Icon(
                                            CupertinoIcons
                                                .checkmark_alt_circle_fill,
                                            color: Colors.white,
                                          )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      option.value = 2;
                                      if (GlobalVariable.roleId != 2) {
                                        List<Order> temp =
                                            List.from(orders.value!);
                                        sortOrder(temp);
                                        orders.value = temp;
                                      } else {
                                        filterOrderByMerchantName();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Oldest",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        if (value == 2)
                                          const Icon(
                                            CupertinoIcons
                                                .checkmark_alt_circle_fill,
                                            color: Colors.white,
                                          )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Text(
                          value == 1 ? 'Newest' : 'Oldest',
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          value == 1
                              ? CupertinoIcons.sort_down
                              : CupertinoIcons.sort_up,
                          color: const Color.fromRGBO(49, 49, 49, 1),
                        )
                      ],
                    ),
                  );
                })
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
      return Row(
        children: [
          const Text(
            'Your orders',
            maxLines: 1,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(49, 49, 49, 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Expanded(child: SizedBox()),
          ValueListenableBuilder(
              valueListenable: option,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 220,
                            color: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 40,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  "Sort",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    option.value = 1;
                                    if (GlobalVariable.roleId != 2) {
                                      List<Order> temp =
                                          List.from(orders.value!);
                                      sortOrder(temp);
                                      orders.value = temp;
                                    } else {
                                      filterOrderByMerchantName();
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Newest",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      if (value == 1)
                                        const Icon(
                                          CupertinoIcons
                                              .checkmark_alt_circle_fill,
                                          color: Colors.white,
                                        )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    option.value = 2;
                                    if (GlobalVariable.roleId != 2) {
                                      List<Order> temp =
                                          List.from(orders.value!);
                                      sortOrder(temp);
                                      orders.value = temp;
                                    } else {
                                      filterOrderByMerchantName();
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Oldest",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      if (value == 2)
                                        const Icon(
                                          CupertinoIcons
                                              .checkmark_alt_circle_fill,
                                          color: Colors.white,
                                        )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Row(
                    children: [
                      Text(
                        value == 1 ? 'Newest' : 'Oldest',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        value == 1
                            ? CupertinoIcons.sort_down
                            : CupertinoIcons.sort_up,
                        color: const Color.fromRGBO(49, 49, 49, 1),
                      )
                    ],
                  ),
                );
              })
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
                      print('build');
                      if (value != null) {
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
                      }
                      return const Center(
                        child: SpinKitCircle(
                          color: Colors.black,
                          size: 50,
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
            color: const Color.fromRGBO(240, 240, 240, 1),
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // drawer
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(
                        CupertinoIcons.bars,
                        size: 20,
                        color: Color.fromRGBO(49, 49, 49, 1),
                      ),
                    ),
                    if (GlobalVariable.roleId == 2) ...[
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 40,
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "ex. Pho 10, abc,...",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(159, 159, 159, 1)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(35, 35, 35, 1),
                                width: 1,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            print(value);
                            filterOrderByMerchantName();
                          },
                          style: const TextStyle(
                              color: Color.fromRGBO(49, 49, 49, 1),
                              fontSize: 14,
                              decoration: TextDecoration.none),
                        ),
                      ),
                      // search merchant
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          CupertinoIcons.search,
                          size: 20,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      )
                    ]
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
