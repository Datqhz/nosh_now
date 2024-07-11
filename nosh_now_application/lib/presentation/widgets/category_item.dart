import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem({super.key, required this.imgPath, required this.categoryName});
  String imgPath;
  String categoryName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 80,
      child: Column(
        children: [
          // category image
          Image(
            height: 65,
            width: 65,
            image: AssetImage(imgPath),
            fit: BoxFit.cover,
          ),
          // category name
          Text(
            categoryName,
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
