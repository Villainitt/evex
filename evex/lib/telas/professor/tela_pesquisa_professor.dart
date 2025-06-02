import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:evex/telas/professor/perfil_professor.dart';
import 'package:evex/telas/professor/tela_professor.dart';
import 'package:evex/telas/professor/cadastro_eventos.dart';

class TelaPesquisaProfessor extends StatefulWidget {
  const TelaPesquisaProfessor({Key? key, this.paginaAtual = 1}) : super(key: key);

  final int paginaAtual;

  @override
  _TelaPesquisaProfessorState createState() => _TelaPesquisaProfessorState();
}

class _TelaPesquisaProfessorState extends State<TelaPesquisaProfessor> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  String? _categoriaSelecionada;

  List<Map<String, dynamic>> resultados = [];

  void _navegar(BuildContext context, int index) {
    if (index == widget.paginaAtual) return;

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

  Future<void> pesquisarEventos() async {
    Query query = FirebaseFirestore.instance.collection('eventos');

    if (_nomeController.text.isNotEmpty) {
      query = query
          .where('nome', isGreaterThanOrEqualTo: _nomeController.text)
          .where('nome', isLessThanOrEqualTo: _nomeController.text + '\uf8ff');
    }

    if (_localController.text.isNotEmpty) {
      query = query.where('local', isEqualTo: _localController.text);
    }

    if (_categoriaSelecionada != null && _categoriaSelecionada!.isNotEmpty) {
      query = query.where('categoria', isEqualTo: _categoriaSelecionada);
    }

    final snapshot = await query.get();

    setState(() {
      resultados = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Eventos'),
        backgroundColor: const Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do evento'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _localController,
              decoration: const InputDecoration(labelText: 'Local'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              hint: const Text('Categoria'),
              items: ['Palestra', 'Oficina', 'Encontro']
                  .map((categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ))
                  .toList(),
              onChanged: (valor) {
                setState(() {
                  _categoriaSelecionada = valor;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pesquisarEventos,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: resultados.isEmpty
                  ? const Text('Nenhum resultado encontrado.')
                  : ListView.builder(
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final evento = resultados[index];
                        return ListTile(
                          title: Text(evento['nome'] ?? 'Sem nome'),
                          subtitle: Text(
                            '${evento['local'] ?? 'Local desconhecido'} - ${evento['data'] ?? ''}',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.paginaAtual,
        onTap: (index) => _navegar(context, index),
        selectedItemColor: const Color(0xFFFCB500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
