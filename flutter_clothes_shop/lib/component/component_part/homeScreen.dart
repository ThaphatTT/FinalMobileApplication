import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_clothes_shop/component/component_part/homeScreenDetail.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> products = [];
  List<dynamic> clothesBrand = [];
  var clothesName;
  var matchingClothesbrand;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'th_TH');
  @override
  void initState() {
    super.initState();
    getAllClothes();
    getAllBrands();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) {
          matchingClothesbrand = clothesBrand.firstWhere((clothesBrand) => clothesBrand['id'] == products[i]['c_brand'], orElse: () => {'id': null, 'name': null});
          print(matchingClothesbrand);
          return GestureDetector( 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => homeScreenDetailPage(id: products[i]['id'], matchingClothesName: products[i]['c_name'], matchingClothesbrand : matchingClothesbrand),
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
                      products[i]['c_name'],
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
                        Container(
                          width: double.infinity,
                          child: Text('Original price'),
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            formatCurrency.format(num.parse(products[i]['c_price'])),
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
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
    print(products);
  }
  Future<void> getAllBrands() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/getAllBrands'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> brands = body.map((dynamic item) => {'id': item['id'], 'c_brand': item['clothes_brand']}).toList();
      setState(() {
        clothesBrand = brands;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }
}
