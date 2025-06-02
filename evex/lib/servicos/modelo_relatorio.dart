import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModeloRelatorio extends StatelessWidget {
  final String eventoId;

  const ModeloRelatorio({required this.eventoId, super.key});

  Future<Map<String, List<Map<String, dynamic>>>> carregarInscricoes() async {
    final confirmadasSnapshot =
        await FirebaseFirestore.instance
            .collection('inscricoes')
            .where('eventoId', isEqualTo: eventoId)
            .get();

    final canceladasSnapshot =
        await FirebaseFirestore.instance
            .collection('canceladas')
            .where('eventoId', isEqualTo: eventoId)
            .get();

    final confirmadas =
        confirmadasSnapshot.docs.map((doc) => doc.data()).toList();
    final canceladas =
        canceladasSnapshot.docs.map((doc) => doc.data()).toList();

    return {
      'confirmado': confirmadas, 
      'cancelada': canceladas
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relatório do evento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFCB500),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: carregarInscricoes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma inscrição encontrada.'));
          }

          final data = snapshot.data!;
          final confirmados = data['confirmado'] ?? [];
          final canceladas = data['cancelada'] ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Inscrições Confirmadas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (confirmados.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Nenhuma inscrição confirmada."),
                )
              else
                ...confirmados.map((e) => ListTile(title: Text(e['nome'] ?? 'Sem nome'))),

              const SizedBox(height: 20),

              const Text(
                "Inscrições Canceladas",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (canceladas.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Nenhuma inscrição cancelada."),
                )
              else
                ...canceladas.map((e) => ListTile(title: Text(e['nome'] ?? 'Sem nome'))),
            ],
          );
        },
      ),
    );
  }
}
