import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:flutter_clothes_shop/component/component_part/AdminFunction/CheckOrder/CheckOrderById.dart';

class OrderPadding extends StatefulWidget {
  const OrderPadding({super.key});

  @override
  State<OrderPadding> createState() => _OrderPaddingState();
}

class _OrderPaddingState extends State<OrderPadding> {
  Map<String, dynamic>? _post;
  List<Map<String, dynamic>> postOptions = [];
  List<Map<String, dynamic>> orderOptions = [];
  List<dynamic> image = [];
  List<dynamic> products = [];
  List<dynamic> orderStatus = [];
  var matchingClothesName;
  var matchingorderStatus;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');
  @override
  void initState() {
    super.initState();
    getAllOrder();
    getAllClothes();
    getAllOrderStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
      itemCount: postOptions.length,
      itemBuilder: (context, index) {
        matchingClothesName = products.firstWhere((products) => products['id'] == postOptions[index]['c_id'], orElse: () => {'id': null, 'name': null});
        matchingorderStatus = orderStatus.firstWhere((orderStatus) => orderStatus['id'] == orderOptions[index]['o_status'], orElse: () => {'id': null, 'name': null});
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute( builder: 
              (context) => checkOrderById(
                userBuy: orderOptions[index],
                userSell: postOptions[index]
                )
              )
            );
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            height: 90,
            color: Colors.grey[200],
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: postOptions[index]['images'].isNotEmpty
                  ? Image.memory(base64Decode(postOptions[index]['images'][0]['img_post']),
                  fit: BoxFit.cover,
                  )
                  : Container(),
                ),
                Flexible(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          matchingClothesName != null ? matchingClothesName['name']: 'null',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          postOptions[index]['c_size'].toString()
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          matchingorderStatus['name'],
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    formatCurrency.format(num.parse(postOptions[index]['c_price'].toString())),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ), 
    );
  }
  Future<void> getAllOrder() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/Check'),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var result in body) {
        var post = {
          'id' : result['id'],
          'iduser': result['iduser'], 
          'idpost': result['idpost'],
          'date': result['date'],
          'total': result['total'],
          'o_status': result['o_status'],
          'images': await getImagesPayment(result['id'])
        };
        if(post['o_status'] == 1){
          setState(() {
          orderOptions.add(post);
        });
        await getAllUsersProductSellPost(post['idpost']);
        }
      }
    } else {
      throw Exception('Failed to load brands');
    }
    print('Order user`s buy product');
    print(orderOptions);
  }
  Future<void> getAllUsersProductSellPost(int idpost) async {
      final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/orderSelling/UserBuying/$idpost'),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        List<dynamic> results = body['results'];
        for (var result in results) {
          var post = {
            'p_id': result['id'], 
            'u_id': result['u_id'],
            'cc_id': result['cc_id'],
            'ce_id': result['ce_id'],
            'c_id': result['c_id'], 
            'c_size': result['c_size'],
            'c_price': result['c_price'],
            'p_status': result['p_status'],
            'images': await getImages(result['id']),
          };
          setState(() {
            postOptions.add(post);
          });
        }
      }
    } else {
      throw Exception('Failed to load brands');
    }
    print('user`s post product sell');
    print(postOptions);
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
   Future<List<Map<String, dynamic>>> getImagesPayment(int id) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/ImagePayment/$id'),
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

  Future<void> getAllClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> clothes = data.map((dynamic item) => {'id': item['id'], 'name': item['c_name']}).toList();
      setState(() {
        products = clothes;
      });
    } else {
      throw Exception('Failed to load clothes');
    }
    print('clothes');
    print(products);
  }
  Future<void> getAllOrderStatus() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/status'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> status = data.map((dynamic item) => {'id': item['id'], 'name': item['o_status']}).toList();
      setState(() {
        orderStatus = status;
      });
    } else {
      throw Exception('Failed to load clothes');
    }
    print('orderStatus');
    print(orderStatus);
  }
}