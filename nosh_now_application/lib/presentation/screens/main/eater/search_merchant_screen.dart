import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:latlong2/latlong.dart';
import 'package:nosh_now_application/core/utils/map.dart';
import 'package:nosh_now_application/data/models/merchant_with_distance.dart';
import 'package:nosh_now_application/data/repositories/merchant_repository.dart';
import 'package:nosh_now_application/presentation/screens/main/eater/merchant_detail_screen.dart';
import 'package:nosh_now_application/presentation/widgets/merchant_item.dart';

class SearchMerchantScreen extends StatefulWidget {
  const SearchMerchantScreen({
    super.key,
  });

  @override
  State<SearchMerchantScreen> createState() => _SearchMerchantScreenState();
}

class _SearchMerchantScreenState extends State<SearchMerchantScreen> {
  final TextEditingController _controller = TextEditingController();
  ValueNotifier<List<MerchantWithDistance>> merchants = ValueNotifier([]);
  late ValueNotifier<bool> isLoading = ValueNotifier(false);
  late ValueNotifier<String> regex = ValueNotifier("");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                    const SizedBox(
                      height: 12,
                    ),
                    ValueListenableBuilder(
                        valueListenable: regex,
                        builder: (context, value, child) {
                          return Text(
                            "Search '$value'",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              color: Color.fromRGBO(49, 49, 49, 1),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 12,
                    ),
                    ValueListenableBuilder(
                        valueListenable: merchants,
                        builder: (context, value, child) {
                          if (value.isEmpty && isLoading.value == false) {
                            return Text(
                              "Don't have any merchant has name contain '${regex.value}'",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                                color: Color.fromRGBO(49, 49, 49, 1),
                              ),
                            );
                          }
                          return Column(
                            children: List.generate(value.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MerchantDetailScreen(
                                                  merchant: value[index])));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child:
                                        MerchantItem(merchant: value[index])),
                              );
                            }),
                          );
                        }),
                    ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, value, child) {
                          if (value) {
                            return const Center(
                              child: SpinKitCircle(
                                color: Colors.black,
                                size: 50,
                              ),
                            );
                          }
                          return const SizedBox();
                        })
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // back
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          CupertinoIcons.arrow_left,
                          size: 24,
                          color: Color.fromRGBO(49, 49, 49, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        height: 40,
                        child: TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  isLoading.value = true;
                                  merchants.value = [];
                                  regex.value = _controller.text.trim();
                                  LatLng coord = await checkPermissions();
                                  merchants.value = await MerchantRepository()
                                      .FindByRegex(_controller.text.trim(),
                                          '${coord.latitude}-${coord.longitude}');
                                  isLoading.value = false;
                                },
                                icon: const Icon(
                                  CupertinoIcons.search,
                                  color: Colors.black,
                                  size: 20,
                                )),
                            hintText: "ex. Pho 10, abc,...",
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(159, 159, 159, 1)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(35, 35, 35, 1),
                                width: 1,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                              color: Color.fromRGBO(49, 49, 49, 1),
                              fontSize: 14,
                              decoration: TextDecoration.none),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
