import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> buscarEventosInscritos(String matricula) async {
  final firestore = FirebaseFirestore.instance;

  
  final inscricoesSnapshot = await firestore.collection('inscricoes').get();

  final eventosIds = inscricoesSnapshot.docs
      .where((doc) => doc.id.endsWith('_$matricula'))
      .map((doc) => doc['eventoId'] as String)
      .toList();

  
  List<Map<String, dynamic>> eventos = [];
  for (String id in eventosIds) {
    final eventoSnap = await firestore.collection('eventos').doc(id).get();
    if (eventoSnap.exists) {
      eventos.add(eventoSnap.data()!..['id'] = id);
    }
  }

  return eventos;
}
