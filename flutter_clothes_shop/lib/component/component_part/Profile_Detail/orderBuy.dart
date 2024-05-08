import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class orderBuy extends StatefulWidget {
  const orderBuy({super.key});
  
  @override
  State<orderBuy> createState() => _orderBuyState();
}

class _orderBuyState extends State<orderBuy> {
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
    getAllUsersProductBuyPost();
    getAllClothes();
    getAllOrderStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order Buy'),
      ),
      body: ListView.builder(
      itemCount: postOptions.length,
      itemBuilder: (context, index) {
        matchingClothesName = products.firstWhere((products) => products['id'] == postOptions[index]['c_id'], orElse: () => {'id': null, 'name': null});
        matchingorderStatus = orderStatus.firstWhere((orderStatus) => orderStatus['id'] == orderOptions[index]['o_status'], orElse: () => {'id': null, 'name': null});
        return GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            height: 90,
            color: Colors.amber,
            child: Row(
              children: [
                Container(
                  color: Colors.green,
                  width: 150,
                  child: postOptions[index]['images'].isNotEmpty
                  ? Image.memory(base64Decode(postOptions[index]['images'][0]['img_post']))
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
  Future<void> getAllUsersProductBuyPost() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if(token !=null && token.isNotEmpty){
      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['id'];
      final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/orderBuying/Users/$userId'),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        List<dynamic> results = body['results'];
        for (var result in results) {
          var post = {
            'iduser': result['iduser'], 
            'idpost': result['idpost'],
            'date': result['date'],
            'total': result['total'],
            'o_status': result['o_status']
          };
          setState(() {
            orderOptions.add(post);
          });
          await getAllUsersProductSellPost(post['idpost']);
        }
      }
    } else {
      throw Exception('Failed to load brands');
    }
    }
    else{
      print('not found token');
    }
    print('User` post buy product');
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
  Future<List<Map<String, dynamic>>> getImages(int orderId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/buyProduct/Image/$orderId'),
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