import 'package:evex/telas/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:evex/servicos/snack_bar.dart';

import 'package:evex/servicos/autenticacao_serv.dart';
import 'package:evex/servicos/email_validator.dart';
import 'package:evex/telas/resetar_senha.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      bool emailValido = await EmailValidator.verificarEmail(
        context: context,
        email: email,
      );
      if (!emailValido) return;

      String? erro = await _autenticacaoServ.logarUser(
        email: email,
        password: password,
        context: context,
      );

      if (erro != null) {
        showSnackBar(context: context, aviso: erro);
      }
    }
  }

  AutenticacaoServ _autenticacaoServ = AutenticacaoServ();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOPO AMARELO
            Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/topo.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              child: Align(
                alignment: Alignment(-1.0, -0.9),
                child: Padding(
                  padding: EdgeInsets.only( left: 24, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olá!",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Bem-vindo(a) ao Evex",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            // FORMULÁRIO DE LOGIN
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // EMAIL
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Icon(Icons.email_outlined),
                        ),
                        labelText: "E-mail",
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira seu e-mail";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    // SENHA
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Icon(Icons.lock_outline),
                        ),
                        labelText: "Senha",
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira sua senha";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // ESQUECI MINHA SENHA
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetarSenha(),
                            ),
                          );
                        },
                        child: Text(
                          "Esqueci minha senha",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // BOTÃO LOGIN
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFCB500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: _login,
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // CADASTRAR
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Não tem uma conta? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Cadastrar",
                              style: TextStyle(
                                color: Color(0xFFFCB500),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUpPage(),
                                        ),
                                      );
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
