import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:kubike_app/page/home.dart';
import 'package:kubike_app/service/auth_service.dart';
import 'package:kubike_app/service/showAppDialog.dart';
import 'package:kubike_app/share/color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kubike_app/util/show_loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _initAuth(BuildContext context) async {
    final authService = context.read<AuthService>();
    try {
      await authService.init();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Error"),
          content: Text("login.dialog.connectError").tr(),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }

    if (authService.currentUser != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const HomePage())),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAuth(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                  height: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/background.png'),
                          fit: BoxFit.cover))),
            ],
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(32),
                    margin: const EdgeInsets.only(bottom: 200),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Text('login.welcome',
                                style: GoogleFonts.kanit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: AppColor.darkGreen))
                            .tr(),
                        SizedBox(height: 16),
                        Text(
                          'login.welcomeDescribe',
                          style: GoogleFonts.kanit(
                              color: AppColor.darkGreen, fontSize: 16),
                        ).tr(),
                        const SizedBox(height: 60),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                side: BorderSide(color: AppColor.darkGreen),
                                textStyle: const TextStyle(fontSize: 18),
                                foregroundColor: AppColor.darkGreen),
                            onPressed: () {
                              googleSignInHandle(context: context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(FontAwesomeIcons.google),
                                  const Text('login.loginGoogle').tr(),
                                  const SizedBox(
                                    width: 0,
                                  )
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(children: [
                          Expanded(child: Divider(color: Colors.grey[600])),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "or",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[600])),
                        ]),
                        const SizedBox(
                          height: 25,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                side: BorderSide(color: AppColor.darkGreen),
                                textStyle: const TextStyle(fontSize: 18),
                                foregroundColor: AppColor.darkGreen),
                            onPressed: () {
                              showAppDialog(
                                  context: context,
                                  title: 'Error',
                                  content:
                                      "this feature, still in development");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text('KU',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900)),
                                ),
                                const Text('login.loginNontri').tr(),
                                const SizedBox(
                                  width: 0,
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> googleSignInHandle({required BuildContext context}) async {
    final AuthService authService = context.read<AuthService>();
    showLoading(context: context);

    try {
      await authService.googleLogin();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } on ClientException catch (e) {
      await authService.googleSignOut();
      unshowLoading(context: context);
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Error"),
          content: const Text("login.connectError").tr(),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } catch (e) {
      await authService.googleSignOut();
      unshowLoading(context: context);
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Error"),
          content: const Text('Login with Google Account Fail'),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
