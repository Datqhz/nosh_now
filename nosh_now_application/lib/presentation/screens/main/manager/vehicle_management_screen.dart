import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/category.dart';
import 'package:nosh_now_application/data/models/vehicle_type.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/category_management_item.dart';
import 'package:nosh_now_application/presentation/widgets/user_item.dart';
import 'package:nosh_now_application/presentation/widgets/vehicle_type_managemet_item.dart';

class VehicleTypeManagementScreen extends StatefulWidget {
  const VehicleTypeManagementScreen({super.key});

  @override
  State<VehicleTypeManagementScreen> createState() =>
      _VehicleTypeManagementScreenState();
}

class _VehicleTypeManagementScreenState
    extends State<VehicleTypeManagementScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Vehicle Types',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: Color.fromRGBO(49, 49, 49, 1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...List.generate(12, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: VehicleTypeManagementItem(
                      vehicleType: VehicleType(
                          typeId: 1,
                          icon: 'assets/images/car.png',
                          typeName: 'Car'),
                    ),
                  );
                }),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // drawer
                      GestureDetector(
                        onTap: () {
                          // do something
                        },
                        child: const Icon(
                          CupertinoIcons.bars,
                          size: 24,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      ),
                      // search merchant
                      GestureDetector(
                        onTap: () {
                          // do something
                        },
                        child: const Icon(
                          CupertinoIcons.add,
                          size: 24,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
