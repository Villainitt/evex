import 'package:geolocator/geolocator.dart';
//acessa a localização do usuário
class GepasController {
  double lat = 0.0;
  double long = 0.0;
  String erro = '';

  GepasController() {
    getPosicao();
  }

  //pega a posição do usuário
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
    LocationPermission permissao; //verifica se tem permissão

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error("Por favor, habilite a localização no smartphone"); //pede para habilitar a localização do telefone
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission(); //se estiver negada abre novamente a permissão de localização

      if (permissao == LocationPermission.denied) {
        return Future.error("Você precisa autorizar o acesso à localização!");
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error("Você precisa autorizar o acesso à localização!");
    }

    return await Geolocator.getCurrentPosition();  //se a permissão estiver ok, pega a posição do usuário
  }

  
  Future<Map<String, double>> getLatitudeLongitude() async {
    if (lat != 0.0 && long != 0.0) {
      return {'latitude': lat, 'longitude': long};
    }
    return Future.error('Erro ao obter a localização.');
  }
}
