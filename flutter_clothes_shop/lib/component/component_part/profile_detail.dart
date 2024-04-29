import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/component_part/edit_profileDetail.dart';
import 'package:flutter_clothes_shop/component/component_part/edit_ShippingAddress.dart';
import 'package:flutter_clothes_shop/component/component_part/orderBuy.dart';
import 'package:flutter_clothes_shop/component/component_part/orderSell.dart';

import 'package:shared_preferences/shared_preferences.dart';

class profileDetail extends StatefulWidget {
  final Function onLogout;

  const profileDetail({super.key, required this.onLogout});

  @override
  State<profileDetail> createState() => _profileDetailState();
}

class _profileDetailState extends State<profileDetail> {
  bool _PDisVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Detail'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(500)),
                    color: Colors.amber,
                    boxShadow: [
                      BoxShadow(color: Colors.green, spreadRadius: 1),
                    ],
                  ),
                  alignment: Alignment.center,
                  width: 120,
                  height: 120,
                  child: Image.asset('assets/images/coat_hanger.png',width: 100,height: 100,),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      'Thaphat Meechaitana',
                      style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black
                            ),
                      ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Email :  ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey
                            ),
                            children: const <TextSpan>[
                              TextSpan(text: 
                              'sumoasdasd@gmail.com', 
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                )
                                ),
                            ],
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: RichText(
                          text: TextSpan(
                            text: 'Birthday :  ',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey
                            ),
                            children: const <TextSpan>[
                              TextSpan(text: 
                              '2001-01-01', 
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                )
                                ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                  )
              ],
            ),
            Divider(
                    height: 10,
                    thickness: 1,
                    color: Colors.black,
                    indent: 1,
                    endIndent: 1,
                  ),
            Container(
              child: Material(
              color: Colors.grey[300],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => editProfileDetail())
                    );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.person_4)
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 5),
                        child: Text('Profile Detail')
                      )
                    ],
                  )
                ),
              ),
            ),
            ),
            Container(
              child: Material(
              color: Colors.grey[300],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => orderBuy())
                    );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.attach_money_outlined)
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text('Buying')
                      )
                    ],
                  )
                ),
              ),
            ),
            ),
            Container(
              child: Material(
              color: Colors.grey[300],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => orderSell())
                    );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.sell_outlined)
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text('Selling')
                      )
                    ],
                  )
                ),
              ),
            ),
            ),
            Container(
              child: Material(
              color: Colors.grey[300],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => editShipping())
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.location_on_outlined)
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text('Shipping Address')
                      )
                    ],
                  )
                ),
              ),
            ),
            ),
            Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Material(
            color: Colors.red[700],
            borderRadius: BorderRadius.all(Radius.circular(5.5)),
            child: InkWell(
              onTap: () {
                widget.onLogout();
              },
              child: Container(
                width: 150,
                height: 50,
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                    )
                    ),
                ),
              ),
            ),
          ),
            )
          ],
        ),
      ),
    );
  }
}