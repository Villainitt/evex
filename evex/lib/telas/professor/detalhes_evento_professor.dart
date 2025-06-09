import 'package:flutter/material.dart';

import 'package:evex/servicos/localizacao.dart';
import 'package:evex/servicos/tentar_inscricao.dart';

// Tela de detalhes de um evento obtidos do firestore mapeados
class DetalhesPage extends StatelessWidget {
  final Map<String, dynamic> dadosEvento;

  const DetalhesPage({Key? key, required this.dadosEvento}) : super(key: key);

  // constrói a interface de detalhes do evento
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detalhes do evento",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFCB500),
        foregroundColor: const Color(0xFFFAFAFA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 8)),
                const Icon(Icons.push_pin, color: Colors.black, size: 48.0),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dadosEvento['tipo'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Data e horário
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 8)),
                const Icon(Icons.event, color: Colors.black, size: 48.0),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data e hora:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dadosEvento['data'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dadosEvento['horario'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Local
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.black,
                    size: 48.0,
                  ),
                  onPressed:
                  //de acordo com o local do evento, abre o local no maps
                      () => abrirLocalNoMaps(context, dadosEvento['local']),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text(
                    dadosEvento['local'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text (
                    dadosEvento['sala'] ?? '',
                    style: const TextStyle(
                       fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Palestrante
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 8)),
                const Icon(Icons.mic, color: Colors.black, size: 48.0),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ministrante:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dadosEvento['ministrante'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            // Descrição
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 8)),
                const Icon(Icons.edit, color: Colors.black, size: 48.0),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dadosEvento['descricao'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Padding(padding: const EdgeInsets.only(left: 8)),
                const Icon(Icons.group, color: Colors.black, size: 48.0),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Capacidade:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      dadosEvento['capacidade'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            //botão de inscrição
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFCB500),
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    //botão que chama a função de inscrição
                    onPressed: () => tentarInscricao(context, dadosEvento),

                    child: Text(
                      'Inscrever-se',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
