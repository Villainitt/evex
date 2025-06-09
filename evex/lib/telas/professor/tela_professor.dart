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

  //constrói a interface da tela inicial do professor com os cards dos eventos disponíveis na coleção 'eventos'
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Evex Professor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        //acessa a coleção 'eventos'
        stream: FirebaseFirestore.instance.collection('eventos').snapshots(),
        builder: (context, snapshot) {
          //mostra um indicador de carregamento ao usuário
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // caso não tenha nenhum evento cadastrado mostra a mensagem ao usuário
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum evento encontrado."));
          }
          // caso dê algum erro, retorna uma mensagem de erro ao usuário
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar eventos.'));
          }
          //pega os eventos disponíveis
          final eventos = snapshot.data!.docs;
          //retorna uma lista com os cards dos eventos contendo nome, local, data, botão de detalhes e botão de relatório
          return ListView.builder(
            //a quantidade de cards é de acordo com a quantidade de eventos na coleção
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              //constrói os cards de acordo com o index do evento. Ex: EV01 tem todos os dados do EV01
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
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
