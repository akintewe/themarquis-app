/*
Author: Soh Wei Meng (swmeng@yes.my)
Date: 12 September 2019
Sparta App
*/

import 'package:flutter/material.dart';

void showErrorDialog(String? message, BuildContext context,
    {bool isInfo = false}) {
  if (message == "") {
    message = "Please try again later";
  }
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isInfo ? 'Info' : 'An Error Occurred!'),
      content: Text(message!),
      actions: <Widget>[
        TextButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
