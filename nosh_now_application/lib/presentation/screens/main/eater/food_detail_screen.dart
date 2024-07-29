import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/core/streams/order_detail_notifier.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/data/repositories/order_detail_repository.dart';

// ignore: must_be_immutable
class FoodDetailScreen extends StatefulWidget {
  FoodDetailScreen(
      {super.key,
      required this.food,
      required this.notifier,
      required this.orderId});

  Food food;
  OrderDetailNotifier notifier;
  int orderId;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  ValueNotifier<int> quantity = ValueNotifier(0);

  String _contentForButton(int value) {
    if (widget.notifier.detail != null && value == 0) {
      return "Remove from order";
    } else if (widget.notifier.detail != null && value > 0) {
      return "Update order";
    } else {
      return "Add to order";
    }
  }

  @override
  void initState() {
    super.initState();
    int temp = 0;
    if (widget.notifier.detail != null) {
      temp = widget.notifier.detail!.quantity;
    }
    quantity = ValueNotifier(temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Stack(
          children: [
            // food image
            Column(
              children: [
                Image(
                  image: MemoryImage(
                      convertBase64ToUint8List(widget.food.foodImage)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.4,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
                        width: 100,
                        transform: Matrix4.translationValues(-20, -20, 0),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.4), // Màu sắc của bóng đổ
                                spreadRadius: 2, // Độ mờ viền của bóng đổ
                                blurRadius: 7, // Độ mờ của bóng đổ
                                offset: const Offset(0, 2),
                              )
                            ],
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (quantity.value > 0) {
                                  quantity.value = quantity.value - 1;
                                }
                              },
                              child: const Icon(
                                CupertinoIcons.minus,
                                color: Color.fromRGBO(240, 240, 240, 1),
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: quantity,
                                builder: (context, value, child) {
                                  return Text(
                                    value.toString(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                      color: Color.fromRGBO(240, 240, 240, 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                            GestureDetector(
                              onTap: () {
                                quantity.value = quantity.value + 1;
                              },
                              child: const Icon(
                                CupertinoIcons.plus,
                                color: Color.fromRGBO(240, 240, 240, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.food.foodName,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                .format(widget.food.price),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: Text(
                        widget.food.foodDescribe,
                        textAlign: TextAlign.left,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total price',
                              textAlign: TextAlign.left,
                              maxLines: 10,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: quantity,
                                builder: (context, value, child) {
                                  return Text(
                                    NumberFormat.currency(
                                            locale: 'vi_VN', symbol: '₫')
                                        .format(widget.food.price * value),
                                    textAlign: TextAlign.left,
                                    maxLines: 10,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      color: Color.fromRGBO(49, 49, 49, 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }),
                          ],
                        ),
                        ValueListenableBuilder(
                            valueListenable: quantity,
                            builder: (context, value, child) {
                              return ElevatedButton.icon(
                                onPressed: () async {
                                  bool rs = false;
                                  if (widget.notifier.detail != null) {
                                    if (quantity.value > 0 &&
                                        quantity.value !=
                                            widget.notifier.detail!.quantity) {
                                      OrderDetail temp =
                                          widget.notifier.detail!;
                                      temp.quantity = quantity.value;
                                      rs = await OrderDetailRepository()
                                          .update(temp);
                                      if (rs) widget.notifier.change(temp);
                                    } else {
                                      rs = await OrderDetailRepository()
                                          .deleteDetail(
                                              widget.notifier.detail!.odId);
                                      if (rs) widget.notifier.change(null);
                                    }
                                  } else {
                                    if (quantity.value > 0) {
                                      OrderDetail temp = OrderDetail(
                                          odId: 0,
                                          orderId: widget.orderId,
                                          price: widget.food.price,
                                          quantity: quantity.value,
                                          food: widget.food);
                                      OrderDetail? createRs =
                                          await OrderDetailRepository()
                                              .create(temp);
                                      if (createRs != null) {
                                        rs = true;
                                        widget.notifier.change(createRs);
                                      }
                                    }
                                  }

                                  if (rs) {
                                    showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Update order successfully!");
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  } else {
                                    showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Update order failed!");
                                  }
                                },
                                icon: const Icon(
                                  CupertinoIcons.cart_fill,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: Text(
                                  _contentForButton(value),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.zero,
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)))),
                              );
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            // App bar
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
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
            )
          ],
        ),
      ),
    );
  }
}
