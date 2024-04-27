import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


class AttractionDetailPage extends StatefulWidget {
  final int id;

  const AttractionDetailPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _AttractionDetailPageState();
  }
}
class _AttractionDetailPageState extends State<AttractionDetailPage> {
  Map<String, dynamic>? _attractionDetail;
  bool _PDisVisible = false;
  bool _SMisVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchAttractionDetail();
  }

  Future<void> _fetchAttractionDetail() async {
  final String response = await rootBundle.loadString('assets/products.json');
  final Map<String, dynamic> allProducts = json.decode(response);
  final List products = allProducts['products'];
  
  setState(() {
    _attractionDetail = products.firstWhere((product) => product['id'] == widget.id);
  });
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
                  Image.network(_attractionDetail!['image']),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: 
                      Text(
                    _attractionDetail!['name'],
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
                        Text(
                          '฿ '+ _attractionDetail!['price'].toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        Text(
                          '฿ '+ _attractionDetail!['price'].toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        Text(
                          '฿ '+ _attractionDetail!['price'].toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
                              'Yoo',
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
                              'Yoo',
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
                              'Yoo',
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
                ],
              ))
              ) 
              );
  }
}