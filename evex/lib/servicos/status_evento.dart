import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> obterStatusEvento(String eventoId, Map<String, dynamic> dadosEvento) async {
  final capacidade = int.tryParse(dadosEvento['capacidade']?.toString() ?? '0') ?? 0;
  final inscricoesSnapshot = await FirebaseFirestore.instance
      .collection('inscricoes')
      .where('eventoId', isEqualTo: eventoId)
      .get();

  final inscricoes = inscricoesSnapshot.docs.length;

  final String dataStr = dadosEvento['data'];
  final String horaStr = dadosEvento['horario'];
  final DateTime dataEvento = DateFormat("dd/MM/yyyy HH:mm").parse('$dataStr $horaStr');

  final agora = DateTime.now();
  final bool encerrado = agora.isAfter(dataEvento);
  final bool abertas = dadosEvento['inscricoes_abertas'] ?? true;

  if (encerrado) {
    return {
      "cor": Colors.grey,
      "texto": "Encerrado"
    };
  } else if (!abertas) {
    return {
      "cor": Colors.grey,
      "texto": "Inscrições encerradas"
    };
  } else if (inscricoes >= capacidade) {
    return {
      "cor": Colors.red,
      "texto": "Vagas esgotadas"
    };
  } else if (capacidade - inscricoes <= 5) {
    return {
      "cor": Colors.amber,
      "texto": "Vagas limitadas"
    };
  } else {
    return {
      "cor": Colors.green,
      "texto": "Inscrições abertas"
    };
  }
}
