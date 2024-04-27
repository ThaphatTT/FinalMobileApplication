import 'package:flutter/material.dart';


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
            Text('MEN'),
            Text('WOMEN'),
            Text('KIDS'),
          ],
      ),
      ),
      body: TabBarView(
        children: [
          Text('Yooo'),
          Text('Yooo'),
          Text('Yooo'),
          ],
        ),
      )
    );
  }
}