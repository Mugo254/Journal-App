import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journals_app/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Journal App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Truculenta"),
      home: const HomePage(),
    );
  }
}
