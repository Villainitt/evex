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
    final inscricaoRef = FirebaseFirestore.instance.collection('inscricoes').doc(docId);
    final canceladasRef = FirebaseFirestore.instance.collection('canceladas').doc(docId);

    final docSnapshot = await inscricaoRef.get();

    if (!docSnapshot.exists) {
      mostrarMensagem("Inscrição não encontrada", Colors.red);
      return;
    }

    final dados = docSnapshot.data() ?? {};

    dados['status'] = 'cancelado';
    dados['cancelado_em'] = FieldValue.serverTimestamp();

    
    await canceladasRef.set(dados);

    
    await inscricaoRef.delete();

    await cancelarNotificacaoEvento(eventoId);

    mostrarMensagem("Inscrição cancelada com sucesso", Colors.green);
  } catch (e) {
    mostrarMensagem("Erro ao cancelar inscrição $e", Colors.red);
  }
}
