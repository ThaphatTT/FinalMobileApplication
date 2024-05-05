import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class createNewSizeClothes extends StatefulWidget {
  const createNewSizeClothes({super.key});
  
  @override
  _createNewSizeClothesState createState() => _createNewSizeClothesState();
}

class _createNewSizeClothesState extends State<createNewSizeClothes> {
  final _formKey = GlobalKey<FormState>();
  final _sizeclothes = TextEditingController();
  Map<String, dynamic>? _typeClothes;
  List<Map<String, dynamic>> typeClothesDropdownOptions = [];

  @override
  void initState() {
    super.initState();
    getAllSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new size clothes'),
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
                      controller : _sizeclothes,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                              labelText: 'input new size you want',
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
              DropdownButtonFormField<Map<String, dynamic>>(
                hint: Text('Select Name'),
                onChanged: (Map<String, dynamic>? newValue)  {
                  setState(() {
                    _typeClothes = newValue;
                    print(_typeClothes!['id']);
                  });
                },
                items: typeClothesDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value){
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Text(value['name']),
                    );
                }).toList(),
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createSizeClothes();
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
  Future<void> getAllSize() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/AllNewType'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>>  typeclothes = body.map((dynamic item) => {'id': item['id'], 'name': item['clothes_type']}).toList();
      setState(() {
        typeClothesDropdownOptions = typeclothes;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }
  Future<void> createSizeClothes() async {
      final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/clothes/CreateNewSize'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'clothes_size' : _sizeclothes.text ,
        'clothes_type' : _typeClothes!['id'].toString()
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