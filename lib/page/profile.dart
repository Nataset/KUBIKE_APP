import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubike_app/page/login.dart';
import 'package:kubike_app/page/map.dart';
import 'package:kubike_app/service/auth_service.dart';
import 'package:kubike_app/share/color.dart';
import 'package:kubike_app/util/show_loading.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> history = ['1', '1', '1', '1', '1', '1', '1', '1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkGreen,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      // color: Colors.red,
                      child: Column(children: [
                        Text(
                          'Nataset',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.darkGreen),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                            padding: EdgeInsets.only(left: 30, right: 30),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700]),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              // color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'nataset@ku.th',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Nataset Tanabodee',
                                    style: TextStyle(
                                      fontSize: 18,
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
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ประวัติ',
                              style: GoogleFonts.kanit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.grey[700]),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey[500],
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: history.length,
                              itemBuilder: ((context, index) => Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[350],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Column(
                                      children: [
                                        Text(
                                          'หมายเลขจักรยาน',
                                          style: GoogleFonts.kanit(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '1234567890123456',
                                          style:
                                              GoogleFonts.kanit(fontSize: 16),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20, top: 10),
                                              decoration: BoxDecoration(
                                                  color: AppColor.red,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text('ยืม'),
                                                    Text('10/12/22'),
                                                    Text('10:30 am')
                                                  ]),
                                            ),
                                            if (index % 2 == 0)
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColor.darkGreen,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        'คืน',
                                                        style:
                                                            GoogleFonts.kanit(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      Text('10/12/22',
                                                          style:
                                                              GoogleFonts.kanit(
                                                                  color: Colors
                                                                      .white)),
                                                      Text('10:30 am',
                                                          style:
                                                              GoogleFonts.kanit(
                                                                  color: Colors
                                                                      .white))
                                                    ]),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )))),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: Column(
              children: [
                Divider(
                  thickness: 2,
                  color: Colors.grey[500],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: AppColor.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        textStyle: const TextStyle(fontSize: 18),
                        foregroundColor: AppColor.darkGreen),
                    onPressed: () {
                      signOutHandle(context: context);
                    },
                    child: Text('ออกจากระบบ',
                        style: GoogleFonts.kanit(
                            color: Colors.white, fontWeight: FontWeight.w500))),
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
