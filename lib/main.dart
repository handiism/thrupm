import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thrupm/utils/logger.dart';
import 'package:thrupm/view/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  final db = await openDatabase(
    join(await getDatabasesPath(), "catty.db"),
    onCreate: (db, version) async {
      await db.transaction(
        (tx) async {
          await tx.execute("""
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            message TEXT
          );""");

          await tx.execute("""
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            userId INTEGER NOT NULL,
            FOREIGN KEY (userId) REFERENCES users(id)
          );""");
        },
      );
    },
    version: 1,
  );

  db.close();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THRUPM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
