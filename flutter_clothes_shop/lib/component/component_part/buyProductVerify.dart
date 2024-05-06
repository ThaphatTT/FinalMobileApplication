import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/component_part/verifyPayment.dart';
class buyProductVerify extends StatefulWidget {
  final id;
  const buyProductVerify({super.key, required this.id});

  @override
  State<buyProductVerify> createState() => _buyProductVerifyState();
}

class _buyProductVerifyState extends State<buyProductVerify> {
  Map<String, dynamic>? _product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy'),
      ),
      body: Column(
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
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                            child: Text(
                              'name clothes',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            child: Text(
                              'brand name',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Size',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'US 10W',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Condition',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Brand New',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Equipment',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Box',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '1000',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Product Images',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Photos',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                      width: double.infinity,
                      child: Text(
                        'Shipping Address',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                        ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                      width: double.infinity,
                      child: Text(
                        'Your Address',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                        ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                      width: double.infinity,
                      child: Text(
                        'Shipping Method',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                        ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                        'Standard Delivery',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                          '100',
                          style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey,
                                  ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 35),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                      width: double.infinity,
                      child: Text(
                        'Payment',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                        ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.view_column),
                                Text(
                                  'Payment Method',
                                  style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey,
                                          ),
                                    ),
                                    ],
                                  ),
                          ),
                          Text(
                          'Bank Transfer',
                          style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey,
                                  ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 15),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '1000',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Shipping',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '100',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '1100',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.5)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> verifyPayment())
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                      child: RichText(
                      text: TextSpan(
                          text: 'Continue to payment  ',
                          style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                          children: const <TextSpan>[
                            TextSpan(
                              text:'1000', 
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
              ),
              ),
            ],
          )
    );
  }
}