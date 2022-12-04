import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kubike_app/exception/bike_api_exception.dart';
import 'package:kubike_app/model/bike_model.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/share/constants.dart';

import '../util/storage.dart';

class BikeService {
  static Future<void> borrowBike(
      {required String bikeCode,
      required Position currentPosition,
      required BikeProvider bikeProvider}) async {
    final accessToken = await Storage.getAccessToken();

    log(currentPosition.toString());

    try {
      final borrowPostRes = await http.post(
          Uri.parse('$BACKEND_URL/api/borrow/$bikeCode'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${accessToken}"
          },
          body: jsonEncode({
            // "latitude": currentPosition.latitude,
            // "longitude": currentPosition.longitude
            "latitude": 13.847279,
            "longitude": 100.571521
          }));

      if (borrowPostRes.statusCode == 400 || borrowPostRes.statusCode == 404) {
        log(borrowPostRes.statusCode.toString());
        throw BikeApiException(borrowPostRes.body);
      }

      if (borrowPostRes.statusCode != 200) {
        throw Exception(
            'post fail with statusCode: ${borrowPostRes.statusCode}, message: ${borrowPostRes.body}');
      }

      Map<String, dynamic> bikeMap = jsonDecode(borrowPostRes.body);
      Bike borrowedBike = Bike(
          lockCode: bikeMap['lock_code']!,
          bikeCode: bikeMap['bike_code']!,
          borrowAt: DateTime.now());
      bikeProvider.currentBike = borrowedBike;
    } on http.ClientException catch (e) {
      print(e.message);
      throw Exception('post to borrow bike fail');
    } on BikeApiException catch (e) {
      rethrow;
    }
  }

  static Future<void> returnBike(
      {required String bikeCode,
      required Position currentPosition,
      required BikeProvider bikeProvider}) async {
    final accessToken = await Storage.getAccessToken();

    log(currentPosition.toString());

    try {
      final borrowPostRes = await http.post(
          Uri.parse('$BACKEND_URL/api/return/$bikeCode'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${accessToken}"
          },
          body: jsonEncode({
            // "latitude": currentPosition.latitude,
            // "longitude": currentPosition.longitude
            "latitude": 13.847279,
            "longitude": 100.571521
          }));

      if (borrowPostRes.statusCode == 400 || borrowPostRes.statusCode == 404) {
        throw BikeApiException(borrowPostRes.body);
      }

      if (borrowPostRes.statusCode != 200) {
        throw Exception(
            'post fail with statusCode: ${borrowPostRes.statusCode}, message: ${borrowPostRes.body}');
      }

      bikeProvider.currentBike = null;
    } on http.ClientException catch (e) {
      print(e.message);
      throw Exception('post to borrow bike fail');
    } on BikeApiException catch (e) {
      rethrow;
    }
  }
}
