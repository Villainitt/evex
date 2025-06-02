import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:evex/main.dart'; 

Future<void> agendarNotificacaoEvento({
  required String id,
  required String titulo,
  required String corpo,
  required DateTime dataEvento,
}) async {
  await flutterLocalNotificationsPlugin.cancelAll();
  
  final agora = DateTime.now();
  final dataNotificacao = dataEvento.subtract(const Duration(hours: 1));

  if (dataNotificacao.isBefore(agora)) {
    await flutterLocalNotificationsPlugin.show(
      (id + "_1h").hashCode,
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
      (id + "_1h").hashCode,
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
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      
    );
    print('Notificação de 1h agendada para: $dataNotificacao');
  }
}
