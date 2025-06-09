import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:evex/servicos/autenticacao_serv.dart';
import 'package:evex/servicos/snack_bar.dart';
import 'package:evex/telas/login_page.dart';




class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  //controllers pra nome, email e senha
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //função para cadastrar o usuário
  void _signUp() async{
    //valida o formulário
    if (_formKey.currentState!.validate()) {
      String nome = _nomeController.text;
      String email = _emailController.text;
      String password = _passwordController.text;



      print('Nome: $nome,Email: $email, Senha: $password');
      //cadastra o usuário
      _autenticacaoServ.cadastrarUser(nome: nome, email: email, password: password).then(
        //se tiver erro mostra uma snackbar com o erro
        (String? erro){
          if (erro != null) {
            showSnackBar(context: context, aviso: erro);
          } 
        });
    }
  }

  AutenticacaoServ _autenticacaoServ = AutenticacaoServ();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCB500),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TOPO AMARELO
            Container(
              height: 350,
               width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/branco.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  )
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
                        "Registre-se",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFCB500),
                        ),                      
                      ),
                    ],
                  ),
                ),  
              ),
            ),
            
            SizedBox(height: 10),
            
            // formulário de registro
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //NOME
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        prefixIcon: Padding (
                          padding: EdgeInsets.only(left: 20, right: 5),
                          child: Icon(Icons.person_outlined),
                        ), 
                        labelText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira seu nome";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    
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
                        fillColor: Colors.white,
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
                        fillColor: Colors.white,
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
                    
                    SizedBox(height: 20),
                    
                    // BOTÃO REGISTRAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        //chama a função de cadastro
                        onPressed: _signUp,
                        child: Text(
                          "Registrar",
                          style: TextStyle(fontSize: 18, color: Color(0xFFFCB500)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // voltar ao login
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Já tem uma conta? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage())
                                );
                              }
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