import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:evex/servicos/inscricao.dart';
import 'package:evex/servicos/agendar_notificacao.dart';
import 'package:evex/servicos/agendar_notificacao_anterior.dart'; 
import 'package:intl/intl.dart';

Future<bool> verificarCapacidade(
    BuildContext context, String eventoId, String matricula, String nome) async {
  
  void mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  try {
    final docEvento = await FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventoId)
        .get();

    final data = docEvento.data();
    final capacidade = int.tryParse(data?['capacidade']?.toString() ?? '0') ?? 0;

    final inscricoesSnapshot = await FirebaseFirestore.instance
        .collection('inscricoes')
        .where('eventoId', isEqualTo: eventoId)
        .get();

    if (inscricoesSnapshot.docs.length < capacidade) {
      await inscreverAluno(eventoId, matricula, nome);
      mostrarMensagem("Inscrição realizada com sucesso", Colors.green);

      
      final String dataStr = data?['data']; 
      final String horaStr = data?['horario'];        

      final DateTime dataHoraEvento = DateFormat("dd/MM/yyyy HH:mm").parse('$dataStr $horaStr');

      
      await agendarNotificacaoEvento(
        id: eventoId,
        titulo: 'Lembrete de Evento',
        corpo: 'O evento ${data?['nome']} começa em 1 hora!',
        dataEvento: dataHoraEvento,
      );

      await agendarNotificacaoDiaAnterior(
        id: eventoId, 
        titulo: 'Lembrete de Evento',
        corpo: 'O evento ${data?['nome']} é amanhã!', 
        dataEvento: dataHoraEvento,
      );

      return true;
    } else {
      mostrarMensagem("Capacidade esgotada!", Colors.red);
      return false;
    }
  } catch (e) {
    mostrarMensagem("Erro ao verificar capacidade: $e", Colors.red);
    return false;
  }
}
