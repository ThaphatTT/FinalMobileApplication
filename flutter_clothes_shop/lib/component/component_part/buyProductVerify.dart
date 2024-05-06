import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:flutter_clothes_shop/component/component_part/verifyPayment.dart';
import 'package:transparent_image/transparent_image.dart';
class buyProductVerify extends StatefulWidget {
  final id;
  final dynamic matchingClothesName;
  final dynamic matchingClothesbrand;
  final String getConditionName;
  final String getEquipmentName;
  final String getSizeName;
  final int getPrice;
  final image;
  final idPost;
  const buyProductVerify({super.key, required this.id, required this.matchingClothesName, required this.matchingClothesbrand, required this.getConditionName, required this.getEquipmentName, required this.getSizeName, required this.getPrice, required this.image, required this.idPost});

  @override
  State<buyProductVerify> createState() => _buyProductVerifyState();
}

class _buyProductVerifyState extends State<buyProductVerify> {
  Map<String, dynamic>? _product;
  int shippingService = 100;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');
  Future<int> calculateTotal() async {
    int productPrice = widget.getPrice;
    return shippingService + productPrice;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy'),
      ),
      body: SingleChildScrollView(
        child : Column(
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
                            widget.matchingClothesName,
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
                            widget.matchingClothesbrand['c_brand'].toString(),
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
                              widget.getSizeName,
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
                              widget.getConditionName,
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
                              widget.getEquipmentName,
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
                              formatCurrency.format(num.parse(widget.getPrice.toString())),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Product Images',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.image.length,
                              itemBuilder: (context, index) {
                                Uint8List bytes = base64Decode(widget.image[index]['img_post']);
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Image.memory(bytes, fit: BoxFit.cover),
                                          actions: [
                                            TextButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 200,
                                    child: Image.memory(bytes, fit: BoxFit.cover),
                                  ),
                                );
                              },
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
                        formatCurrency.format(num.parse(shippingService.toString())),
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
                              formatCurrency.format(num.parse(widget.getPrice.toString())),
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
                              formatCurrency.format(num.parse(shippingService.toString())),
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
                          FutureBuilder<int>(
                            future: calculateTotal(),
                            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                else
                                  return Text(
                                    formatCurrency.format(num.parse('${snapshot.data}')),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                    ),
                                  );
                              }
                            })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Material(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5.5)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> verifyPayment(
                      idPost : widget.idPost,
                      getPrice : widget.getPrice
                      ))
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 50,
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ),
            ),
            ),
          ],
        )
      )
    );
  }
}