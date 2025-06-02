import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:evex/servicos/gps.dart';
import 'package:evex/servicos/snack_bar.dart';

//essa função pega o local do evento e depois tenta abrir o maps

Future<void> abrirLocalNoMaps(BuildContext context, String local) async {
  try {
    GepasController gepasController = GepasController();
    await gepasController.getPosicao();
    Map<String, double> posicao = await gepasController.getLatitudeLongitude();

    final url = 'https://www.google.com/maps/dir/?api=1&origin=${posicao['latitude']},${posicao['longitude']}&destination=${Uri.encodeComponent(local)}';
    final uri = Uri.parse(url);

    //aqui ele tenta abrir direto o app do maps    
    final podeAbrir = await launchUrl(uri, mode: LaunchMode.externalApplication);

    //se não abrir (por motivos de erro ou o usuário não tem o maps instalado), ele abre diretamente no navegador e da tudo certo uhul
    if (!podeAbrir) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
      showSnackBar(context: context, aviso: "Abrindo no navegador por segurança.", isErro: false);
    }
  } catch (e) {
    showSnackBar(context: context, aviso: 'Erro ao abrir o Maps: $e', isErro: true);
  }
}
