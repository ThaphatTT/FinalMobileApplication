import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_clothes_shop/component/component_part/homeScreenDetail.dart';

class Products {
  final int id;
  final String type;
  final String name;
  final int price;
  final String image;

  Products({
    required this.id,
    required this.type,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Products> products = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);
    setState(() {
      products = List<Products>.from(data['products'].map((i) => Products.fromJson(i)));
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, i) {
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
                  Image.network(products[i].image),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 30),
                    child: Text(
                      products[i].name,
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
                          '฿ ' + products[i].price.toString(),
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
}
