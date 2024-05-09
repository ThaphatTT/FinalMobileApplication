import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter_clothes_shop/component/component_part/Product/buyProductVerify.dart';

class BuyProduct extends StatefulWidget {
  final int id;
  final dynamic matchingClothesName;
  final dynamic matchingClothesbrand;
  const BuyProduct({super.key, required this.id, required this.matchingClothesName, required this.matchingClothesbrand});
  
  @override
  State<BuyProduct> createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');
  List<dynamic> products = [];
  List<Map<String, dynamic>> postOptions = [];
  List<Map<String, dynamic>> conditionDropdownOptions = [];
  List<Map<String, dynamic>> equipmentDropdownOptions = [];
  List<dynamic> image = [];
  var idPost;

  @override
  void initState() {
    super.initState();
    getAllUserProductPost();
    getAllCondition();
    getAllEquipment();
    getAllClothes();
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Buy a Product'),
    ),
    body: ListView.builder(
      itemCount: postOptions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => buyProductVerify(id: postOptions[index]['p_id'], 
                matchingClothesName : widget.matchingClothesName, 
                matchingClothesbrand: widget.matchingClothesbrand,
                getConditionName: getConditionName(postOptions[index]['cc_id']),
                getEquipmentName: getEquipmentName(postOptions[index]['ce_id']),
                getSizeName: postOptions[index]['c_size'],
                getPrice: postOptions[index]['c_price'],
                image : postOptions[index]['images'],
                idPost : postOptions[index]['p_id']
                ),
              ),
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
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          getConditionName(postOptions[index]['cc_id']),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          getEquipmentName(postOptions[index]['ce_id']),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          'Size ' +postOptions[index]['c_size'].toString()
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


  Future<void> getAllUserProductPost() async {
    var postId = widget.id;
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/buyProduct/$postId'),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        List<dynamic> results = body['results'];
        for (var result in results) {
          var post = {
            'p_id': result['id'], 
            'cc_id': result['cc_id'], 
            'ce_id': result['ce_id'], 
            'c_size': result['c_size'],
            'c_typeId': result['c_type'],
            'c_price': result['c_price'],
            'p_status': result['p_status'],
            'images': await getImages(result['id']),
          };
          if(post['p_status'] != "The product has been purchased")
          setState(() {
            postOptions.add(post);
          });
        }
      }
    } else {
      throw Exception('Failed to load brands');
    }
    print(postOptions);
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

  String getConditionName(int id) {
    return conditionDropdownOptions.firstWhere((option) => option['id'] == id)['name'];
  }

  String getEquipmentName(int id) {
    return equipmentDropdownOptions.firstWhere((option) => option['id'] == id)['name'];
  }

  Future<void> getAllClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
}