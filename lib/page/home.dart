import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kubike_app/page/bike_borrow.dart';
import 'package:kubike_app/page/bike_return.dart';
import 'package:kubike_app/page/login.dart';
import 'package:kubike_app/page/map.dart';
import 'package:kubike_app/page/profile.dart';
import 'package:kubike_app/page/setting.dart';
import 'package:kubike_app/page/test.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  var screens = [MapPage(), BikeReturnPage(), ProfilePage(), SettingPage()];

  @override
  Widget build(BuildContext context) {
    BikeProvider bikeProvider = context.watch<BikeProvider>();
    bool isBorrow = bikeProvider.isBorrow();

    if (isBorrow) {
      setState(() {
        screens[1] = BikeReturnPage();
      });
    } else {
      setState(() {
        screens[1] = BikeBorrowPage();
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
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map'),
            NavigationDestination(
                icon: Icon(Icons.pedal_bike_outlined),
                selectedIcon: Icon(Icons.pedal_bike),
                label: 'Bicycle'),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Setting'),
          ],
        ),
      ),
    );
  }
}
