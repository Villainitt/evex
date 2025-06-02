import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:evex/main.dart'; 

Future<void> agendarNotificacaoDiaAnterior({
  required String id,
  required String titulo,
  required String corpo,
  required DateTime dataEvento,
}) async {
  await flutterLocalNotificationsPlugin.cancelAll();
  final agora = DateTime.now();
final dataNotificacao = dataEvento.subtract(const Duration(days: 1));

if (dataNotificacao.isBefore(agora)) {
  await flutterLocalNotificationsPlugin.show(
    id.hashCode,
    titulo,
    corpo,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_eventos',
        'Notificações de Eventos',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_notificacao',
      ),
    ),
  );
  print('Notificação disparada imediatamente!');
} else {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id.hashCode,
    titulo,
    corpo,
    tz.TZDateTime.from(dataNotificacao, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_eventos',
        'Notificações de Eventos',
        importance: Importance.max,
        priority: Priority.high,
        icon: 'ic_notificacao',
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
  print('Notificação agendada para: $dataNotificacao');
}

}
