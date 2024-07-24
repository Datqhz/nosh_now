import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/shared_preference.dart';
import 'package:nosh_now_application/data/models/merchant.dart';
import 'package:nosh_now_application/data/repositories/statistic_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/home_screen.dart';

class MerchantDashboardScreen extends StatelessWidget {
  MerchantDashboardScreen({super.key});
  ValueNotifier<int> orderCount = ValueNotifier(0);

  Future<void> getNumOfOrder() async {
    orderCount.value = await StatisticRepository()
        .getTotalOrderOfUserByTimeAndRole(
            GlobalVariable.currentUid, GlobalVariable.roleId, 1, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    getNumOfOrder();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromRGBO(5, 167, 248, 1),
                    Color.fromRGBO(5, 167, 248, 1),
                    Color.fromRGBO(214, 250, 113, 1)
                  ])),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Hi ',
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      ),
                      FutureBuilder(
                          future: getUser(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Text(
                                snapshot.data!.displayName,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis),
                              );
                            }
                            return const SizedBox();
                          }),
                    ],
                  ),
                  const Text(
                    'This is some statistic recently',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  //revenue month
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(202, 213, 253, 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.wallet_rounded,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Revenue this month',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(159, 159, 159, 1),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            FutureBuilder(
                                future: StatisticRepository()
                                    .getRevenueOfMerchantByTime(
                                        GlobalVariable.currentUid, 2,
                                       DateTime.now()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data} ₫',
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }
                                  return const SizedBox();
                                }),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            'More',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //revenue day
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                        202, 213, 253, 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.wallet_rounded,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Revenue',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(159, 159, 159, 1),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    FutureBuilder(
                                        future: StatisticRepository()
                                            .getRevenueOfMerchantByTime(
                                                GlobalVariable.currentUid, 1,
                                                DateTime.now()),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Text(
                                              '${snapshot.data!} ₫',
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            );
                                          }
                                          return const SizedBox();
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            const Text(
                              'Time',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(159, 159, 159, 1),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              DateFormat.yMMMd("en_US")
                                  .format(DateTime.now())
                                  .toString(),
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: ValueListenableBuilder(
                                    valueListenable: orderCount,
                                    builder: (context, value, child) {
                                      return CircularProgressIndicator(
                                        backgroundColor: const Color.fromRGBO(
                                            66, 36, 250, 0.2),
                                        strokeWidth: 6,
                                        value: value / 10,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      );
                                    }),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ValueListenableBuilder(
                                        valueListenable: orderCount,
                                        builder: (context, value, child) {
                                          return Text(
                                            value.toString(),
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          );
                                        }),
                                    const Text(
                                      '/10 Orders',
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  // do something
                },
                child: const Icon(
                  CupertinoIcons.bars,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Merchant merchantData = Merchant(
    merchantId: 1,
    displayName: 'Pho 10 Ly Quoc Su',
    email: 'gatanai@gmail.com',
    phone: '0983473223',
    avatar: 'assets/images/store_avatar.jpg',
    openingTime: '7:30',
    closingTime: '18:00',
    coordinator: '322 - 455',
    category: categories[0]);

double revenue = 120000;
int numOfOrder = 7;
