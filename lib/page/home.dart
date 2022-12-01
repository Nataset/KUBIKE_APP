import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kubike_app/page/bike_borrow.dart';
import 'package:kubike_app/page/bike_return.dart';
import 'package:kubike_app/page/login.dart';
import 'package:kubike_app/page/map.dart';
import 'package:kubike_app/page/profile.dart';
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
  late StreamSubscription<bool?>? isBorrowSub;
  var screens = [MapPage(), BikeBorrowPage(), ProfilePage(), TestPage()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final isBorrowStream = context.read<BikeProvider>().getIsBorrowStream();

    isBorrowSub = isBorrowStream.listen((isBorrow) {
      if (mounted) {
        if (isBorrow) {
          setState(() {
            screens[1] = BikeReturnPage();
          });
        } else {
          setState(() {
            screens[1] = BikeBorrowPage();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isBorrowSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
