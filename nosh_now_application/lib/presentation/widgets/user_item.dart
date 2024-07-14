import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/core/utils/distance.dart';
import 'package:nosh_now_application/data/models/merchant.dart';

class UserItem extends StatelessWidget {
  UserItem(
      {super.key,
      required this.name, required this.joinedDate, required this.avatar, required this.type, this.status});
  String name;
  String avatar;
  DateTime joinedDate;
  int type;
  int? status;

  Color pickColorForStatus(){
    if(status == 1){
      return Colors.green;
    }else if(status == 2){
      return Colors.grey;
    }else {
      return Colors.orange;
    }
  }

  String pickTitleForStatus(){
    if(status == 1){
      return "In operation";
    }else if(status == 2){
      return "suspended";
    }else {
      return "In delivery";
    }
  }

  Widget getStatus(){
    return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.circle_fill,
                size: 10,
                color: pickColorForStatus(),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                pickTitleForStatus(),
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          // avatar
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(avatar), fit: BoxFit.cover),
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
              // name
              Text(
                name,
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
                  // joined date
                  Text(
                    'Join in: ${DateFormat.yMMMd("en_US")
                        .format(joinedDate)}',
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
          const Expanded(child: SizedBox()),
          if(type!=1)...[getStatus()]
        ],
      ),
    );
  }
}
