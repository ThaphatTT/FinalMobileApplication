import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/component_part/homeScreen.dart';
class TabMenuHomeAppBar extends StatelessWidget {
  const TabMenuHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
      appBar: AppBar(
        title : Image.asset(
          'assets/images/coat_hanger.png',
          fit: BoxFit.cover,
              height: 55,
              width: 55,
          ),
        bottom: const TabBar(
          tabs: [
            Text('Shop All'),
            Text('Shoes'),
            Text('Apparel'),
          ],
      ),
      ),
      body: TabBarView(
        children: [
          HomeScreen(),
          Text('Yooo'),
          Text('Yooo'),
          ],
        ),
      )
    );
  }
}