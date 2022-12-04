import 'package:flutter/material.dart';
import 'package:kubike_app/page/home.dart';
import 'package:kubike_app/page/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/provider/map_provider.dart';
import 'package:kubike_app/service/auth_service.dart';
import 'package:provider/provider.dart';

import 'model/bike_model.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const App());
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();

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
        Provider(create: (_) => MapLastLocationProvider())
      ],
      child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          title: 'KU BIKE',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const LoginPage()),
    );
  }
}
