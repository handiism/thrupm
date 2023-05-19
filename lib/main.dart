import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thrupm/view/home.dart';
import 'package:thrupm/view/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool exist = prefs.containsKey("id");

  runApp(MyApp(
    exist: exist,
  ));

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

class MyApp extends StatelessWidget {
  final bool exist;

  const MyApp({super.key, required this.exist});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THRUPM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: exist ? const Home() : const NavBar(),
    );
  }
}
