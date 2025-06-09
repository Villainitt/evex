import 'package:permission_handler/permission_handler.dart';
//pede ao usuário a permissão para mostrar notificação
Future<void> pedirPermissaoNotificacao() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    final result = await Permission.notification.request();
    print('Permissão notificações: $result');
  }
}