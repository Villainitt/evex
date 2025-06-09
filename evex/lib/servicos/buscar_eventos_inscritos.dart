import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> buscarEventosInscritos(String matricula) async { 
  final firestore = FirebaseFirestore.instance; 

  
  final inscricoesSnapshot = await firestore.collection('inscricoes').get(); //acessa a coleção 'inscricoes' 

  final eventosIds = inscricoesSnapshot.docs //pega as inscrições relacionadas às matrículas
      .where((doc) => doc.id.endsWith('_$matricula'))
      .map((doc) => doc['eventoId'] as String)
      .toList();

  
  List<Map<String, dynamic>> eventos = [];
  for (String id in eventosIds) { //adiciona à lista de eventos as inscrições que apresentam a matrícula logada
    final eventoSnap = await firestore.collection('eventos').doc(id).get();
    if (eventoSnap.exists) {
      eventos.add(eventoSnap.data()!..['id'] = id);
    }
  }

  return eventos;
}
