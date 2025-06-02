import 'package:cloud_firestore/cloud_firestore.dart';

class VerificarIdEvento {
  static Future<String> gerarIdUnico() async {
  int index = 1;
  String idGerado;
  bool existe = true;

  while (existe) {
    idGerado = "EV${index.toString().padLeft(2, '0')}";
    var doc = await FirebaseFirestore.instance.collection('eventos').doc(idGerado).get();
    if (!doc.exists) {
      existe = false;
      return idGerado;
    }
    index++;
  }
  return "ERRO";
}
}
