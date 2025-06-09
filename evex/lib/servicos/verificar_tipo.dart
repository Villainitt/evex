import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:evex/telas/tela_inicial.dart';
import 'package:evex/telas/professor/tela_professor.dart';
import 'package:evex/servicos/snack_bar.dart';

class VerificaTipoPage extends StatefulWidget {
  @override
  _VerificaTipoPageState createState() => _VerificaTipoPageState();
}

class _VerificaTipoPageState extends State<VerificaTipoPage> {
  //inicia a verificação de tipo
  @override
  void initState() {
    super.initState();
    _verificarTipo();
  }

  //função para verificar tipo de usuário (professor ou aluno)
  void _verificarTipo() async {
    final user = FirebaseAuth.instance.currentUser;
    //verifica se o usuário está autenticado 
    if (user == null || user.email == null) {
      if (mounted) {
        showSnackBar(
          context: context,
          aviso: 'Usuário não autenticado ou sem email.',
        );
      }
      return;
    }
    //retorna o email autenticado
    final email = user.email;

    //consome a api para verificar o tipo de usuário de acordo com o email
    try {
      final uri = Uri.parse(
        'https://email-api-v80f.onrender.com/identificarUsuario',
      );
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      // se a verificação for ok (código 200) retorna o tipo
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tipo = data['tipo'];

        //se o tipo for 'aluno' vai para a tela de aluno
        if (tipo == 'aluno') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => InicialTela(paginaAtual: 0)),
          );
        // se o tipo for 'admin' vai para a tela de professor   
        } else if (tipo == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TelaProfessor(paginaAtual: 0)),
          );
        } else {
          //se, por algum acaso, tiver outro tipo, ele apresenta mensagem de usuário desconhecido
          showSnackBar(
            context: context,
            aviso: 'Tipo de usuário desconhecido.',
          );
        }
      } else {
        //mensagem de erro
        showSnackBar(context: context, aviso: 'Erro ao identificar usuário.');
      }
    } catch (e) {
      if (mounted) {
        //erro de conexão
        showSnackBar(
          context: context,
          aviso: 'Erro na comunicação com o servidor.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
