import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kubike_app/share/constants.dart';

import '../util/storage.dart';

class HistoryService {
  static Future<List<dynamic>?> fetchHistory() async {
    final accessToken = await Storage.getAccessToken();
    try {
      http.Response getHistoryRes = await http
          .get(Uri.parse('${BACKEND_URL}/api/me/history'), headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${accessToken}"
      });

      final historys = jsonDecode(getHistoryRes.body)['data'] as List<dynamic>;
      return historys;
    } catch (e) {
      print(e);
    }
  }
}
