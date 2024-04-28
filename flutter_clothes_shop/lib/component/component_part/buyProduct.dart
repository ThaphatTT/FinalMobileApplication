import 'package:flutter/material.dart';


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
                    Container(
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