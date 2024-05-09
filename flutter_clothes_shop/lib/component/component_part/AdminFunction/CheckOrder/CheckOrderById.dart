import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class checkOrderById extends StatefulWidget {
  final Map<String, dynamic> userBuy;
  final Map<String, dynamic> userSell;
  const checkOrderById({super.key, required this.userBuy, required this.userSell});

  @override
  State<checkOrderById> createState() => _checkOrderByIdState();
}

class _checkOrderByIdState extends State<checkOrderById> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> clothesBrand = [];
  List<Map<String, dynamic>> conditionDropdownOptions = [];
  List<Map<String, dynamic>> equipmentDropdownOptions = [];
  Map<String, dynamic>? _orderStatus;
  List<Map<String, dynamic>> orderStatusDropdownOptions = [];
  Map<String, dynamic>? userBuy = null;
  Map<String, dynamic>? userSeller = null;
  int shippingService = 100;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');
  var total;
  Future<int> calculateTotal() async {
    int productPrice = widget.userSell['c_price'];
    total = shippingService + productPrice;
    return total;
  }
  @override
  void initState() {
    super.initState();
    calculateTotal();
    getAllCondition();
    getAllEquipment();
    getUserBuyData();
    getUserSellerData();
    getAllClothes();
    getAllBrands();
    getAllStatus();
  }
  @override
  Widget build(BuildContext context) {
    String imageName = getImage(products, widget.userSell['c_id']);
    Uint8List? bytes;
    if (imageName != 'Not found') {
      bytes = base64Decode(imageName);
    }
    String clothesName = getNameProduct(products, widget.userSell['c_id']);
    String equipmentName = getEquipmentName(equipmentDropdownOptions, widget.userSell['ce_id']);
    String conditionName = getEquipmentName(conditionDropdownOptions, widget.userSell['cc_id']);
    String brandName = getBrand(products, clothesBrand);
    print(_orderStatus);
    print(widget.userSell['p_id']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
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
                  if (bytes != null) 
                  Container(
                    color: Colors.green,
                    width:  150,
                    child: Image.memory(bytes),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                          child: Text(
                            clothesName,
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
                            brandName,
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
                              widget.userSell['c_size'],
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
                              conditionName,
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
                              equipmentName,
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
                              formatCurrency.format(num.parse(widget.userSell['c_price'].toString())),
                              // widget.userSell != null ? widget.userSell['c_price'].toString() : 'not found',
                              // formatCurrency.format(num.parse(widget.getPrice.toString())),
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
                              itemCount: widget.userSell['images'].length,
                              itemBuilder: (context, index) {
                                Uint8List bytes = base64Decode(widget.userSell['images'][index]['img_post']);
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
                          ),
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
                              'Payment Image',
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
                              itemCount: widget.userBuy['images'].length,
                              itemBuilder: (context, index) {
                                Uint8List bytes = base64Decode(widget.userBuy['images'][index]['img_payment']);
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
                          ),
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
                      'Customer Name',
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
                      userBuy != null ? userBuy!['fname']+ ' ' +userBuy!['lname'] : '',
                      style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
                      ),
                  ),
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
                      userBuy != null ? userBuy!['address'] : '',
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
                              formatCurrency.format(num.parse(widget.userSell['c_price'].toString())),
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
              margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                    width: double.infinity,
                    child: Text(
                      'Seller Detail',
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
                    child: Row(
                      children: [
                        Text(
                        'Name : ',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                        ),
                        Text(
                        userSeller != null ? userSeller!['fname'] + ' ' + userSeller!['lname'] : '',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                        ),
                    ],)
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                        'Address : ',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                        ),
                        Text(
                        userSeller != null ? userSeller!['address'] : '',
                        style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                ),
                        ),
                    ],)
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(5, 0, 0, 15),
              child: Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chose status a order',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      hint: Text('Select Status'),
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() {
                          _orderStatus = newValue;
                        });
                      },
                      items: orderStatusDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: value,
                          child: Text(value['name']),
                        );
                      }).toList(),
                    ),
                  )
                )
              ],)
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.5)),
                child: InkWell(
                  onTap: () {
                    changeStatusOrder();
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
  Future<void> getAllCondition() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/condition'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> condition = body.map((dynamic item) => {'id': item['id'], 'name': item['c_condition']}).toList();
      setState(() {
        conditionDropdownOptions = condition;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }
  Future<void> getAllEquipment() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/equipment'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> equipment = body.map((dynamic item) => {'id': item['id'], 'name': item['c_equipment']}).toList();
      setState(() {
        equipmentDropdownOptions = equipment;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }
  Future<List<Map<String, dynamic>>> getImages(int postId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/buyProduct/Image/$postId'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data.map<Map<String, dynamic>>((i) {
        if (i is Map<String, dynamic>) {
          return i;
        } else {
          throw Exception('Invalid data format');
        }
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
  String getEquipmentName(List<Map<String, dynamic>> equipmentList, int ce_id) {
    for (var equipment in equipmentList) {
      if (equipment['id'] == ce_id) {
        return equipment['name'];
      }
    }
    return 'Not found';
  }
  String getConditionName(List<Map<String, dynamic>> conditionList, int cc_id) {
    for (var condition in conditionList) {
      if (condition['id'] == cc_id) {
        return condition['name'];
      }
    }
    return 'Not found';
  }
  Future<void> getUserBuyData() async {
      final userId = widget.userBuy['iduser'].toString();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:4000/user/$userId'),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          userBuy = responseBody['user'];
        });
      } else {
        print('server status non-respone');
      }
  }
  Future<void> getUserSellerData() async {
      final userId = widget.userSell['u_id'].toString();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:4000/user/$userId'),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          userSeller = responseBody['user'];
        });
      } else {
        print('server status non-respone');
      }
    print(userSeller);
  }
  Future<void> getAllClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      if (mounted) {
        setState(() {
          products = data.map((i) => i as Map<String,dynamic>).toList();
        });
      }
    } else {
      throw Exception('Failed to load clothes');
    }
    print(products);
  }

  String getImage(List<Map<String, dynamic>> productList, int c_id) {
  for (var product in productList) {
    if (product['id'] == c_id) {
      return product['c_image'];
    }
  }
    return 'Not found';
  }
  String getNameProduct(List<Map<String, dynamic>> productList, int c_id) {
  for (var product in productList) {
    if (product['id'] == c_id) {
      return product['c_name'];
    }
  }
    return 'Not found';
  }
  Future<void> getAllBrands() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/getAllBrands'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      if (mounted) {
        setState(() {
          clothesBrand = data.map((i) => i as Map<String,dynamic>).toList();
        });
      }
    } else {
      throw Exception('Failed to load clothes');
    }
  }
  String getBrand(List<Map<String, dynamic>> productList, List<Map<String, dynamic>> brandList) {
    for (var product in productList) {
      for (var brand in brandList) {
        if (product['c_brand'] == brand['id']) {
          return brand['clothes_brand'];
        }
      }
    }
    return 'Not found';
  }

  Future<void> getAllStatus() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/status'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> status = body.map((dynamic item) => {'id': item['id'], 'name': item['o_status']}).toList();
      setState(() {
        orderStatusDropdownOptions = status;
      });
    } else {
      throw Exception('Failed to load status order');
    }
  }
  Future<void> changeStatusOrder() async{
    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/order/ChangeStatus/admin'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'id' : widget.userBuy['id'].toString(),
        'o_status' : _orderStatus!['id'].toString() ,
    })
    );
    if(response.statusCode == 200){
      print('Order`s change successed!');
      var data = jsonDecode(response.body);
      if(data['status'] == 'ok'){
        await changeStatusUserSell();
        Navigator.pop(context);
      }
    }else{
      print('Failed to create a ImgPayment');
    }
  }
  Future<void> changeStatusUserSell() async{
    if (_orderStatus!['id'] == 2) {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/order/ChangeStatus/postuserSell/admin'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'id' : widget.userSell['p_id'].toString(),
        'p_status' : 'Waiting customer buy order',
      })
    );

    if(response.statusCode == 200){
      print('Post`s change successed!');
      var data = jsonDecode(response.body);
      if(data['status'] == 'ok'){
        Navigator.pop(context);
      }
    }else{
      print('Failed to create a ImgPayment');
    }
  }
  }
}