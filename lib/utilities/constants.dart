import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final usersRef = _db.collection('users');
final chatsRef = _db.collection('chats');

final FirebaseStorage _storage = FirebaseStorage.instance;
final storageRef = _storage.ref();

final DateFormat timeFormat = DateFormat('E, h:mm a');

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
