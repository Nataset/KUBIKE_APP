import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kubike_app/model/hub_model.dart';
import 'package:http/http.dart' as http;

class HubService {
  static final String? baseUrl = dotenv.env['BACKEND_URL'];

  static Future<List<Hub>?> fetchHubs() async {
    print(baseUrl);
    var res = await http.get(Uri.parse('$baseUrl/api/hubs'));

    if (res.statusCode == 200) {
      List rawHubs = json.decode(res.body);
      List<Hub> serialHubs = rawHubs.map((hub) => Hub.fromJson(hub)).toList();
      return serialHubs;
    } else {
      return null;
    }
  }
}
