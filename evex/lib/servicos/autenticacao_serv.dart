import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:evex/servicos/verificar_tipo.dart';
import 'package:flutter/material.dart';



class AutenticacaoServ {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //método p/ cadastrar usuário
  Future<String?> cadastrarUser({
  required String nome,
  required String email,
  required String password,
}) async {
  final url = Uri.parse('https://email-api-v80f.onrender.com/cadastrarUsuario');

  try { //api verifica o domínio do email e o tipo de usuário
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'nome': nome}),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      return body['error'] ?? 'Erro ao cadastrar na API';
    }

    
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    
    await userCredential.user!.updateDisplayName(nome);

    return null; 
  } on FirebaseAuthException catch (e) {
    if (e.code == "email-already-in-use") {
      return "O usuário já está cadastrado";
    }
    return "Erro de autenticação: ${e.message}";
  } catch (e) {
    return "Erro inesperado: $e";
  }


   
  }



  Future<String?> logarUser({required String email, required String password, required BuildContext context}) async {
  try {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password); //loga o usuário

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => VerificaTipoPage()),
    );

    return null;
  } on FirebaseAuthException catch (e) {
    return e.message;
  }
}

  Future<void> deslogar() async{ //desloga o usuário
    _firebaseAuth.signOut();
    print ("Usuário deslogado");
  }

}