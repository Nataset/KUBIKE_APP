import 'package:flutter/material.dart';
import 'package:kubike_app/model/bike_model.dart';

class User extends ChangeNotifier {
  String name;
  String email;
  String? googleId;
  String id;
  String? profileImage;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.profileImage,
    this.googleId,
  });
}
