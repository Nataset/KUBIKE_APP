import 'package:flutter/material.dart';
import 'package:kubike_app/page/home.dart';
import 'package:kubike_app/page/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //       title: 'KU BIKE',
  //       theme: ThemeData(primarySwatch: Colors.green),
  //       home: const LoginPage(),
  //       initialRoute: LoginPage.routeName,
  //       routes: {LoginPage.routeName: (context) => const LoginPage()});
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KU BIKE',
        theme: ThemeData(primarySwatch: Colors.green),
        home: const HomePage());
  }
}



//   Future signIn() async {
//     final GoogleSignInAccount? user = await GoogleSignInApi.login();

//     final GoogleSignInAuthentication? googleAuth = await user?.authentication;

//     print(googleAuth?.idToken);
//     print(googleAuth?.accessToken);

//     if (user == null || googleAuth == null) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Sign in Failed')));
//     } else {
//       print('go to next page');
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) =>
//               LoggedInPage(user: user, googleAuth: googleAuth)));
//     }
//   }
// }


