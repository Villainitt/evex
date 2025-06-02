import 'package:flutter/material.dart';

showSnackBar({required BuildContext context, required String aviso, bool isErro = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(aviso),
    backgroundColor: (isErro)? Colors.red : Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
