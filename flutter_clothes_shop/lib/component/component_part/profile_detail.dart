import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_clothes_shop/component/component_part/Profile_Detail/edit_profileDetail.dart';
import 'package:flutter_clothes_shop/component/component_part/Profile_Detail/edit_ShippingAddress.dart';
import 'package:flutter_clothes_shop/component/component_part/Profile_Detail/orderBuy.dart';
import 'package:flutter_clothes_shop/component/component_part/Profile_Detail/orderSell.dart';
import 'package:flutter_clothes_shop/component/component_part/AdminFunction/createNewNameBrand.dart';
import 'package:flutter_clothes_shop/component/component_part/AdminFunction/createNewSizeClothes%20copy.dart';
import 'package:flutter_clothes_shop/component/component_part/AdminFunction/createNewTypeClothes.dart';
import 'package:flutter_clothes_shop/component/component_part/AdminFunction/CheckOrder/CheckOrder.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class profileDetail extends StatefulWidget {
  final Function onLogout;

  const profileDetail({super.key, required this.onLogout});

  @override
  State<profileDetail> createState() => _profileDetailState();
}

class _profileDetailState extends State<profileDetail> {
  Map<String, dynamic>? user = null;
  bool _isAdmin = false;
  @override
  void initState() {
    super.initState();
    getUserData();
    checkAdminStatus();
  }
  void checkAdminStatus() async {
    _isAdmin = await isAdmin();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile Detail'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(500)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey, spreadRadius: 1),
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
                          user != null ? user!['fname'] + ' ' + user!['lname'] : 'null',
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
                                children: <TextSpan>[
                                  TextSpan(
                                    text:user != null ? user!['email'] : 'null', 
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
                                children: <TextSpan>[
                                  TextSpan(text: user != null ? user!['birthday'] : 'null', 
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
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  width: 300,
                  child: Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.black,
                        indent: 1,
                        endIndent: 1,
                      ),
                ),
                Container(
                  child: Material(
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
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  width: 300,
                  child: Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.black,
                        indent: 1,
                        endIndent: 1,
                      ),
                ),
                Column(
                  children: _isAdmin ?[
                    Container(
                      child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CheckOrder())
                            );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.shopify)
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text('Check order')
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                    ),
                    Container(
                      child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => createNameBrand())
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.add_box)
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text('Create a new name brand')
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                    ),
                    Container(
                      child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => createNewSizeClothes())
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.add_box)
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text('Create a new size clothes')
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                    ),
                    Container(
                      child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => createNewTypeClothes())
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                child: Icon(Icons.add_box)
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text('Create a new type clothes')
                              )
                            ],
                          )
                        ),
                      ),
                    ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      width: 300,
                      child: Divider(
                            height: 10,
                            thickness: 1,
                            color: Colors.black,
                            indent: 1,
                            endIndent: 1,
                          ),
                    ),
                  ] : []
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
        )
      );
  }
  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // print('Yoooooooooooooooo');
    // print(token);
    if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      // print('this is decoded Tokennnnnnnnnnnnn');
      // print(decodedToken);
      final userId = decodedToken['id'];
      final response = await http.get(
        Uri.parse('http://10.0.2.2:4000/user/$userId'),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          user = responseBody['user'];
        });
      } else {
        print('server status non-respone');
      }
    }
  }
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
    return false;
    }
    final decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'];
    final response = await http.get(
    Uri.parse('http://10.0.2.2:4000/user/permission/$userId'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final user = responseBody['user'];
      final role = user['permission'];
      if(role == 2) {
        return true;
      }else{
        return false;
      }
    } else {
      print('server status non-respone');
      return false;
    }
  }
}