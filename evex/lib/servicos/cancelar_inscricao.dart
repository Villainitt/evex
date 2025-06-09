import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:evex/servicos/cancelar_notificacao.dart'; 
Future<void> cancelarInscricao({
  required BuildContext context,
  required String eventoId,
  required String matricula,
}) async {
  String docId = 'inscricao_${eventoId}_$matricula';

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
    final inscricaoRef = FirebaseFirestore.instance.collection('inscricoes').doc(docId); //acessa o doc 'inscricoes'
    final canceladasRef = FirebaseFirestore.instance.collection('canceladas').doc(docId);//acessa o doc 'canceladas'

    final docSnapshot = await inscricaoRef.get(); //verifica as inscricoes

    if (!docSnapshot.exists) {
      mostrarMensagem("Inscrição não encontrada", Colors.red); // se não encontrar a inscrição retorna que não encontrou
      return;
    }

    final dados = docSnapshot.data() ?? {}; //acessa os dados da inscrição encontrada

    dados['status'] = 'cancelado'; //muda o status para cancelada
    dados['cancelado_em'] = FieldValue.serverTimestamp(); //adiciona o campo de cancelada_em

    
    await canceladasRef.set(dados); //adiciona a inscrição à coleção 'canceladas'

    // deleta a inscrição da coleção 'inscricoes'
    await inscricaoRef.delete();

    await cancelarNotificacaoEvento(eventoId); //cancela a notificação do evento

    mostrarMensagem("Inscrição cancelada com sucesso", Colors.green);
  } catch (e) {
    mostrarMensagem("Erro ao cancelar inscrição $e", Colors.red);
  }
}
