import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future _getData() async {
    try {
      var response = await http.get(
        Uri.parse(
          "https://api.thecatapi.com/v1/breeds",
        ),
      );
      List data = jsonDecode(response.body);
      for (var element in data) {
        cats.add(Cat.fromJson(element));
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
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                    title: Text(cats[index].name),
                    subtitle: Text(
                      cats[index].description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
