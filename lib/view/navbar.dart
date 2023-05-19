import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrupm/view/favorite.dart';
import 'package:thrupm/view/home.dart';
import 'package:thrupm/view/login.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = const [Home(), Favorite(), Login()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _container[_bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) async {
          if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));

            SharedPreferences prefs = await SharedPreferences.getInstance();

            await prefs.remove("id");
          }
          setState(() {
            _bottomNavCurrentIndex = index;
          });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
            ),
            icon: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.assignment,
            ),
            icon: Icon(
              Icons.assignment,
              color: Colors.grey,
            ),
            label: "Bantuan",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.exit_to_app,
            ),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            label: "Keluar",
          )
        ],
      ),
    );
  }
}
