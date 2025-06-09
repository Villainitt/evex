import 'package:flutter/material.dart';
//mostra a snack bar de erro ou validação
showSnackBar({required BuildContext context, required String aviso, bool isErro = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(aviso),
    backgroundColor: (isErro)? Colors.red : Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
