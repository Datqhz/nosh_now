import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  FoodItem(
      {super.key,
      required this.imgPath,
      required this.foodName,
      required this.price});
  String imgPath;
  String foodName;
  double price;

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
            image: AssetImage(imgPath),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 8,
          ),
          // food name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              foodName,
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
          ),
          const Expanded(child: SizedBox()),
          // price
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$price ₫',
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
