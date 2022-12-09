import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/share/constants.dart';
import 'package:kubike_app/util/storage.dart';
import 'package:provider/provider.dart';

import '../model/bike_model.dart';
import '../model/user_model.dart';

class AuthService {
  final _googleSignIn = GoogleSignIn();
  final BikeProvider _bikeProvider;
  User? _currentUser;

  AuthService({required BikeProvider bikeProvider})
      : _bikeProvider = bikeProvider;

  User? get currentUser => _currentUser;

  Future<void> init() async {
    print('init method run');
    final accessToken = await Storage.getAccessToken();

    if (accessToken == null) return;

    late http.Response getUserRes;
    try {
      getUserRes = await http.post(Uri.parse('$BACKEND_URL/api/me'), headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${accessToken}"
      });

      if (getUserRes.statusCode == 401) {
        return;
      }

      if (getUserRes.statusCode != 200) {
        print(getUserRes.statusCode);
        print(getUserRes.body);
        throw Exception('init error');
      }
    } on http.ClientException catch (e) {
      print(e.message);
      throw Exception("Can't connect to the backend service");
    } catch (e) {
      print(e);
      throw Exception("Init Error");
    }

    Map<String, dynamic> userMap = jsonDecode(getUserRes.body);

    _currentUser = User(
      name: userMap['name'],
      email: userMap['email'],
      googleId: userMap['google_id'],
      id: userMap['id'].toString(),
      profileImage: userMap['profile_image'],
    );

    final Bike? bike = userMap['current_bike'] != null
        ? Bike(
            // id: userMap['current_bike']['id'].toString(),
            lockCode: userMap['current_bike']['lock_code'],
            bikeCode: userMap['current_bike']['bike_code'],
            borrowAt: parseDateTime(userMap['latest_status']['borrow_at']))
        : null;

    _bikeProvider.currentBike = bike;
  }

  Future<void> googleLogin() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final googleToken = googleAuth?.accessToken;

    log(googleAuth!.accessToken.toString());

    http.Response authPostRes;

    print('test from auth server 1');
    try {
      authPostRes = await http.post(Uri.parse('$BACKEND_URL/api/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"access_token": googleToken}));
    } on http.ClientException catch (e) {
      print(e.message);
      rethrow;
    }

    print('test from auth server 2');

    if (authPostRes.statusCode != 200) {
      print(authPostRes.statusCode);
      print(authPostRes.body);
      throw Exception('google login error');
    }

    Map<String, dynamic> authResMap = jsonDecode(authPostRes.body);
    Map<String, dynamic> userMap = authResMap['user'];

    Storage.setAccessToken(authResMap['access_token']);
    _currentUser = User(
        name: googleUser?.displayName ?? "Unknown",
        email: userMap['email'],
        googleId: userMap['google_id'],
        id: userMap['id'].toString(),
        profileImage: userMap['profile_image']);

    print(userMap['current_bike']);

    final Bike? bike = userMap['current_bike'] != null
        ? Bike(
            // id: userMap['current_bike']['id'].toString(),
            lockCode: userMap['current_bike']['lock_code'],
            bikeCode: userMap['current_bike']['bike_code'],
            borrowAt: parseDateTime(userMap['latest_status']['borrow_at']))
        : null;

    _bikeProvider.currentBike = bike;

    print('test from auth server 3');
  }

  Future<void> googleSignOut() async {
    _currentUser = null;

    await _googleSignIn.signOut();

    await Storage.deleteAccessToken();
  }

  DateTime parseDateTime(String dateString) => DateTime.parse(dateString);
}
