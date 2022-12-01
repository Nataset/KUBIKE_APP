import 'package:flutter/material.dart';
import 'package:kubike_app/page/home.dart';
import 'package:kubike_app/page/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/service/auth_service.dart';
import 'package:provider/provider.dart';

import 'model/bike_model.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BikeProvider()),
        Provider(create: (context) {
          final bikeProvider = context.read<BikeProvider>();
          return AuthService(bikeProvider: bikeProvider);
        }),
      ],
      child: MaterialApp(
          title: 'KU BIKE',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const LoginPage()),
    );
  }
}
