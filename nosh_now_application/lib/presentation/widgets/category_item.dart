import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/data/models/category.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem({super.key, required this.category});
  FoodCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 80,
      child: Column(
        children: [
          // category image
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            clipBehavior: Clip.antiAlias,
            child: Image(
              height: 65,
              width: 65,
              image:
                  MemoryImage(convertBase64ToUint8List(category.categoryImage)),
              fit: BoxFit.cover,
            ),
          ),
          // category name
          Text(
            category.categoryName,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              height: 1.2,
              color: Color.fromRGBO(49, 49, 49, 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
