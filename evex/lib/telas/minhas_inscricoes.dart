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

  @override
  void initState() {
    super.initState();
    _eventosInscritos = carregarEventos();
  }

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar seus eventos"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum evento encontrado"));
          }

          final eventos = snapshot.data!;

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return CardEvento(
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
