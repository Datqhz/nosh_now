import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/streams/order_detail_notifier.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';

class FoodItem extends StatelessWidget {
  FoodItem({super.key, required this.food, required this.detailNotifier});
  Food food;
  OrderDetailNotifier detailNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      height: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // food image
          Image(
            height: 100,
            width: double.infinity,
            image: MemoryImage(convertBase64ToUint8List(food.foodImage)),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 8,
          ),
          // food name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  food.foodName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Color.fromRGBO(49, 49, 49, 1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListenableBuilder(
                    listenable: detailNotifier,
                    builder: (context, child) {
                      if (detailNotifier.detail != null) {
                        return Text(
                          ' - Selected: ${detailNotifier.detail!.quantity}',
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            height: 1.2,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }else {
                        return const SizedBox();
                      }
                    }),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          // price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${double.parse((food.price).toStringAsFixed(2))} ₫',
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
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
