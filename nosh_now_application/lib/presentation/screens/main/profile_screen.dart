import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/streams/user_login_stream.dart';
import 'package:nosh_now_application/core/utils/image.dart';
import 'package:nosh_now_application/core/utils/shared_preference.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/location_management_screen.dart';
import 'package:nosh_now_application/presentation/screens/main/modify_profile_screen.dart';
import 'package:provider/provider.dart';

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

  List<Widget> _listOptionByRole(context) {
    if (GlobalVariable.roleName == "Eater") {
      return [
        _optionItem('Update infomation', Colors.black, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ModifyProfileScreen()));
        }, false),
        _optionItem('Saved location', Colors.black, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationManagementScreen()));
        }, false),
        _optionItem('My orders', Colors.black, () {}, false),
        _optionItem('Sign out', Colors.red, () async {
          GlobalVariable.currentUid = 0;
          GlobalVariable.roleId = 0;
          GlobalVariable.roleName = '';
          GlobalVariable.user = null;
          await disposeUserInfo();
          await destroyAccount();
          await destroyRole();
          await destroyToken();
          Provider.of<UserLogin>(context, listen: false).logout();
        }, true)
      ];
    } else {
      return [
        _optionItem('Update infomation', Colors.black, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ModifyProfileScreen()));
        }, false),
        _optionItem('My orders', Colors.black, () {}, false),
        _optionItem('Sign out', Colors.red, () async {
          GlobalVariable.currentUid = 0;
          GlobalVariable.roleId = 0;
          GlobalVariable.roleName = '';
          GlobalVariable.user = null;
          await disposeUserInfo();
          await destroyAccount();
          await destroyRole();
          await destroyToken();
          Provider.of<UserLogin>(context, listen: false).logout();
        }, true)
      ];
    }
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
            // child: FutureBuilder(
            //     future: getUser(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done &&
            //           snapshot.hasData) {
            //         return Row(
            //           children: [
            //             Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   snapshot.data.displayName,
            //                   maxLines: 1,
            //                   style: const TextStyle(
            //                     fontSize: 20.0,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.white,
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                 ),
            //                 Text(
            //                   GlobalVariable.roleName,
            //                   maxLines: 1,
            //                   style: const TextStyle(
            //                     fontSize: 18.0,
            //                     fontWeight: FontWeight.w400,
            //                     color: Colors.white,
            //                     overflow: TextOverflow.ellipsis,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             const Expanded(child: SizedBox()),
            //             GestureDetector(
            //               onTap: () async {},
            //               child: SizedBox(
            //                 height: 100,
            //                 child: Stack(
            //                   children: [
            //                     Container(
            //                       decoration: BoxDecoration(
            //                           border: Border.all(
            //                               color: Colors.white, width: 2),
            //                           borderRadius: BorderRadius.circular(50)),
            //                       child: CircleAvatar(
            //                         backgroundColor: Colors.black,
            //                         radius: 50,
            //                         backgroundImage: MemoryImage(
            //                             convertBase64ToUint8List(
            //                                 snapshot.data.avatar)),
            //                       ),
            //                     ),
            //                     Positioned(
            //                       bottom: 0,
            //                       right: 3,
            //                       child: Container(
            //                         height: 30,
            //                         width: 30,
            //                         decoration: BoxDecoration(
            //                             color: Colors.white,
            //                             borderRadius:
            //                                 BorderRadius.circular(50)),
            //                         child: const Icon(
            //                           CupertinoIcons.pencil,
            //                           size: 16,
            //                           color: Colors.black,
            //                         ),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         );
            //       } else {
            //         return const SpinKitCircle(
            //           color: Colors.black,
            //         );
            //       }
            //     }),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GlobalVariable.user.displayName,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      GlobalVariable.roleName,
                      maxLines: 1,
                      style: const TextStyle(
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
                            backgroundImage: MemoryImage(
                                convertBase64ToUint8List(
                                    GlobalVariable.user.avatar)),
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
                ..._listOptionByRole(context)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
