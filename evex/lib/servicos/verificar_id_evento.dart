import 'package:cloud_firestore/cloud_firestore.dart';

class VerificarIdEvento {
  //gera um id nos padrões EVXX, ex: EV10
  static Future<String> gerarIdUnico() async {
  int index = 1;
  String idGerado; //armazena o id gerado
  bool existe = true; //flag para verificar se o id já existe

  while (existe) {
    //gera o id do evento
    idGerado = "EV${index.toString().padLeft(2, '0')}";
    //verifica se o id gerado já existe na coleção
    var doc = await FirebaseFirestore.instance.collection('eventos').doc(idGerado).get();
    //se o id não existe, ele pode ser retornado
    if (!doc.exists) {
      existe = false;
      return idGerado;
    }
    //incrementa o contador para o próximo id
    index++;
  }
  //se o id existe ele retorna erro
  return "ERRO";
}
}
