import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/tabMenuHomeAppBar.dart';
import 'package:flutter_clothes_shop/component/profile_screen.dart';
import 'package:flutter_clothes_shop/component/component_part/createProduct.dart';
import 'package:flutter_clothes_shop/component/component_part/profile_detail.dart';

class TabMenu extends StatelessWidget {
  const TabMenu({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home : TabMenuButton(),
    );
  }
}

class TabMenuButton extends StatefulWidget {
  const TabMenuButton({super.key});

  @override
  State<TabMenuButton> createState() => _TabMenuButton();
}

class _TabMenuButton extends State<TabMenuButton> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 void onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
      _selectedIndex = 1;
    });
  }

  void onLogout() {
    setState(() {
      _isLoggedIn = false;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
   final _widgetOptions = <Widget>[
      TabMenuHomeAppBar(),
      _isLoggedIn ? profileDetail(onLogout: onLogout) : Profile_HomeScreen(onLoginSuccess: onLoginSuccess),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton : FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const createProductScreen())
          );
        },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
