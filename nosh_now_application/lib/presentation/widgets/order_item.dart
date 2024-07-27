import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/core/utils/order.dart';
import 'package:nosh_now_application/data/models/order.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';

class OrderItem extends StatelessWidget {
  OrderItem({super.key, required this.order, required this.type});

  Order order;
  int type; // 1 for eater, 2 for merchant, 3 shipper

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
          // icon
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              CupertinoIcons.news,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name
              Text(
                type == 1
                    ? order.merchant.displayName
                    : order.eater.displayName,
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
              Row(
                children: [
                  Text(
                    DateFormat.yMMMd("en_US")
                        .format(order.orderedDate!)
                        .toString(),
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
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(
                    CupertinoIcons.circle_fill,
                    size: 4,
                    color: Color.fromRGBO(49, 49, 49, 1),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${order.totalPay}₫',
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
              )
            ],
          ),
          const Expanded(
              child: SizedBox(
            width: 12,
          )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.circle_fill,
                size: 10,
                color: pickColorForStatus(order.orderStatus.step),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                order.orderStatus.orderStatusName,
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
            ],
          )
        ],
      ),
    );
  }
}
