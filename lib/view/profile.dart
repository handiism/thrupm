import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrupm/model/profile.dart';
import 'package:thrupm/view/login.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Keluar"),
              )
            ],
            onSelected: (value) async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));

              SharedPreferences prefs = await SharedPreferences.getInstance();

              await prefs.remove("id");
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              ),
              const Divider(
                color: Colors.transparent,
              ),
              SizedBox(
                height: 145,
                child: ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(profiles[index].name),
                      subtitle: Text(
                        "NIM : ${profiles[index].nim} \nKelas  : ${profiles[index].plug}",
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
