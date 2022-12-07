import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kubike_app/exception/location_disabled_exception.dart';
import 'package:kubike_app/exception/location_permission_exception.dart';
import 'package:kubike_app/service/showAppDialog.dart';

class LocationService {
  static Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      throw LocationDisabledException('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        throw LocationPermissionException('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      throw LocationPermissionException(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  static LocationSettings getLocationSettings() {
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 5)
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          );
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    return locationSettings;
  }

  static Future<Stream<Position>?> getPositionStream(context) async {
    try {
      await checkPermission();
    } on LocationDisabledException catch (e) {
      await showAppDialog(context: context, title: 'Error', content: e.message);
      await Geolocator.openLocationSettings();
      return null;
    } on LocationPermissionException catch (e) {
      await showAppDialog(context: context, title: 'Error', content: e.message);
      await Geolocator.openAppSettings();
      return null;
    } finally {}

    return Geolocator.getPositionStream(
        locationSettings: getLocationSettings());
  }

  static Future<Position?> determinePosition(context) async {
    try {
      await checkPermission();
    } on LocationDisabledException catch (e) {
      print(e.message);
      await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("ERROR"),
          content: const Text('dialog.locationOff').tr(),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'dialog.no',
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'dialog.yes',
              ).tr(),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );
      await Geolocator.openLocationSettings();
      return null;
    } on LocationPermissionException catch (e) {
      print(e.message);
      await showDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("ERROR"),
          content: const Text('dialog.locationNoPermission').tr(),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'dialog.no',
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'dialog.yes',
              ).tr(),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
              },
            ),
          ],
        ),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
