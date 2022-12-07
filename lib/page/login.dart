import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
          content: Text(
              "Can't connect to the backend service, Please try again later"),
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
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                // padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.only(bottom: 200),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Text('ยินดีตอนรับสู่ KU BIKE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: AppColor.darkGreen)),
                      SizedBox(height: 16),
                      Text(
                        'กรุณา Login โดยใช้ Kasetsart Google account เพื่อใช้งาน',
                        style:
                            TextStyle(color: AppColor.darkGreen, fontSize: 16),
                      ),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Icon(FontAwesomeIcons.google),
                              Text('Login with Google'),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(children: [
                        Expanded(child: Divider(color: Colors.grey[600])),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "or",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[600])),
                      ]),
                      SizedBox(
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
                                content: "this feature, still in development");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('KU',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900)),
                              Text('Login with Nontri'),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
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
          title: Text("Error"),
          content: Text(
              "Can't connect to the backend service, Please try again later"),
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
    } catch (e) {
      await authService.googleSignOut();
      unshowLoading(context: context);
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("Error"),
          content: Text('Login with Google Account Fail'),
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
  }
}
