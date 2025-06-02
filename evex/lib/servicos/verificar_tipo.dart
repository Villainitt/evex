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
  @override
  void initState() {
    super.initState();
    _verificarTipo();
  }

  void _verificarTipo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final email = user.email;

    try {
      final uri = Uri.parse('https://email-api-v80f.onrender.com/identificarUsuario');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tipo = data['tipo'];

        if (tipo == 'aluno') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InicialTela(paginaAtual: 0)));
        } else if (tipo == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TelaProfessor(paginaAtual: 0)));
        } else {
          showSnackBar(context: context, aviso: 'Tipo de usuário desconhecido.');
        }
      } else {
        showSnackBar(context: context, aviso: 'Erro ao identificar usuário.');
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context: context, aviso: 'Erro na comunicação com o servidor.');
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
