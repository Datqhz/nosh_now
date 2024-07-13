import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/modify_food_screen.dart';
import 'package:nosh_now_application/presentation/widgets/food_item.dart';

class FoodDetailManagementScreen extends StatefulWidget {
  FoodDetailManagementScreen({
    super.key,
    required this.food,
  });

  Food food;

  @override
  State<FoodDetailManagementScreen> createState() =>
      _FoodDetailManagementScreenState();
}

class _FoodDetailManagementScreenState
    extends State<FoodDetailManagementScreen> {
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
                  image: AssetImage(widget.food.foodImage),
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          '${widget.food.price} ₫',
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
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
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
                  PopupMenuButton<String>(
                    icon: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                    color: Colors.white,
                    onSelected: (value) async {
                      if (value == 'Update') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ModifyFoodScreen(food: widget.food)));
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Update', 'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
