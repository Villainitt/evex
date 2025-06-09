import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// pega a matrícula do usuário logado
Future<String?> pegarMatricula() async {
  final user = FirebaseAuth.instance.currentUser;
  //se o usuário não estiver autenticado não retorna nada
  if (user == null || user.email == null) return null;
  
  //email do usuário autenticado
  final emailUsuario = user.email!;

  final querySnapshot = await FirebaseFirestore.instance //acessa a coleção 'alunos' e verifica qual dos documentos tem o email consultado
      .collection('alunos')
      .where('email', isEqualTo: emailUsuario)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) { //se achar o aluno, retorna a matrícula dele (que é o nome do documento)
    final matricula = querySnapshot.docs.first.id; 
    return matricula;
  }

  return null; 
}
