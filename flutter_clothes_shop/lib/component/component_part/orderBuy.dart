import 'package:flutter/material.dart';


class orderBuy extends StatefulWidget {
  const orderBuy({super.key});
  
  @override
  State<orderBuy> createState() => _orderBuyState();
}

class _orderBuyState extends State<orderBuy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order Buy'),
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
                            child: Text('Status : Padding'),
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