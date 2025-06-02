import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> pegarMatricula() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || user.email == null) return null;

  final emailUsuario = user.email!;

  final querySnapshot = await FirebaseFirestore.instance
      .collection('alunos')
      .where('email', isEqualTo: emailUsuario)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    final matricula = querySnapshot.docs.first.id; 
    return matricula;
  }

  return null; 
}
