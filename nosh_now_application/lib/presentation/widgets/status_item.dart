import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/order_status.dart';

class StatusItem extends StatelessWidget {
  StatusItem(
      {super.key,
      required this.status,
      required this.content,
      required this.icon,
      required this.isActive});

  OrderStatus status;
  String content;
  IconData icon;
  bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 6,
            width: MediaQuery.of(context).size.width / 6,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width / 10),
              color: isActive
                  ? const Color.fromRGBO(247, 205, 99, 1)
                  : const Color.fromRGBO(220, 220, 220, 1),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 26,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            height: 20,
            width: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width / 10),
              color: isActive
                  ? const Color.fromRGBO(247, 205, 99, 1)
                  : const Color.fromRGBO(220, 220, 220, 1),
            ),
            child: Text(
              status.step.toString(),
              style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(49, 49, 49, 1),
            ),
          ),
        ],
      ),
    );
  }
}
