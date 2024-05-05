import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class createNewTypeClothes extends StatefulWidget {
  const createNewTypeClothes({super.key});
  
  @override
  _createNewTypeClothesState createState() => _createNewTypeClothesState();
}

class _createNewTypeClothesState extends State<createNewTypeClothes> {
  final _formKey = GlobalKey<FormState>();
  final _typeclothes = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new type clothes'),
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
                      controller : _typeclothes,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                              labelText: 'input new type you want',
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
                      createNewTypeClothes();
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
  Future<void> createNewTypeClothes() async {
      final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/clothes/CreateNewType'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'clothes_type' : _typeclothes.text ,
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