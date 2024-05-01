import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/tabMenuHomeAppBar.dart';
import 'package:flutter_clothes_shop/component/profile_screen.dart';
import 'package:flutter_clothes_shop/component/component_part/createProduct.dart';
import 'package:flutter_clothes_shop/component/component_part/profile_detail.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  bool _isAdmin = false;
  String _textLogin = 'Login';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

 void onLoginSuccess() async {
    setState(() {
      _isLoggedIn = true;
      _selectedIndex = 1;
      _textLogin = 'Profile';
    });
    _isAdmin = await isAdmin();
  }

  void onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    setState(() {
      _isLoggedIn = false;
      _isAdmin = false;
      _selectedIndex = 1;
      _textLogin = 'Login';
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
      floatingActionButton : _isAdmin ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const createProductScreen())
          );
        },
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: _textLogin,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
      ),
    );
  }
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
    return false;
    }
    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'];
    final response = await http.get(
    Uri.parse('http://10.0.2.2:4000/user/permission/$userId'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final user = responseBody['user'];
      final role = user['permission'];
      if(role == 1) {
        return true;
      }else{
        return false;
      }
    } else {
      print('server status non-respone');
      return false;
    }
  }

}
