import 'package:evex/servicos/modelo_relatorio.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:evex/components/card_eventos.dart';
import 'package:evex/telas/professor/perfil_professor.dart';
import 'package:evex/telas/professor/cadastro_eventos.dart';
import 'package:evex/telas/professor/tela_pesquisa_professor.dart';

class TelaProfessor extends StatelessWidget {
  


  final int paginaAtual;

  TelaProfessor({required this.paginaAtual});

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Evex Professor', 
        style: TextStyle(
          fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('eventos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum evento encontrado."));
          }

          final eventos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              final data = evento.data() as Map<String, dynamic>;

              return CardEvento(
                nome: data['nome'] ?? 'Sem nome',
                local: data['local'] ?? 'Local não informado',
                data: data['data'] ?? 'Data não informada',
                dadosEvento: data,
                botaoRelatorio: () => ModeloRelatorio(eventoId: evento['id']),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) => _navegar(context, index),
        selectedItemColor: Color(0xFFFCB500),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Criar evento',
          )
        ],
      ),

    );
  }




}

  

