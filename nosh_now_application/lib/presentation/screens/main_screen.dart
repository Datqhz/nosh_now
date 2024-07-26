import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/snack_bar.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/providers/food_list_provider.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/manage_order_screen.dart';
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
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<GlobalKey<BottomBarItemState>> bottomBarItemKeys = [];

  late List<dynamic> bottomBarItems = [];
  final ValueNotifier<int> _bottomIdx = ValueNotifier(0);

  void _activateBottomBarItem(int newIdx) {
    if (newIdx != _bottomIdx.value) {
      int temp = _bottomIdx.value;
      bottomBarItemKeys[temp].currentState!.unActive();
      _bottomIdx.value = newIdx;
    }
  }

  Widget _replaceScreenByBottomBarIndex(int idx) {
    switch (GlobalVariable.roleName) {
      case 'Manager':
        if (idx == 0) {
          return const UserManagementScreen();
        } else if (idx == 1) {
          return const CategoryManagementScreen();
        } else if (idx == 2) {
          return const VehicleTypeManagementScreen();
        }
        return const ManagerStatisticScreen();
      case 'Eater':
        if (idx == 0) {
          return HomeScreen();
        } else if (idx == 1) {
          return ManageOrderScreen(
            type: 1,
          );
        } else if (idx == 2) {
          return ManageOrderScreen(
            type: 1,
          );
        }
        return const ProfileScreen();
      case 'Merchant':
        if (idx == 0) {
          return MerchantDashboardScreen();
        } else if (idx == 1) {
          return ManageOrderScreen(
            type: 2,
          );
        } else if (idx == 2) {
          return const FoodManagementScreen();
        } else if (idx == 3) {
          return const MerchantStatisticScreen();
        }
        return const ProfileScreen();
      case 'Shipper':
        if (idx == 0) {
          return ShipperDashboardScreen();
        } else if (idx == 1) {
          return ManageOrderScreen(
            type: 3,
          );
        } else if (idx == 2) {
          return const ShipperStatisticScreen();
        }
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();
    switch (GlobalVariable.roleName) {
      case 'Manager':
        bottomBarItemKeys = List.generate(
          4,
          (index) => GlobalKey<BottomBarItemState>(),
        );
        bottomBarItems = [
          CupertinoIcons.person_2,
          CupertinoIcons.square_stack_3d_down_right,
          Icons.motorcycle_outlined,
          CupertinoIcons.chart_bar
        ];
        break;
      case 'Eater':
        bottomBarItemKeys = List.generate(
          4,
          (index) => GlobalKey<BottomBarItemState>(),
        );
        bottomBarItems = [
          CupertinoIcons.home,
          CupertinoIcons.bell,
          CupertinoIcons.layers_alt,
          CupertinoIcons.person
        ];
        break;
      case 'Merchant':
        bottomBarItemKeys = List.generate(
          5,
          (index) => GlobalKey<BottomBarItemState>(),
        );
        bottomBarItems = [
          CupertinoIcons.home,
          CupertinoIcons.layers_alt,
          'assets/images/wok_100_white.png',
          CupertinoIcons.chart_bar,
          CupertinoIcons.person
        ];
        break;
      case 'Shipper':
        bottomBarItemKeys = List.generate(
          4,
          (index) => GlobalKey<BottomBarItemState>(),
        );
        bottomBarItems = [
          CupertinoIcons.home,
          CupertinoIcons.layers_alt,
          CupertinoIcons.chart_bar,
          CupertinoIcons.person
        ];
        break;
      default:
    }

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
                return _replaceScreenByBottomBarIndex(value);
              },
            ),
            // Bottom bar
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: BottomBar(
                  items: List.generate(
                      GlobalVariable.roleName == "Merchant" ? 5 : 4, (index) {
                    return BottomBarItem(
                      key: bottomBarItemKeys[index],
                      idx: index,
                      icon: bottomBarItems[index] is IconData
                          ? bottomBarItems[index]
                          : null,
                      imgPath: bottomBarItems[index] is! IconData
                          ? bottomBarItems[index]
                          : null,
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
