import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kubike_app/page/bike_borrow.dart';
import 'package:kubike_app/page/bike_return.dart';
import 'package:kubike_app/page/map.dart';
import 'package:kubike_app/page/profile.dart';
import 'package:kubike_app/page/setting.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  var screens = [
    const MapPage(),
    const BikeReturnPage(),
    const ProfilePage(),
    const SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    BikeProvider bikeProvider = context.watch<BikeProvider>();
    bool isBorrow = bikeProvider.isBorrow();

    if (isBorrow) {
      setState(() {
        screens[1] = const BikeReturnPage();
      });
    } else {
      setState(() {
        screens[1] = const BikeBorrowPage();
      });
    }

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.blue[100],
            labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() {
            this.index = index;
          }),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
                icon: const Icon(Icons.map_outlined),
                selectedIcon: const Icon(Icons.map),
                label: 'home.map'.tr()),
            NavigationDestination(
                icon: const Icon(Icons.pedal_bike_outlined),
                selectedIcon: const Icon(Icons.pedal_bike),
                label: 'home.bicycle'.tr()),
            NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: 'home.profile'.tr()),
            NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: 'home.setting'.tr()),
          ],
        ),
      ),
    );
  }
}
