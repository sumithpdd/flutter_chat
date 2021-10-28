import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? id;
  final String? name;
  final String? email;
  final String? token;

  AppUser({
    this.id,
    this.name,
    this.email,
    this.token,
  });

  factory AppUser.fromDoc(DocumentSnapshot doc) {
    return AppUser(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      token: doc['token'],
    );
  }
}
