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
    //acessa a coleção 'eventos' no firestore
    final docEvento = await FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventoId)
        .get();

    final data = docEvento.data();
    //pega a capacidade do evento selecionado
    final capacidade = int.tryParse(data?['capacidade']?.toString() ?? '0') ?? 0;
    //acessa as inscrições, pegando as que tem o eventoId igual ao do evento consultado
    final inscricoesSnapshot = await FirebaseFirestore.instance
        .collection('inscricoes')
        .where('eventoId', isEqualTo: eventoId)
        .get();

    if (inscricoesSnapshot.docs.length < capacidade) {//verifica se a quantidade de inscrições for menor que a capacidade
      await inscreverAluno(eventoId, matricula, nome);// inscreve o aluno
      mostrarMensagem("Inscrição realizada com sucesso", Colors.green);

      
      final String dataStr = data?['data']; //acessa a data
      final String horaStr = data?['horario']; //acessa o horário 

      final DateTime dataHoraEvento = DateFormat("dd/MM/yyyy HH:mm").parse('$dataStr $horaStr'); //formata a data e horário

      
      await agendarNotificacaoEvento( //agenda a notificação de 1h
        id: eventoId,
        titulo: 'Lembrete de Evento',
        corpo: 'O evento ${data?['nome']} começa em 1 hora!',
        dataEvento: dataHoraEvento,
      );

      await agendarNotificacaoDiaAnterior( //agenda a notificação de 1 dia
        id: eventoId, 
        titulo: 'Lembrete de Evento',
        corpo: 'O evento ${data?['nome']} é amanhã!', 
        dataEvento: dataHoraEvento,
      );

      return true;
    } else {
      mostrarMensagem("Capacidade esgotada!", Colors.red); //se a capadidade estiver cheia retorna que está cheio 
      return false;
    }
  } catch (e) { 
    mostrarMensagem("Erro ao verificar capacidade: $e", Colors.red); //erro ao verificar a capacidade
    return false;
  }
}
