import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat/models/user_data.dart';
import 'package:flutter_chat/screens/home_screen.dart';
import 'package:flutter_chat/screens/login_screen.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/database_service.dart';
import 'package:flutter_chat/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: Provider.of<AuthService>(context, listen: false).user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Provider.of<UserData>(context, listen: false).currentUserId =
                snapshot.data.uid;
            return const HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
