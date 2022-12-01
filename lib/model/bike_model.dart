import 'package:flutter/material.dart';

class Bike extends ChangeNotifier {
  String lockCode;
  String bikeCode;

  Bike({required this.lockCode, required this.bikeCode});
}
