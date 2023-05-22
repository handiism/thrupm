import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thrupm/utils/logger.dart';
import '../model/cat.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Cat> cats = [];
  bool _isFavorite = false;
  bool _filtered = false;

  Future _getData() async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://api.thecatapi.com/v1/breeds",
        ),
      );
      List data = jsonDecode(response.body);

      cats.clear();
      for (var element in data) {
        cats.add(Cat.fromJson(element));
      }

      if (_filtered) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int id = prefs.getInt("id") ?? 0;

        final dbPath = join(await getDatabasesPath(), "cats.db");
        final db = await openDatabase(dbPath);
        var rows = await db.rawQuery(
          "SELECT * FROM favorites WHERE userId = ?",
          [id],
        );
        final names = rows.map((e) => e['name'].toString()).toList();
        cats = cats.where((e) => names.contains(e.name)).toList();
      }

      logger.d(cats.length);
    } catch (e) {
      logger.d(e);
      logger.d('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_filtered ? "Kucing Favorit" : "Kucing"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _filtered = !_filtered;
              });
            },
            icon: Icon(_filtered ? Icons.filter_alt : Icons.filter_alt_off),
          )
        ],
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Image.network(
                          "https://cdn2.thecatapi.com/images/${cats[index].referenceImageId}.jpg"),
                    ),
                    title: Text(cats[index].name),
                    subtitle: Text(
                      cats[index].description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int id = prefs.getInt("id") ?? 0;

                    final dbPath = join(await getDatabasesPath(), "cats.db");
                    final db = await openDatabase(dbPath);
                    var rows = await db.rawQuery(
                      "SELECT * FROM favorites WHERE name = ? AND userId = ?",
                      [cats[index].name, id],
                    );
                    setState(() {
                      _isFavorite = rows.isNotEmpty;
                    });

                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(cats[index].name),
                              actions: [
                                IconButton(
                                  onPressed: () async {
                                    if (_isFavorite) {
                                      await db.delete(
                                        "favorites",
                                        where: 'name = ? AND userId = ?',
                                        whereArgs: [cats[index].name, id],
                                      );

                                      setState(() {
                                        _isFavorite = false;
                                      });
                                    } else {
                                      await db.insert("favorites", {
                                        'name': cats[index].name,
                                        'userId': id
                                      });

                                      setState(() {
                                        _isFavorite = true;
                                      });
                                    }
                                  },
                                  icon: Icon(_isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                )
                              ],
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Divider(
                                      color: Colors.transparent,
                                      height: 5,
                                    ),
                                    Image.network(
                                        "https://cdn2.thecatapi.com/images/${cats[index].referenceImageId}.jpg"),
                                    const Divider(
                                      color: Colors.transparent,
                                      height: 5,
                                    ),
                                    Text(
                                      cats[index].description,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Icon(
                  Icons.signal_cellular_connected_no_internet_0_bar,
                ),
              ),
              Center(child: Text("Tidak Ada Koneksi Internet"))
            ],
          );
        },
      ),
    );
  }
}
