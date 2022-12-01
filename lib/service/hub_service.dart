import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kubike_app/model/hub_model.dart';
import 'package:http/http.dart' as http;
import '../share/constants.dart';

class HubService {
  static Future<List<Hub>?> fetchHubs() async {
    print(Uri.parse('$BACKEND_URL/api/hubs'));
    try {
      var res = await http.get(Uri.parse('$BACKEND_URL/api/hubs'));

      if (res.statusCode == 200) {
        List rawHubs = json.decode(res.body)["data"];
        List<Hub> serialHubs = rawHubs.map((hub) => Hub.fromJson(hub)).toList();
        return serialHubs;
      } else {
        print('****** fetch hubs return ${res.statusCode} status code ******');
        return null;
      }
    } on http.ClientException catch (e) {
      print(e.message);
      print('******fetch hubs fail******');
      return null;
    }
  }

  static Future<Hub?> fetchHub({required String hubId}) async {
    try {
      final res = await http.get(Uri.parse('$BACKEND_URL/api/hubs/$hubId'));

      if (res.statusCode == 200) {
        Map<String, dynamic> hubMap = json.decode(res.body)["data"];
        Hub hub = Hub.fromJson(hubMap);
        return hub;
      } else {
        print('****** fetch hub return ${res.statusCode} status code ******');
        return null;
      }
    } on http.ClientException catch (e) {
      print(e.message);
      print('********fetch hub fail*********');
      return null;
    }
  }
}
