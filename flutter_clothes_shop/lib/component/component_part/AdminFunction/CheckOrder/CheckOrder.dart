import 'package:flutter/material.dart';

class CheckOrder extends StatefulWidget {
  const CheckOrder({super.key});

  @override
  State<CheckOrder> createState() => _CheckOrderState();
}

class _CheckOrderState extends State<CheckOrder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, 
      child: Scaffold(
      appBar: AppBar(
        title : Text('Check Order'),
        bottom: const TabBar(
          tabs: [
            Text('PADDING'),
            Text('REJECTED'),
            Text('RESOLVED'),
            Text('ACCEPTED'),
          ],
      ),
      ),
      body: TabBarView(
        children: [
          Text('Yooo'),
          Text('Yooo'),
          Text('Yooo'),
          Text('Yooo'),
          ],
        ),
      )
    );
  }
}