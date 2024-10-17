/*
Author: Soh Wei Meng (swmeng@yes.my)
Date: 12 September 2019
Sparta App
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showErrorDialog(String? message, BuildContext context,
    {bool isInfo = false}) {
  if (message == "") {
    message = "Please try again later";
  }
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      scrollable: true,
      title: Text(isInfo ? 'Info' : 'An Error Occurred!'),
      content: SelectableText(message!),
      actions: <Widget>[
        TextButton(
          child: const Text('Copy'),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: message ?? ""));
          },
        ),
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
