import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evex/telas/professor/perfil_professor.dart';
import 'package:evex/telas/professor/tela_professor.dart';
import 'package:evex/servicos/verificar_id_evento.dart';

class CadastrarEventoScreen extends StatefulWidget {
  final int paginaAtual;

  const CadastrarEventoScreen({Key? key, this.paginaAtual = 3}) : super(key: key);

  @override
  _CadastrarEventoScreenState createState() => _CadastrarEventoScreenState();
}

class _CadastrarEventoScreenState extends State<CadastrarEventoScreen> {
  void _navegar(int index) {
  if (index == widget.paginaAtual) return;

  Widget proximaTela;
  switch (index) {
    case 0:
      proximaTela = TelaProfessor(paginaAtual: 0);
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


  final TextEditingController nomeController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController ministranteController = TextEditingController();
  final TextEditingController capacidadeController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController modalidadeController = TextEditingController();
  final TextEditingController salaController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? dataSelecionada;
  TimeOfDay? horarioSelecionado;

  Future<void> cadastrarEvento() async {
    if (nomeController.text.isEmpty ||
        dataSelecionada == null ||
        localController.text.isEmpty ||
        horarioSelecionado == null ||
        descricaoController.text.isEmpty ||
        ministranteController.text.isEmpty ||
        capacidadeController.text.isEmpty ||
        tipoController.text.isEmpty ||
        modalidadeController.text.isEmpty ||
        salaController.text.isEmpty) {
      mostrarMensagem("Preencha todos os campos!", Colors.red);
      return;
    }

    try {
      String idEvento = await VerificarIdEvento.gerarIdUnico();

      await firestore.collection("eventos").doc(idEvento).set({
        "id": idEvento, 
        "nome": nomeController.text,
        "data": "${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year}",
        "local": localController.text,
        "horario": "${horarioSelecionado!.hour.toString().padLeft(2, '0')}:${horarioSelecionado!.minute.toString().padLeft(2, '0')}",
        "descricao": descricaoController.text,
        "ministrante": ministranteController.text,
        "capacidade": capacidadeController.text,
        "tipo": tipoController.text,
        "sala": salaController.text,
        "modalidade": modalidadeController.text,
        "criado_em": FieldValue.serverTimestamp(),
      });


      mostrarMensagem("Evento cadastrado com sucesso!", Colors.green);

      // Limpar campos
      nomeController.clear();
      localController.clear();
      descricaoController.clear();
      ministranteController.clear();
      capacidadeController.clear();
      tipoController.clear();
      modalidadeController.clear();
      salaController.clear();
      setState(() {
        dataSelecionada = null;
        horarioSelecionado = null;
      });
    } catch (e) {
      mostrarMensagem("Erro ao cadastrar evento! $e", Colors.red);
      
    }
  }

  void mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          "Cadastro de eventos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFCB500),
        foregroundColor: const Color(0xFFFAFAFA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( 
          child: Column(
            children: [
              campoDeTexto(nomeController, "Nome do Evento"),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  dataSelecionada != null
                      ? "${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year}"
                      : "Selecionar Data",
                ),
                onTap: () async {
                  final data = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (data != null) {
                    setState(() => dataSelecionada = data);
                  }
                },
              ),
              const SizedBox(height: 15),
              campoDeTexto(localController, "Local"),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  horarioSelecionado != null
                      ? "${horarioSelecionado!.hour.toString().padLeft(2, '0')}:${horarioSelecionado!.minute.toString().padLeft(2, '0')}"
                      : "Selecionar Horário",
                ),
                onTap: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (hora != null) {
                    setState(() => horarioSelecionado = hora);
                  }
                },
              ),
              const SizedBox(height: 15),
              campoDeTexto(descricaoController, "Descrição"),
              const SizedBox(height: 15),
              campoDeTexto(ministranteController, "Palestrante"),
              const SizedBox(height: 20),
              campoDeTexto(capacidadeController, "Capacidade"),
              const SizedBox(height: 20),
              campoDeTexto(tipoController, "Tipo (palestra, oficina...)"),
              const SizedBox(height: 20),
              campoDeTexto(modalidadeController, "Modalidade (presencial ou online)"),
              const SizedBox(height: 20),
              campoDeTexto(salaController, "Sala"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: cadastrarEvento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  foregroundColor: const Color(0xFFFAFAFA),
                  minimumSize: Size(200, 50),
                ),
                child: const Text("Cadastrar", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.paginaAtual,
        onTap: _navegar,
        selectedItemColor: const Color(0xFFFCB500),
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
            label: 'Criar Evento',
          )
        ],
      ),
    );
  }


  Widget campoDeTexto(TextEditingController controller, String label, {TextInputType tipo = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
