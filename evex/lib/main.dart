
import 'package:evex/servicos/verificar_tipo.dart';
import 'package:evex/telas/login_page.dart';
import 'package:evex/servicos/permissao_notificacao.dart';

import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones();
  //não tem o identificador brasilia então é usado o de são paulo mesmo
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

  const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('ic_notificacao');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);



  //cria o canal de notificação manualmente, para ter >>>>>CERTEZA<<<<< que vai chegar notificação 
  const AndroidNotificationChannel canalEventos = AndroidNotificationChannel(
    'canal_eventos', 
    'Notificações de Eventos', 
    description: 'Canal para notificações agendadas de eventos',
    importance: Importance.max,
  );

    await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(canalEventos);

  await pedirPermissaoNotificacao();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
        colorSchemeSeed: Color(0xFFFCB500),
      ),
      debugShowCheckedModeBanner: false,
      home: Rotas(),
    );
  }
}

class Rotas extends StatelessWidget {
  const Rotas({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return VerificaTipoPage();
        }
        return LoginPage();
      }
    );
  }
}

