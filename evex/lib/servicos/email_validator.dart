import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'snack_bar.dart';

//acessa a API para verificar o email
class EmailValidator {
  static Future<bool> verificarEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      //API pega o email inserido e retorna código 200 se estiver no domínio
      final response = await http.post(
        Uri.parse('https://email-api-v80f.onrender.com/identificarUsuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) return true;

      final msg = jsonDecode(response.body)['error'] ?? 'Erro ao verificar e-mail';
      showSnackBar(context: context, aviso: msg);
      return false;
    } catch (e) {
      showSnackBar(context: context, aviso: 'Erro de conexão com a API');
      return false;
    }
  }
}
