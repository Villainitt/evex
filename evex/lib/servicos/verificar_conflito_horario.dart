import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> temConflitoDeHorario (String matricula, String dataNovoEvento, String horarioNovoEvento) async {
  final fb = await FirebaseFirestore.instance;

  try {
    //pega as inscrições da matricula logada
    final inscricoesSnapshot = await fb
      .collection('inscricoes')
      .where('matricula', isEqualTo: matricula)
      .get();

    for (var doc in inscricoesSnapshot.docs) {
      final inscricao = doc.data();
      final eventoIdInscrito = inscricao['eventoId'];

      //pega os dados do evento
      final eventoDoc = await fb.collection('eventos').doc(eventoIdInscrito).get();

      if (!eventoDoc.exists) continue;

      final dadosEvento = eventoDoc.data()!;
      final dataEvento = dadosEvento['data'];
      final horarioEvento = dadosEvento['horario'];

      //conflito de horário
      if (dataEvento == dataNovoEvento && horarioEvento == horarioNovoEvento) {
        return true; 
      }      
    }
    //se retornar falso, não tem conflito, então o verificador tentarInscricao segue
    return false;
  } catch (e) {
    print ('Erro ao verificar conflito de horário $e');
    return false;
  }

}