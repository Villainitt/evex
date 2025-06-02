import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:evex/telas/perfil.dart';
import 'package:evex/telas/tela_inicial.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key? key, this.paginaAtual = 1}) : super(key: key);

  final int paginaAtual;

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  String? _modalidadeSelecionada;

  List<Map<String, dynamic>> resultados = [];

  void _navegar(BuildContext context, int index) {
    if (index == widget.paginaAtual) return;

    Widget proximaTela;
    switch (index) {
      case 0:
        proximaTela = InicialTela(paginaAtual: 0);
        break;
      case 1:
        proximaTela = TelaPesquisa(paginaAtual: 1);
        break;
      case 2:
        proximaTela = Perfil(paginaAtual: 2);
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

    if (_modalidadeSelecionada != null && _modalidadeSelecionada!.isNotEmpty) {
      query = query.where('tipo', isEqualTo: _modalidadeSelecionada);
    }

    try {
      final snapshot = await query.get();

      setState(() {
        resultados =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      });
    } catch (e) {
      print("Erro ao buscar eventos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Eventos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                        labelText: "Nome do evento",
                        filled: true,
                        fillColor: Colors.grey[300],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _localController,
              decoration: InputDecoration(
                labelText: "Local",
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _modalidadeSelecionada,
              hint: const Text('Tipo'),
              items:
                  ['Palestra', 'Oficina', 'Encontro', 'Mesa Redonda']
                      .map(
                        (categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        ),
                      )
                      .toList(),
              onChanged: (valor) {
                setState(() {
                  _modalidadeSelecionada = valor;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFCB500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(200, 50),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: pesquisarEventos,
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  resultados.isEmpty
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.paginaAtual,
        onTap: (index) => _navegar(context, index),
        selectedItemColor: const Color(0xFFFCB500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
