import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/presentation/screens/main/home_screen.dart';
import 'package:nosh_now_application/presentation/widgets/bottom_bar.dart';
import 'package:nosh_now_application/presentation/widgets/bottom_bar_item.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<GlobalKey<BottomBarItemState>> bottomBarItemKeys = List.generate(
    4,
    (index) => GlobalKey<BottomBarItemState>(),
  );

  List<IconData> items = [
    CupertinoIcons.home,
    CupertinoIcons.bell,
    CupertinoIcons.layers_alt,
    CupertinoIcons.person
  ];

  final ValueNotifier<int> _bottomIdx = ValueNotifier(0);

  void _activateBottomBarItem(int newIdx) {
    int temp = _bottomIdx.value;
    _bottomIdx.value = newIdx;
    bottomBarItemKeys[temp].currentState!.unActive();
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
      body: SafeArea(
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: _bottomIdx,
              builder: (context, value, child) {
                return HomeScreen();
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
                      icon: items[index],
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
