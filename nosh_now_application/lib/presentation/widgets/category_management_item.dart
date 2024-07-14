import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/food_detail_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/modify_food_screen.dart';

class CategoryManagementItem extends StatelessWidget {
  CategoryManagementItem({super.key, required this.category});

  FoodCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(159, 159, 159, 1),
            width: 1,
          ),
        ),
      ),
      child: Row(children: [
        // food image
        Expanded(
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(category.categoryImage),
                      fit: BoxFit.cover),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                category.categoryName,
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
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                CupertinoIcons.pencil,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const Icon(
              CupertinoIcons.trash,
              color: Colors.red,
              size: 24,
            ),
          ],
        )
      ]),
    );
  }
}
