import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/order_detail.dart';

class OrderDetailItem extends StatefulWidget {
  OrderDetailItem({super.key, required this.detail, this.isEdit = false});

  OrderDetail detail;
  bool? isEdit;

  @override
  State<OrderDetailItem> createState() => _OrderDetailItemState();
}

class _OrderDetailItemState extends State<OrderDetailItem> {
  @override
  Widget build(BuildContext context) {
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
                  image: AssetImage(widget.detail.food.foodImage),
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
                '${widget.detail.price}₫  x${widget.detail.quantity}',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                  color: Color.fromRGBO(49, 49, 49, 1),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          const Expanded(
              child: SizedBox(
            width: 12,
          )),
          if (widget.isEdit!) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(1, 0),
                )
              ], color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    CupertinoIcons.plus,
                    color: Color.fromRGBO(240, 240, 240, 1),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Icon(
                    CupertinoIcons.minus,
                    color: Color.fromRGBO(240, 240, 240, 1),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
