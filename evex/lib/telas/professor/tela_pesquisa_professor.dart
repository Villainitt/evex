import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:evex/telas/professor/perfil_professor.dart';
import 'package:evex/telas/professor/tela_professor.dart';
import 'package:evex/telas/professor/cadastro_eventos.dart';

// Widget para a tela de pesquisa, navegação via bottomNavigationBar
//paginaAtual: índice da página para navegação
class TelaPesquisaProfessor extends StatefulWidget {
  const TelaPesquisaProfessor({Key? key, this.paginaAtual = 1}) : super(key: key);
  final int paginaAtual;

  @override
  _TelaPesquisaProfessorState createState() => _TelaPesquisaProfessorState();
}

class _TelaPesquisaProfessorState extends State<TelaPesquisaProfessor> {
  //controllers para pesquisa nome e local
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _localController = TextEditingController();

  //pesquisa por tipos ou categorias são feitas por seleção de categoria (não são digitadas pelo usuário)
  String? _categoriaSelecionada;

  //lista de resultados
  List<Map<String, dynamic>> resultados = [];

  // função para navegação entre páginas, cada case é uma página
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
    //dependendo do que for selecionado ele redireciona para a tela correspondente
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => proximaTela),
    );
  }
  // essa função é a de pesquisa dos eventos, ela espera que o usuário digite algo para poder realizar a pesquisa
  Future<void> pesquisarEventos() async {
    //aqui instancia o banco de dados para realizar a pesquisa
    Query query = FirebaseFirestore.instance.collection('eventos');
    //pesquisa por nome
    if (_nomeController.text.isNotEmpty) {
      query = query
          .where('nome', isGreaterThanOrEqualTo: _nomeController.text)
          .where('nome', isLessThanOrEqualTo: _nomeController.text + '\uf8ff');
    }
    //pesquisa por local
    if (_localController.text.isNotEmpty) {
      query = query.where('local', isEqualTo: _localController.text);
    }
    //pesquisa por tipo 
    if (_categoriaSelecionada != null && _categoriaSelecionada!.isNotEmpty) {
      query = query.where('categoria', isEqualTo: _categoriaSelecionada);
    }
    //usa o get para pegar os resultados correspondentes à pesquisa
    final snapshot = await query.get();
    //mostra o resultado numa lista (caso tenha mais de 1 resultado)
    setState(() {
      resultados = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
  //aqui é a parte de interface mesmo  
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
            //"formulário" para seleção dos tipos
            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              hint: const Text('Categoria'),
              items: ['Palestra', 'Oficina', 'Encontro', 'Workshop']
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
            //aqui se não tiver nenhum resultado ele retorna a mensagem, se encontrar resultados retorna o nome do evento, 
            //local e data
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
      //é o "footer" usado para navegação
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.paginaAtual,
        onTap: (index) => _navegar(context, index),
        selectedItemColor: const Color(0xFFFCB500),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Criar Evento',
          ),
        ],
      ),
    );
  }
}
