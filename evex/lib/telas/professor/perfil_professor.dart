import 'package:evex/telas/professor/cadastro_eventos.dart';
import 'package:evex/telas/professor/tela_pesquisa_professor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evex/servicos/autenticacao_serv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evex/telas/professor/tela_professor.dart';
import 'package:evex/telas/login_page.dart';
import 'package:evex/telas/minhas_inscricoes.dart';

class PerfilProfessor extends StatelessWidget {
  final int paginaAtual;

  const PerfilProfessor({Key? key, this.paginaAtual = 2}) : super(key: key);

  void _navegar(BuildContext context, int index) {
    if (index == paginaAtual) return;

    Widget proximaTela;
    switch (index) {
      case 0:
        proximaTela = TelaProfessor(paginaAtual: 0);
        break;
      case 1:
        proximaTela = TelaPesquisaProfessor(paginaAtual: 1);
        break;
      case 2:
        proximaTela = PerfilProfessor(paginaAtual: 2);
        break;
      case 3:
        proximaTela = CadastrarEventoScreen(paginaAtual: 3);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => proximaTela),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil Professor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('professores')
                .where('email', isEqualTo: user?.email)
                .limit(1)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Dados do professor não encontrados.'),
            );
          }

          final doc = snapshot.data!.docs.first;
          final dados = doc.data() as Map<String, dynamic>;
          final matricula = doc.id;
          final nome = dados['nome'] ?? 'Sem nome';
          final email = dados['email'] ?? 'Sem email';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Nome:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF838383),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Email:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF838383),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Matrícula:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFF838383),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    matricula,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MinhasInscricoes(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: const Color(0xFFFCB500),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Meus Eventos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          AutenticacaoServ().deslogar();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) => _navegar(context, index),
        selectedItemColor: const Color(0xFFFCB500),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Busca'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Criar evento',
          ),
        ],
      ),
    );
  }
}
