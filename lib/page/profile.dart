import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubike_app/model/user_model.dart';
import 'package:kubike_app/page/login.dart';
import 'package:kubike_app/page/map.dart';
import 'package:kubike_app/service/auth_service.dart';
import 'package:kubike_app/service/history_service.dart';
import 'package:kubike_app/share/color.dart';
import 'package:kubike_app/util/show_loading.dart';
import 'package:provider/provider.dart';

import '../util/formatDateTime.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.read<AuthService>().currentUser;

    return Scaffold(
      backgroundColor: AppColor.darkGreen,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[500]),
                        child: user?.profileImage != null
                            ? CircleAvatar(
                                radius: 48,
                                backgroundImage:
                                    NetworkImage(user!.profileImage!),
                              )
                            : Center(
                                child: Text(
                                user!.name[0],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold),
                              ))),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      // color: Colors.red,
                      child: Column(children: [
                        Text(
                          user.name.split(' ')[0],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.darkGreen),
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 0, top: 0),
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Divider(
                              thickness: 2,
                              color: AppColor.lightGreen,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700]),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'profile.history',
                              style: GoogleFonts.kanit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.grey[700]),
                            ).tr(),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                color: Colors.grey[50],
                              ),
                              FutureBuilder<List<dynamic>?>(
                                  future: HistoryService.fetchHistory(),
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: List.generate(
                                          snapshot.data!.length,
                                          (index) => Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 30),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              Colors.grey[600]!,
                                                          offset: Offset(0, 3),
                                                          spreadRadius: 0,
                                                          blurRadius: 10)
                                                    ],
                                                    // border: Border.all(
                                                    //     width: 2,
                                                    //     color: Colors.grey[500]!),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'profile.bikeId',
                                                      style: GoogleFonts.kanit(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ).tr(),
                                                    Text(
                                                      snapshot.data![index]
                                                          ['bike']['bike_code'],
                                                      style: GoogleFonts.kanit(
                                                          fontSize: 16),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  top: 10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  AppColor.gray,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5))),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  'profile.borrow',
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ).tr(),
                                                                Text(
                                                                  FormatDateTime.formatDay(
                                                                      DateTime.parse(
                                                                          snapshot.data![index]
                                                                              [
                                                                              'borrow_at'])),
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                Text(
                                                                  FormatDateTime.formatTime(
                                                                      DateTime.parse(
                                                                          snapshot.data![index]
                                                                              [
                                                                              'borrow_at'])),
                                                                  style: GoogleFonts.kanit(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )
                                                              ]),
                                                        ),
                                                        if (snapshot.data![
                                                                    index]
                                                                ['return_at'] !=
                                                            null)
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20,
                                                                    top: 5),
                                                            decoration: BoxDecoration(
                                                                color: AppColor
                                                                    .gray,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5))),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    'profile.return',
                                                                    style: GoogleFonts.kanit(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ).tr(),
                                                                  Text(
                                                                      FormatDateTime.formatDay(DateTime.parse(
                                                                          snapshot.data![index]
                                                                              [
                                                                              'return_at'])),
                                                                      style: GoogleFonts.kanit(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                  Text(
                                                                      FormatDateTime.formatTime(DateTime.parse(
                                                                          snapshot.data![index]
                                                                              [
                                                                              'return_at'])),
                                                                      style: GoogleFonts.kanit(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w500))
                                                                ]),
                                                          ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 40),
                                            height: 50,
                                            width: 50,
                                            child:
                                                const CircularProgressIndicator()),
                                      );
                                    }
                                  }))
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: Column(
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.grey[500],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColor.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        textStyle: const TextStyle(fontSize: 18),
                        foregroundColor: AppColor.darkGreen),
                    onPressed: () {
                      signOutHandle(context: context);
                    },
                    child: Text('profile.signOut',
                            style: GoogleFonts.kanit(
                                color: Colors.white,
                                fontWeight: FontWeight.w500))
                        .tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signOutHandle({required BuildContext context}) async {
    final authService = context.read<AuthService>();
    showLoading(context: context);

    await authService.googleSignOut();

    unshowLoading(context: context);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        ((route) => false));
  }
}
