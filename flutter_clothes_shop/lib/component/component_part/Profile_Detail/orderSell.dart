import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class orderSell extends StatefulWidget {
  const orderSell({super.key});
  
  @override
  State<orderSell> createState() => _orderSellState();
}

class _orderSellState extends State<orderSell> {
  Map<String, dynamic>? _post;
  List<Map<String, dynamic>> postOptions = [];
  List<dynamic> image = [];
  List<dynamic> products = [];
  var matchingClothesName;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');

  @override
  void initState() {
    super.initState();
    getAllUsersProductSellPost();
    getAllClothes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order Sell'),
      ),
      body: ListView.builder(
      itemCount: postOptions.length,
      itemBuilder: (context, index) {
        matchingClothesName = products.firstWhere((products) => products['id'] == postOptions[index]['c_id'], orElse: () => {'id': null, 'name': null});
        return GestureDetector(
          onTap: () {

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
                          'Status : ' + postOptions[index]['p_status'],
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
  Future<void> getAllUsersProductSellPost() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if(token !=null && token.isNotEmpty){
      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['id'];
      final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/order/orderSelling/$userId'),
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
    }
    else{
      print('not found token');
    }
    print('postttttt');
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
    print('product');
    print(products);
  }
}