import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class createNameBrand extends StatefulWidget {
  const createNameBrand({super.key});
  
  @override
  _createNameBrandState createState() => _createNameBrandState();
}

class _createNameBrandState extends State<createNameBrand> {
  final _formKey = GlobalKey<FormState>();
  final _nameBrand = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new name brand'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body : Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin : EdgeInsets.fromLTRB(5, 15, 5, 15),
                child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      minLines: 2,
                      controller : _nameBrand,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                              labelText: 'input new brand you want',
                              border: OutlineInputBorder()
                              ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new brand';
                        }
                        return null;
                      },
                    ),
                    ),
                ],
              )
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createNameClothes();
                    }
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> createNameClothes() async {
     final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/clothes/createNewbrand'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'clothes_brand' : _nameBrand.text ,
      })
    );

    if(response.statusCode == 200){
      print('New brand created successed!');
        Navigator.pop(
          context
        );
    }else{
      print('Failed to create a New brand');
    }
  }
}