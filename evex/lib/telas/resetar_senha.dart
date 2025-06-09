import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetarSenha extends StatefulWidget {
  @override
  _ResetarSenhaState createState() => _ResetarSenhaState();
}

class _ResetarSenhaState extends State<ResetarSenha> {
  final TextEditingController emailController = TextEditingController();

  void mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  //função para enviar email para resetar senha ao email digitado
  void enviarEmailReset() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      mostrarMensagem('Por favor, informe o email', Colors.red);
      return;
    }

    try {
      //envia o email de reset de senha
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      mostrarMensagem(
        'Email de recuperação enviado! Vefique sua caixa de entrada.',
        Colors.green,
      );
    } catch (e) {
      mostrarMensagem('Erro ${e.toString()}', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFCB500),
        title: Text('Resetar senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 20, right: 5),
                  child: Icon(Icons.email_outlined),
                ),
                labelText: 'Email cadastrado',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: enviarEmailReset,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFCB500),
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              child: Text(
                'Enviar email de recuperação',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
