import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nosh_now_application/data/models/eater.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/modify_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _optionItem(
      String option, Color color, VoidCallback handle, bool isSignOut) {
    return GestureDetector(
      onTap: handle,
      child: Container(
        padding: const EdgeInsets.only(bottom: 12, top: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromRGBO(195, 195, 195, 1),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              option,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: color,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isSignOut) ...[
              const Expanded(child: SizedBox()),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Colors.black,
                size: 16,
              )
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            color: const Color.fromRGBO(1, 61, 39, 1),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testEater.displayName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Text(
                      'Eater',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () async {},
                  child: SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 50,
                            backgroundImage: AssetImage(testEater.avatar),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 3,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: const Icon(
                              CupertinoIcons.pencil,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My account',
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _optionItem('Update infomation', Colors.black, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ModifyProfileScreen()));
                }, false),
                _optionItem('Saved location', Colors.black, () {}, false),
                _optionItem('My orders', Colors.black, () {}, false),
                _optionItem('Sign out', Colors.red, () {}, true)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Eater testEater = Eater(
  eaterId: 1,
  displayName: 'Pho 10 Ly Quoc Su',
  email: 'gatanai@gmail.com',
  phone: '0983473223',
  avatar: 'assets/images/store_avatar.jpg',
);
