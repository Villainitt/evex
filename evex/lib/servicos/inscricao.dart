import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> inscreverAluno(String eventoId, String matricula, String nome) async {
  String docId = 'inscricao_${eventoId}_$matricula';

  final canceladasRef = FirebaseFirestore.instance.collection('canceladas').doc(docId); //acessa a coleção 'canceladas'
  final inscricoesRef = FirebaseFirestore.instance.collection('inscricoes').doc(docId); //acessa a coleção 'inscricoes'

  
  final canceladaSnapshot = await canceladasRef.get(); //verifica se a inscrição consultada está na coleção 'canceldas'
  if (canceladaSnapshot.exists) { //se a inscrição estiver na coleção 'canceladas' ele deleta para poder adcionar à 'inscricoes'
    await canceladasRef.delete();
  }

  
  await inscricoesRef.set({ //inscreve o aluno e adiciona a inscricao em 'inscricoes'
    'eventoId': eventoId,
    'matricula': matricula,
    'nome': nome,
    'status': 'confirmado',
    'inscrito_em': FieldValue.serverTimestamp(),
  });
}
