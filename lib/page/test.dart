import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/service/location_service.dart';
import 'package:provider/provider.dart';

import '../model/bike_model.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Position? currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          child: Column(
            children: [
              OutlinedButton(
                  onPressed: () async {
                    final position = await LocationService.determinePosition();
                    print(currentPosition);
                    print(position.longitude);
                    print(position.latitude);
                    setState(() {
                      currentPosition = position;
                    });

                    print(currentPosition);
                  },
                  child: Text('Get Current location')),
              Text(
                  "Locatlion Longitude: ${currentPosition != null ? currentPosition!.longitude : 'unknown'}, Latitude: ${currentPosition != null ? currentPosition!.latitude : 'unknown'}"),
              OutlinedButton(
                  onPressed: () {
                    final bikeProvider = context.read<BikeProvider>();
                    if (bikeProvider.currentBike == null) {
                      bikeProvider.currentBike =
                          Bike(lockCode: 'test', bikeCode: 'test');
                    } else {
                      bikeProvider.currentBike = null;
                    }
                  },
                  child: Text('Change Bike in Provider')),
              Text(context.watch<BikeProvider>().currentBike?.bikeCode ??
                  'NO BIKE'),
              Text(
                  "isBike Borrow: ${context.watch<BikeProvider>().isBorrow().toString()}"),
              // StreamBuilder(
              //     stream: context.read<BikeProvider>().getIsBorrowStream(),
              //     builder: ((context, snapshot) =>
              //         Text(snapshot.data.toString())))
            ],
          ),
        ),
      ),
    );
  }
}
