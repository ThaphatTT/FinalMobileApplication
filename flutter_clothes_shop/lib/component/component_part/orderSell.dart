import 'package:flutter/material.dart';


class orderSell extends StatefulWidget {
  const orderSell({super.key});
  
  @override
  State<orderSell> createState() => _orderSellState();
}

class _orderSellState extends State<orderSell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order Sell'),
      ),
      body: SingleChildScrollView(
        child :GestureDetector( 
          onTap: () {
            
          },
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      color: Colors.green,
                      width:  120,
                      child: Image.asset('assets/images/coat_hanger.png'),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              'Tite',
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                            child: Text('Status : Wait Order Buy'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 50, 0, 0),
                      child: Text(
                        '฿ 1,500',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ))
    );
  }
}