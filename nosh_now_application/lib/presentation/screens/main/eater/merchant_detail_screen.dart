import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/streams/order_detail_notifier.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/merchant_with_distance.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/repositories/food_repository.dart';
import 'package:nosh_now_application/data/repositories/order_detail_repository.dart';
import 'package:nosh_now_application/data/repositories/order_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/food_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';
import 'package:nosh_now_application/presentation/widgets/food_item.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MerchantDetailScreen extends StatefulWidget {
  MerchantDetailScreen({super.key, required this.merchant});

  MerchantWithDistance merchant;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  ValueNotifier<Order?> order = ValueNotifier(null);
  ValueNotifier<List<Food>> foods = ValueNotifier([]);
  ValueNotifier<List<OrderDetail>> details = ValueNotifier([]);
  ValueNotifier<List<GlobalKey<FoodItemState>>> foodItemStates =
      ValueNotifier([]);

  Future<bool> _fetchAllData() async {
    try {
      foods.value = await FoodRepository()
          .getAllByMerchantAndIsSelling(widget.merchant.merchant.merchantId);
      order.value = await OrderRepository().getByMerchantAndEater(
          widget.merchant.merchant.merchantId, GlobalVariable.currentUid);
      details.value =
          await OrderDetailRepository().getAllByOrderId(order.value!.orderId);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  OrderDetail? _checkHaveDetail(int foodId) {
    for (OrderDetail detail in details.value) {
      if (detail.food.foodId == foodId) {
        return detail;
      }
    }
    return null;
  }

  bool checkDetailsIsEmpty(BuildContext context) {
    for (var i in foodItemStates.value) {
      int quantity = i.currentState!.getQuantity();
      print("quantity: $quantity");
      if (quantity != 0) {
        return false;
      }
    }
    return true;
  }

  List<Widget> buildListFood() {
    List<Widget> widgets = [];
    List<GlobalKey<FoodItemState>> states = [];
    for (var food in foods.value) {
      var key = GlobalKey<FoodItemState>();
      states.add(key);
      widgets.add(ChangeNotifierProvider(
        create: (context) {
          OrderDetailNotifier notifier = OrderDetailNotifier();
          notifier.init(_checkHaveDetail(food.foodId));
          return notifier;
        },
        child: Consumer<OrderDetailNotifier>(
          builder: (context, notifier, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(
                      food: food,
                      notifier: notifier,
                      orderId: order.value!.orderId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FoodItem(
                  key: key,
                  food: food,
                  detailNotifier: notifier,
                ),
              ),
            );
          },
        ),
      ));
    }
    foodItemStates.value = states;
    return widgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // merchant avatar
                    Image(
                      image: MemoryImage(convertBase64ToUint8List(
                          widget.merchant.merchant.avatar)),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 140,
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(240, 240, 240, 1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color.fromRGBO(159, 159, 159, 1),
                              width: 0.4)),
                      transform: Matrix4.translationValues(0, -70, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // merchant name
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 54,
                            child: Text(
                              widget.merchant.merchant.displayName,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 54,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(159, 159, 159, 1),
                                  ),
                                  top: BorderSide(
                                    color: Color.fromRGBO(159, 159, 159, 1),
                                  )),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                //address
                                Expanded(
                                  child: FutureBuilder(
                                      future: getAddressFromLatLng(
                                          splitCoordinatorString(widget
                                              .merchant.merchant.coordinator)),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          return Text(
                                            snapshot.data!,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    49, 49, 49, 1),
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          );
                                        }
                                        return const SizedBox();
                                      }),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 54,
                            child: Row(
                              children: [
                                // distance to merchant
                                Text(
                                  '${double.parse((widget.merchant.distance).toStringAsFixed(2))} km',
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
                                  width: 4,
                                ),
                                const Icon(
                                  CupertinoIcons.circle_fill,
                                  size: 4,
                                  color: Color.fromRGBO(49, 49, 49, 1),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                // category name
                                Expanded(
                                  child: Text(
                                    widget.merchant.merchant.category!
                                        .categoryName,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                      color: Color.fromRGBO(49, 49, 49, 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    FutureBuilder(
                        future: _fetchAllData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.count(
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 2,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.9,
                                  children: buildListFood()),
                            );
                          } else {
                            return const Center(
                                child: SpinKitCircle(
                              color: Colors.black,
                              size: 40,
                            ));
                          }
                        }),
                  ],
                ),
              ),
            ),
            // App bar
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            // preview order
            Positioned(
              bottom: 80,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  if (order.value != null && !checkDetailsIsEmpty(context)) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrepareOrderScreen(
                                  order: order.value!,
                                )));
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    CupertinoIcons.news,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
