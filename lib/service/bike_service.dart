import 'dart:convert';

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

    try {
      final borrowPostRes = await http.post(
          Uri.parse('$BACKEND_URL/api/borrow/$bikeCode'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${accessToken}"
          },
          body: jsonEncode({
            "latitude": currentPosition.latitude,
            "longitude": currentPosition.longitude
          }));

      if (borrowPostRes.statusCode == 400) {
        throw BikeApiException(borrowPostRes.body);
      }

      if (borrowPostRes.statusCode != 200) {
        throw Exception(
            'post fail with statusCode: ${borrowPostRes.statusCode}, message: ${borrowPostRes.body}');
      }

      Map<String, String> bikeMap = jsonDecode(borrowPostRes.body);
      Bike borrowedBike = Bike(
          lockCode: bikeMap['lock_code']!, bikeCode: bikeMap['bike_code']!);
      bikeProvider.currentBike = borrowedBike;
    } on http.ClientException catch (e) {
      print(e.message);
      throw Exception('post to borrow bike fail');
    } on BikeApiException catch (e) {
      rethrow;
    }
  }
}
