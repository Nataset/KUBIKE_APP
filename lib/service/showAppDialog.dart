import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAppDialog(
    {required BuildContext context,
    required String title,
    required String content}) async {
  return showDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(
            'OK',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
