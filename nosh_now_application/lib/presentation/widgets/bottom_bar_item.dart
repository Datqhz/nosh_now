import 'package:flutter/material.dart';

class BottomBarItem extends StatefulWidget {
  BottomBarItem(
      {super.key,
      required this.idx,
      required this.icon,
      required this.handleActive,
      this.isActivate = false});

  int idx;
  IconData icon;
  Function handleActive;
  bool isActivate;

  @override
  State<BottomBarItem> createState() => BottomBarItemState();
}

class BottomBarItemState extends State<BottomBarItem> {
  void unActive() {
    widget.isActivate = false;
    setState(() {});
  }

  void active() {
    setState(() {
      widget.isActivate = true;
      widget.handleActive(widget.idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active,
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isActivate
              ? const Color.fromRGBO(217, 217, 217, 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          widget.icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
