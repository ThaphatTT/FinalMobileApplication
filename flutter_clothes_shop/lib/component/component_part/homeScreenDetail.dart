import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter_clothes_shop/component/component_part/Product/createPostProductSell.dart';
import 'package:flutter_clothes_shop/component/component_part/Product/buyProduct.dart';

class homeScreenDetailPage extends StatefulWidget {
  final int id;
  final dynamic matchingClothesName;
  final dynamic matchingClothesbrand;

  const homeScreenDetailPage({super.key, required this.id, this.matchingClothesName, required this.matchingClothesbrand});

  @override
  State<StatefulWidget> createState() {
    return _homeScreenDetailPageState();
  }
}
class _homeScreenDetailPageState extends State<homeScreenDetailPage> {
  Map<String, dynamic>? _attractionDetail;
  List<dynamic> products = [];
  bool _PDisVisible = false;
  bool _SMisVisible = false;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');

  @override
  void initState() {
    super.initState();
    getAllClothes();
    print(widget.matchingClothesName);
    print(widget.id);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: SingleChildScrollView(
        child : _attractionDetail == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.memory(base64Decode(_attractionDetail!['c_image'])),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: 
                      Text(
                        widget.matchingClothesName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Original price',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                          ),
                        Text(
                          'Highest Bid',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                          ),
                        Text(
                          'Last Sale',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                          formatCurrency.format(num.parse(_attractionDetail!['c_price'])),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                          formatCurrency.format(num.parse(_attractionDetail!['c_price'])),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                          formatCurrency.format(num.parse(_attractionDetail!['c_price'])),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 5,
                    thickness: 1,
                    color: Colors.black,
                    indent: 1,
                    endIndent: 1,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: TextButton(
                    onPressed: ()=> setState(()=> _SMisVisible = !_SMisVisible),
                    child: Text(
                      'Product Detail',
                      style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                  )
                  ),
                  if(_SMisVisible)
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Brand',
                              style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                              ),
                            Text(
                              widget.matchingClothesbrand != null ? '${widget.matchingClothesbrand['c_brand']}' : 'null',
                              style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
                            Text(
                              'Name',
                              style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                              ),
                            Text(
                              widget.matchingClothesName,
                              style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
                            Text(
                              'Original price',
                              style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                              ),
                            Text(
                              formatCurrency.format(num.parse(_attractionDetail!['c_price'])),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 4,
                    thickness: 1,
                    color: Colors.black,
                    indent: 1,
                    endIndent: 1,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: TextButton(
                    onPressed: ()=> setState(()=> _PDisVisible = !_PDisVisible),
                    child: Text(
                      'Shipping Method',
                      style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                  )
                  ),
                  if(_PDisVisible)
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Row(
                          children: [
                            Image.asset(
                            'assets/images/coat_hanger.png',
                            fit: BoxFit.cover,
                                height: 25,
                                width: 50,
                            ),
                          Container(
                          margin : EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: Column(
                            children: [
                              Text(
                            'Standard Delivery',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            Text(
                            'Ship via logistic partner (7-14 days)',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                            )
                            ],)
                          )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 4,
                    thickness: 1,
                    color: Colors.black,
                    indent: 1,
                    endIndent: 1,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          width: 200,
                          height: 30,
                          color: Colors.grey[200],
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                                child: Icon(Icons.health_and_safety_rounded),
                              ),
                              Container(
                              child: Center(
                                  child: Text(
                                    '100% Authentic Guarantee',
                                    style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold
                                    )
                                    ),
                                ),
                            )
                          ],),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          width: 200,
                          height: 30,
                          color: Colors.grey[200],
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(7, 0, 0, 0),
                                child: Icon(Icons.safety_check),
                              ),
                              Container(
                              child: Center(
                                  child: Text(
                                    'Anti Fraudulent transaction',
                                    style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold
                                    )
                                    ),
                                ),
                            )
                          ],),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5.5)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => createPostProductScreen(id : widget.id))
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            child: Center(
                              child: Text(
                                'Sell',
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
                      Material(
                        color: Colors.green[600],
                        borderRadius: BorderRadius.all(Radius.circular(5.5)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> BuyProduct(id : widget.id, matchingClothesName : widget.matchingClothesName, 
                              matchingClothesbrand: widget.matchingClothesbrand,
                              
                              ))
                            );
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            child: Center(
                              child: Text(
                                'Buy',
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
                    ],),
                  )
                ],
              ))
              ),
              );
  }
  Future<void> getAllClothes() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:4000/clothes'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final product = data.firstWhere((product) => product['id'] == widget.id, orElse: () => null);
    if (product != null) {
      setState(() {
        _attractionDetail = product;
        products = data;
      });
      } else {
        print('not found id');
      }
  } else {
    throw Exception('Failed to load clothes colors');
    }
  }
}