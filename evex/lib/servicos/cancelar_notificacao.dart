import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> cancelarNotificacaoEvento(String id) async {

  final int notificationId = id.hashCode;

  await flutterLocalNotificationsPlugin.cancel(notificationId);
}
