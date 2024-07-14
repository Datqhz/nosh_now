import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/user_item.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget eaterView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            ...List.generate(
              12,
              (index) => GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: UserItem(
                    avatar: 'assets/images/avatar.jpg',
                    name: "Var'Gatanai",
                    joinedDate: DateTime.now(),
                    type: 1,
                    status: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }

  Widget merchantView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            ...List.generate(
              12,
              (index) => GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: UserItem(
                    avatar: 'assets/images/avatar.jpg',
                    name: "Var'Gatanai",
                    joinedDate: DateTime.now(),
                    type: 2,
                    status: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }

  Widget shipperView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            ...List.generate(
              12,
              (index) => GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: UserItem(
                    avatar: 'assets/images/avatar.jpg',
                    name: "Var'Gatanai",
                    joinedDate: DateTime.now(),
                    type: 3,
                    status: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              eaterView(),
              merchantView(),
              shipperView(),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color.fromRGBO(240, 240, 240, 1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          CupertinoIcons.search,
                          size: 24,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TabBar(
                    unselectedLabelColor:
                        const Color.fromRGBO(170, 184, 194, 1),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    indicatorColor: Colors.black,
                    dividerColor: Colors.transparent,
                    controller: _tabController,
                    tabs: const [
                      Text(
                        'Eater',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Merchant',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Shipper',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(49, 49, 49, 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
