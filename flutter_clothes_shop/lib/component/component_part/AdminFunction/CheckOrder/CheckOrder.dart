import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/component_part/AdminFunction/CheckOrder/OrderPadding.dart';
import 'package:flutter_clothes_shop/component/component_part/AdminFunction/CheckOrder/OrderResolved.dart';
import 'package:flutter_clothes_shop/component/component_part/AdminFunction/CheckOrder/OrderAccepted.dart';

class CheckOrder extends StatefulWidget {
  const CheckOrder({super.key});

  @override
  State<CheckOrder> createState() => _CheckOrderState();
}

class _CheckOrderState extends State<CheckOrder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
      appBar: AppBar(
        title : Text('Check Order'),
        bottom: const TabBar(
          tabs: [
            Text('PADDING'),
            Text('REJECTED'),
            Text('ACCEPTED'),
          ],
      ),
      ),
      body: TabBarView(
        children: [
          OrderPadding(),
          OrderResolved(),
          OrderAccepted(),
          ],
        ),
      )
    );
  }
}