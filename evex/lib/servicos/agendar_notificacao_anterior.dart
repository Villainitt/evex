import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:evex/main.dart'; 

//Esta função agenda a notificação do evento no dia anterior à ele, ou se o usuário tiver feito a inscrição no mesmo dia
// do evento ela é acionada imediatamente!

Future<void> agendarNotificacaoDiaAnterior({
  //id = id da notificação
  // titulo = o titulo da notificação
  // corpo = conteúdo da notificação
  //dataEvento = data e hora do evento
  required String id,
  required String titulo,
  required String corpo,
  required DateTime dataEvento,
}) async {
  // esse cancelAll serve para cancela todas as notificações, para evitar duplicações.
  await flutterLocalNotificationsPlugin.cancelAll();
  //pega o horário de agora
  final agora = DateTime.now();
  //calcula a data da notificação (1 dia antes)
final dataNotificacao = dataEvento.subtract(const Duration(days: 1));
//verifica se o período de 1 dia até o evento já passou e caso seja verdadeiro ela manda a notificação instantâneamente
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
  //aqui, se ainda estiver faltando 1 dia, ele agenda a notificação para 1 dia antes 
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
