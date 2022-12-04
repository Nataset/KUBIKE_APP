import 'package:flutter/material.dart';

class Bike extends ChangeNotifier {
  String lockCode;
  String bikeCode;
  DateTime borrowAt;

  Bike(
      {required this.lockCode, required this.bikeCode, required this.borrowAt});
}
