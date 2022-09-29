import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kubike_app/share/color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../api/google_signin_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Future googleSignIn() async {
      final GoogleSignInAccount? user = await GoogleSignInApi.login();

      final GoogleSignInAuthentication? googleAuth = await user?.authentication;

      print(googleAuth?.idToken);
      print(googleAuth?.accessToken);

      // if (user == null || googleAuth == null) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text('Sign in Failed')));
      // } else {
      //   print('go to next page');
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //       builder: (context) =>
      //           LoggedInPage(user: user, googleAuth: googleAuth)));
      // }
    }

    return Container(
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
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text('Hey There,',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: AppColor.darkGreen)),
                    Text('Welcom to KU-Bike',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: AppColor.darkGreen)),
                    SizedBox(height: 16),
                    Text(
                      'Please Login to your Kasetsart account to continue',
                      style: TextStyle(color: AppColor.darkGreen, fontSize: 16),
                    ),
                    const SizedBox(height: 60),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            side: BorderSide(color: AppColor.darkGreen),
                            textStyle: const TextStyle(fontSize: 18),
                            foregroundColor: AppColor.darkGreen),
                        onPressed: () => print('login with Nontri press'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text('KU',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w900)),
                            Text('Login with Nontri'),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        )),
                    SizedBox(
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            side: BorderSide(color: AppColor.darkGreen),
                            textStyle: const TextStyle(fontSize: 18),
                            foregroundColor: AppColor.darkGreen),
                        onPressed: googleSignIn,
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
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
