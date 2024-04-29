import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/component_part/buyProductVerify.dart';

class BuyProduct extends StatefulWidget {
  const BuyProduct({super.key});
  
  @override
  State<BuyProduct> createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy a Product'),
      ),
      body: SingleChildScrollView(
        child :GestureDetector( 
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => buyProductVerify())
              );
          },
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                height: 90,
                color: Colors.amber,
                child : Row(
                  children: [
                    Container(
                      color: Colors.green,
                      width:  150,
                      child: Image.asset('assets/images/coat_hanger.png'),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              'Conditon',
                              ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                            child: Text('Stardard (3-5 days)'),
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
                )
              ),
            ],
          )
        ))
    );
  }
}