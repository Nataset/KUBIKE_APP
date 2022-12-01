import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kubike_app/model/bike_model.dart';

class BikeProvider extends ChangeNotifier {
  Bike? _bike;

  BikeProvider({Bike? bike}) : _bike = bike;

  StreamController<bool> _controller = StreamController();

  Bike? get currentBike => _bike;

  set currentBike(Bike? bike) {
    _bike = bike;
    _controller.add(isBorrow());
    notifyListeners();
  }

  bool isBorrow() => _bike == null ? false : true;

  Stream<bool> getIsBorrowStream() => _controller.stream;
}
