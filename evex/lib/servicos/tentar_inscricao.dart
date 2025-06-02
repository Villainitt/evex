import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:evex/servicos/pegar_matricula.dart';
import 'package:evex/servicos/verificar_conflito_horario.dart';
import 'package:evex/servicos/verificar_capacidade.dart';

//===! essa função faz a verificação da matrícula que está logada, chamando a verificação de conflito de horário
// e prossegue para a inscrição no evento !===

Future<void> tentarInscricao (BuildContext context, Map<String, dynamic> dadosEvento) async {
  final user = FirebaseAuth.instance.currentUser;

  void mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  if (user == null || user.email == null) {
    mostrarMensagem("Usuário não autenticado ou email inválido", Colors.red);
    return;
  }

  final nome = user.displayName ?? 'Usuário';
  final matricula = await pegarMatricula();

  if (matricula == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Matrícula não encontrada.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final eventoId = dadosEvento['id'];
  final dataEvento = dadosEvento['data'];
  final horarioEvento = dadosEvento['horario'];

  final conflito = await temConflitoDeHorario(matricula, dataEvento, horarioEvento);

  if (conflito) {
    mostrarMensagem("Você já está inscrito num evento nesse mesmo horário!", Colors.red);
    return;
  }

  await verificarCapacidade(context, eventoId, matricula, nome);
}

                      