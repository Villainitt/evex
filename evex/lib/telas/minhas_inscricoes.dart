import 'package:flutter/material.dart';

import 'package:evex/servicos/buscar_eventos_inscritos.dart';
import 'package:evex/servicos/pegar_matricula.dart';
import 'package:evex/servicos/cancelar_inscricao.dart';
import 'package:evex/components/card_eventos.dart';

class MinhasInscricoes extends StatefulWidget {
  const MinhasInscricoes({super.key});

  @override
  State<MinhasInscricoes> createState() => _MinhasInscricoesState();
}

class _MinhasInscricoesState extends State<MinhasInscricoes> {
  late Future<List<Map<String, dynamic>>> _eventosInscritos;
  String? matricula;

  //inicia o carregamento dos eventos
  @override
  void initState() {
    super.initState();
    _eventosInscritos = carregarEventos();
  }
  //busca os eventos que a matrícula logada está inscrita
  Future<List<Map<String, dynamic>>> carregarEventos() async {
    matricula = await pegarMatricula();
    return await buscarEventosInscritos(matricula!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus eventos", 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventosInscritos,
        builder: (context, snapshot) {
          //inidicador de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) { //verificação de erro ao carregar os eventos
            return const Center(child: Text("Erro ao carregar seus eventos"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) { //se estiver vazio mostra mensagem
            return const Center(child: Text("Nenhum evento encontrado"));
          }
          // mostra os eventos inscritos
          final eventos = snapshot.data!;

          //faz uma lista dos eventos inscritos
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return CardEvento(
                //chama o card evento com o botão de cancelar inscrição
                nome: evento['nome'] ?? 'Sem nome',
                local: evento['local'] ?? 'Sem local',
                data: evento['data'] ?? 'Sem data',
                dadosEvento: evento,
                botaoCancelar: () => cancelarInscricao(
                  context: context, 
                  eventoId: evento['id'], 
                  matricula: matricula!
                )
              );
            },
          );
        },
      ),
    );
  }
}
