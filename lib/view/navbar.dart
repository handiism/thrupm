import 'package:flutter/material.dart';
import 'package:thrupm/view/profile.dart';
import 'package:thrupm/view/home.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _bottomNavCurrentIndex = 0;
  final List<Widget> _container = const [Home(), Group()];

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
            ),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.person,
            ),
            icon: Icon(
              Icons.person,
            ),
            label: "Kelompok",
          )
        ],
      ),
    );
  }
}
