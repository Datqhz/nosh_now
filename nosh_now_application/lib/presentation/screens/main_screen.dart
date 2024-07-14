import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/manage_order_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/manager/category_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/manager/manager_statistic_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/manager/user_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/manager/vehicle_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/food_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/merchant_dashboard_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/merchant/merchant_statistic_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/profile_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/shipper/shipper_dashboad_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/shipper/shipper_statistic_screen.dart';
import 'package:nosh_now_application/presentation/widgets/bottom_bar.dart';
import 'package:nosh_now_application/presentation/widgets/bottom_bar_item.dart';
import 'package:nosh_now_application/presentation/widgets/vehicle_type_managemet_item.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final List<GlobalKey<BottomBarItemState>> bottomBarItemKeys = List.generate(
  //   4,
  //   (index) => GlobalKey<BottomBarItemState>(),
  // );

  // List<IconData> items = [
  //   CupertinoIcons.home,
  //   CupertinoIcons.bell,
  //   CupertinoIcons.layers_alt,
  //   CupertinoIcons.person
  // ];

  // final List<GlobalKey<BottomBarItemState>> bottomBarItemKeys = List.generate(
  //   5,
  //   (index) => GlobalKey<BottomBarItemState>(),
  // );

  // List<dynamic> items = [
  //   CupertinoIcons.home,
  //   CupertinoIcons.layers_alt,
  //   'assets/images/wok_100_white.png',
  //   CupertinoIcons.chart_bar,
  //   CupertinoIcons.person
  // ];

  // final List<GlobalKey<BottomBarItemState>> bottomBarItemKeys = List.generate(
  //   4,
  //   (index) => GlobalKey<BottomBarItemState>(),
  // );

  // List<dynamic> items = [
  //   CupertinoIcons.home,
  //   CupertinoIcons.layers_alt,
  //   CupertinoIcons.chart_bar,
  //   CupertinoIcons.person
  // ];

  final List<GlobalKey<BottomBarItemState>> bottomBarItemKeys = List.generate(
    4,
    (index) => GlobalKey<BottomBarItemState>(),
  );

  List<dynamic> items = [
    CupertinoIcons.person_2,
    CupertinoIcons.square_stack_3d_down_right,
    Icons.motorcycle_outlined,
    CupertinoIcons.chart_bar
  ];

  final ValueNotifier<int> _bottomIdx = ValueNotifier(0);

  void _activateBottomBarItem(int newIdx) {
    if (newIdx != _bottomIdx.value) {
      int temp = _bottomIdx.value;
      bottomBarItemKeys[temp].currentState!.unActive();
      _bottomIdx.value = newIdx;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: _bottomIdx,
              builder: (context, value, child) {
                // if (value == 0) {
                //   return HomeScreen();
                // } else if (value == 1) {
                //   return ManageOrderScreen();
                // } else if (value == 2) {
                //   return ManageOrderScreen();
                // }
                // return ProfileScreen();

                //merchant
                // if (value == 0) {
                //   return MerchantDashboardScreen();
                // } else if (value == 1) {
                //   return ManageOrderScreen();
                // } else if (value == 2) {
                //   return FoodManagementScreen();
                // }else if(value == 3){
                //   return MerchantStatisticScreen();
                // }
                // return ProfileScreen();

                //shipper
                // if (value == 0) {
                //   return ShipperDashboardScreen();
                // } else if (value == 1) {
                //   return ManageOrderScreen(
                //     type: 2,
                //   );
                // } else if (value == 2) {
                //   return ShipperStatisticScreen();
                // }
                // return ProfileScreen();

                // manager
                if (value == 0) {
                  return UserManagementScreen();
                } else if (value == 1) {
                  return CategoryManagementScreen();
                } else if (value == 2) {
                  return VehicleTypeManagementScreen();
                }
                return ManagerStatisticScreen();
              },
            ),
            // Bottom bar
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: BottomBar(
                  items: List.generate(4, (index) {
                    return BottomBarItem(
                      key: bottomBarItemKeys[index],
                      idx: index,
                      icon: items[index] is IconData ? items[index] : null,
                      imgPath: items[index] is! IconData ? items[index] : null,
                      isActivate: index == 0 ? true : false,
                      handleActive: _activateBottomBarItem,
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
