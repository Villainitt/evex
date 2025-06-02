import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evex/telas/detalhes.dart';
import 'package:evex/servicos/modelo_relatorio.dart';
import 'package:evex/servicos/status_evento.dart';

class CardEvento extends StatelessWidget {
  final String nome;
  final String local;
  final String data;
  final Map<String, dynamic> dadosEvento;
  final void Function()? botaoCancelar;
  final void Function()? botaoRelatorio;

  const CardEvento({
    required this.nome,
    required this.local,
    required this.data,
    required this.dadosEvento,
    this.botaoCancelar,
    this.botaoRelatorio,
    Key? key,
  }) : super(key: key);

  bool podeCancelar() {
    try {
      final dataStr = dadosEvento['data'];
      final horaStr = dadosEvento['horario'];

      final combinado = "$dataStr $horaStr";

      final formatador = DateFormat("dd/MM/yyyy HH:mm");
      final dataEvento = formatador.parse(combinado);

      final limiteCancelamento = dataEvento.subtract(const Duration(hours: 1));
      return DateTime.now().isBefore(limiteCancelamento);
    } catch (e) {
      print("Erro ao verificar cancelamento: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool cancelamentoAtivo = podeCancelar();

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Local: $local'),
            Text('Data: $data'),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: obterStatusEvento(dadosEvento['id'], dadosEvento),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();

                final cor = snapshot.data!['cor'] as Color;
                final texto = snapshot.data!['texto'] as String;

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    texto,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetalhesPage(dadosEvento: dadosEvento),
                        ),
                      );
                    },
                    child: const Text(
                      'Detalhes',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (botaoCancelar != null) ...[
                    ElevatedButton(
                      onPressed: cancelamentoAtivo ? botaoCancelar : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            cancelamentoAtivo ? Colors.white : Colors.grey,
                        side: BorderSide(
                          color: cancelamentoAtivo ? Colors.red : Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Cancelar inscrição",
                        style: TextStyle(
                          color: cancelamentoAtivo ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  SizedBox(height: 5),
                  if (botaoRelatorio != null) ...[
                    ElevatedButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ModeloRelatorio(
                                    eventoId: dadosEvento['id'],
                                  ),
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFCB500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Ver relatório",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
