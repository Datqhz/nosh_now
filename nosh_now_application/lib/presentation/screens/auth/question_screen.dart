import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/presentation/screens/auth/login_screen.dart';
import 'package:nosh_now_application/presentation/screens/auth/register_eater_screen.dart';
import 'package:nosh_now_application/presentation/screens/auth/register_merchant_screen.dart';
import 'package:nosh_now_application/presentation/screens/auth/register_shipper_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //thumbnail
                  Image.asset(
                    'assets/images/question.png',
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.width - 40,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Who are you?',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(49, 49, 49, 1)),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //button eater
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterEaterScreen()));
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color.fromRGBO(49, 49, 49, 1),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text('Eater'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // button merchant
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterMerchantStep1Screen()));
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color.fromRGBO(49, 49, 49, 1),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: const Color.fromRGBO(162, 147, 67, 1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text('Merchant'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // button shipper
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterShipperScreen()));
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color.fromRGBO(49, 49, 49, 1),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color.fromRGBO(22, 108, 0, 1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text('Shipper'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            // back button
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  CupertinoIcons.arrow_left,
                  color: Color.fromRGBO(49, 49, 49, 1),
                  size: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
