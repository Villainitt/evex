import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> inscreverAluno(String eventoId, String matricula, String nome) async {
  String docId = 'inscricao_${eventoId}_$matricula';

  final canceladasRef = FirebaseFirestore.instance.collection('canceladas').doc(docId);
  final inscricoesRef = FirebaseFirestore.instance.collection('inscricoes').doc(docId);

  
  final canceladaSnapshot = await canceladasRef.get();
  if (canceladaSnapshot.exists) {
    await canceladasRef.delete();
  }

  
  await inscricoesRef.set({
    'eventoId': eventoId,
    'matricula': matricula,
    'nome': nome,
    'status': 'confirmado',
    'inscrito_em': FieldValue.serverTimestamp(),
  });
}
