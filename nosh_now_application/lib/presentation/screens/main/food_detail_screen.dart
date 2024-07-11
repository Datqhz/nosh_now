import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/presentation/widgets/food_item.dart';

class FoodDetailScreen extends StatefulWidget {
  FoodDetailScreen(
      {super.key,
      required this.foodImage,
      required this.foodName,
      required this.describe,
      required this.price,
      required this.quantity});

  String foodImage;
  String foodName;
  String describe;
  double price;
  int quantity;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
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
                  image: AssetImage(widget.foodImage),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
                        width: 100,
                        transform: Matrix4.translationValues(-20, -20, 0),
                        padding: EdgeInsets.symmetric(horizontal: 12),
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
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              CupertinoIcons.minus,
                              color: Color.fromRGBO(240, 240, 240, 1),
                            ),
                            Text(
                              '3',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                                color: Color.fromRGBO(240, 240, 240, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.plus,
                              color: Color.fromRGBO(240, 240, 240, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.foodName,
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
                        Text(
                          '${widget.price} ₫',
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
                    Text(
                      widget.describe,
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
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${widget.price * widget.quantity} ₫',
                              textAlign: TextAlign.left,
                              maxLines: 10,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.cart_fill,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text(
                            'Add to order',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.zero,
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)))),
                        )
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
