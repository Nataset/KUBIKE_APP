import 'package:flutter/material.dart';

void showLoading({required BuildContext context}) {
  showDialog(
      context: context,
      builder: ((context) => Center(
            child: CircularProgressIndicator(strokeWidth: 4),
          )));
}

void unshowLoading({required BuildContext context}) {
  Navigator.of(context).pop(context);
}
