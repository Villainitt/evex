import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> obterStatusEvento(String eventoId, Map<String, dynamic> dadosEvento) async {
  final capacidade = int.tryParse(dadosEvento['capacidade']?.toString() ?? '0') ?? 0; // acessa a capacidade do evento
  final inscricoesSnapshot = await FirebaseFirestore.instance //acessa as inscrições no evento consultado
      .collection('inscricoes')
      .where('eventoId', isEqualTo: eventoId)
      .get();

  final inscricoes = inscricoesSnapshot.docs.length; //pega a quantidade de inscrições

  final String dataStr = dadosEvento['data'];
  final String horaStr = dadosEvento['horario'];
  final DateTime dataEvento = DateFormat("dd/MM/yyyy HH:mm").parse('$dataStr $horaStr'); //formata a data e horário

  final agora = DateTime.now();
  final bool encerrado = agora.isAfter(dataEvento); //se a data e horário atual for maior que a data e horário do evento, encerra o evento
  final bool abertas = dadosEvento['inscricoes_abertas'] ?? true; //verifica se as inscrições do evento estão abertas

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
