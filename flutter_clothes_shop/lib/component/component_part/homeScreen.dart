import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_clothes_shop/component/component_part/homeScreenDetail.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  List<dynamic> clothesNames = [];
  var matchingClothesName;
  @override
  void initState() {
    super.initState();
    getAllClothes();
    getAllClothesNames();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) {
          matchingClothesName = clothesNames.firstWhere((clothesName) => clothesName['id'] == products[i]['c_name'], orElse: () => null);
          return GestureDetector( 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttractionDetailPage(id: products[i].id),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Image.memory(base64Decode(products[i]['c_image'])),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 30),
                    child: Text(
                      matchingClothesName != null && matchingClothesName['clothes_name'] != null ? matchingClothesName['clothes_name'] : 'Unknown',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text('Original price'),
                        Text(
                          '฿ ' + products[i]['c_price'].toString(),
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [

                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Future<void> getAllClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = data.map((i) => i as Map<String,dynamic>).toList();
      });
    } else {
      throw Exception('Failed to load clothes');
    }
  }
  Future<void> getAllClothesNames() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/getAllClothes'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        clothesNames = data;
      });
    } else {
      throw Exception('Failed to load clothes names');
    }
  }
}
