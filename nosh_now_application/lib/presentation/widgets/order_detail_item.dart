import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';

class OrderDetailItem extends StatefulWidget {
  OrderDetailItem({super.key, required this.detail, this.isEdit = false, this.onChange});

  OrderDetail detail;
  bool? isEdit;
  Function? onChange;

  @override
  State<OrderDetailItem> createState() => OrderDetailItemState();
}

class OrderDetailItemState extends State<OrderDetailItem> {
  late ValueNotifier quantity;
  @override
  void initState() {
    super.initState();
    quantity = ValueNotifier(widget.detail.quantity);
  }

  int getQuantity() {
    return quantity.value;
  }
  double calcTotal(){
    return widget.detail.price * quantity.value;
  }

  OrderDetail getCurrentDetail(){
    OrderDetail temp = widget.detail;
    temp.quantity = quantity.value;
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: quantity,
        builder: (context, value, child) {
          return Container(
            padding: const EdgeInsets.only(bottom: 8, top: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(159, 159, 159, 1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // food image
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(convertBase64ToUint8List(
                            widget.detail.food.foodImage)),
                        fit: BoxFit.cover),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // food name
                    Text(
                      widget.detail.food.foodName,
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
                    Text(
                      '${widget.detail.price}₫  x$value',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        height: 1.2,
                        color: Color.fromRGBO(49, 49, 49, 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Expanded(
                    child: SizedBox(
                  width: 12,
                )),
                if (widget.isEdit!) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(1, 0),
                          )
                        ],
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            quantity.value += 1;
                            widget.onChange!();
                          },
                          child: const Icon(
                            CupertinoIcons.plus,
                            color: Color.fromRGBO(240, 240, 240, 1),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        ValueListenableBuilder(
                            valueListenable: quantity,
                            builder: (context, value, child) {
                              return GestureDetector(
                                onTap: value != 0
                                    ? () {
                                        quantity.value -= 1;
                                        widget.onChange!();
                                      }
                                    : null,
                                child: Icon(
                                  CupertinoIcons.minus,
                                  color: value != 0
                                      ? Color.fromRGBO(240, 240, 240, 1)
                                      : Color.fromRGBO(59, 59, 59, 1),
                                ),
                              );
                            }),
                      ],
                    ),
                  )
                ]
              ],
            ),
          );
        });
  }
}
