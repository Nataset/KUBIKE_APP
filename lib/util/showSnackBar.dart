import 'package:flutter/material.dart';

import '../main.dart';

void showSnackBar(String? text, {Color? backgroundColor}) {
  if (text == null) return;

  final snackBar = SnackBar(
    content: Text(
      text,
      selectionColor: Colors.white,
    ),
    backgroundColor: backgroundColor ?? Colors.red[900],
  );

  messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
