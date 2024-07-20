import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/data/models/location.dart';
import 'package:nosh_now_application/data/models/payment_method.dart';
import 'package:nosh_now_application/data/repositories/payment_method_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/prepare_order_screen.dart';
import 'package:nosh_now_application/presentation/widgets/saved_location.dart';

class ChoosePaymentMethodScreen extends StatefulWidget {
  ChoosePaymentMethodScreen({super.key, required this.currentPick});

  PaymentMethod currentPick;

  @override
  State<ChoosePaymentMethodScreen> createState() =>
      _ChoosePaymentMethodScreenState();
}

class _ChoosePaymentMethodScreenState extends State<ChoosePaymentMethodScreen> {
  Widget methodItem(PaymentMethod method) {
    return GestureDetector(
      onTap: () {
        print('click');
        Navigator.pop(context, method);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Image.memory(
              convertBase64ToUint8List(method.methodImage),
              fit: BoxFit.cover,
              height: 30,
              width: 30,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              method.methodName,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(49, 49, 49, 1),
                  overflow: TextOverflow.ellipsis),
            ),
            const Expanded(child: SizedBox()),
            if (widget.currentPick.methodId == method.methodId)
              const Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: Colors.green,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 66,
                      ),
                      FutureBuilder(
                          future: PaymentMethodRepository().getAll(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Column(
                                children: List.generate(snapshot.data!.length,
                                    (index) {
                                  return methodItem(snapshot.data![index]);
                                }),
                              );
                            }
                            return const SpinKitCircle(
                              color: Colors.black,
                              size: 50,
                            );
                          }),
                      const SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
              ),
              //app bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context, widget.currentPick),
                        child: const Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        'Payment methods',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(49, 49, 49, 1),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
              // pick from map
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                color: Color.fromRGBO(159, 159, 159, 1))),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.map,
                          size: 18,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Pick from map',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
