import 'package:geolocator/geolocator.dart';

class GepasController {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';

  GepasController() {
    getPosicao();
  }

  
  getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
    } catch (e) {
      erro = e.toString();
    }
  }

  
  Future<Position> _posicaoAtual() async {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error("Por favor, habilite a localização no smartphone");
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        return Future.error("Você precisa autorizar o acesso à localização!");
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error("Você precisa autorizar o acesso à localização!");
    }

    return await Geolocator.getCurrentPosition();
  }

  
  Future<Map<String, double>> getLatitudeLongitude() async {
    if (lat != 0.0 && long != 0.0) {
      return {'latitude': lat, 'longitude': long};
    }
    return Future.error('Erro ao obter a localização.');
  }
}
