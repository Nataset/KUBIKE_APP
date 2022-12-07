import 'package:easy_localization/easy_localization.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('th')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: const App()),
  );
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
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          scaffoldMessengerKey: messengerKey,
          title: 'KU BIKE',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const LoginPage()),
    );
  }
}
