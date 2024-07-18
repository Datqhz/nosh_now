import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/constants/map_box.dart';

class PickLocationFromMapScreen extends StatefulWidget {
  const PickLocationFromMapScreen({super.key});

  @override
  State<PickLocationFromMapScreen> createState() =>
      _PickLocationFromMapScreenState();
}

class _PickLocationFromMapScreenState extends State<PickLocationFromMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: MapBox.myLocation,
          
        ),
        children: [],
      ),
    );
  }
}
