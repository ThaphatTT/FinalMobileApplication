import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class editShipping extends StatefulWidget {
  const editShipping({super.key});
  
  @override
  _editShippingState createState() => _editShippingState();
}

class _editShippingState extends State<editShipping> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  Map<String, dynamic>? user = null;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Shipping Address'),
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
                      controller : _addressController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: user != null ? user!['address'] : 'null',
                              border: OutlineInputBorder()
                              ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
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
                      verifyEditProfile();
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
  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // print('Yoooooooooooooooo');
    // print(token);
    if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      // print('this is decoded Tokennnnnnnnnnnnn');
      // print(decodedToken);
      final userId = decodedToken['id'];
      final response = await http.get(
        Uri.parse('http://10.0.2.2:4000/user/Shipping/$userId'),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          user = responseBody['user'];
          // print('Yooooooooo');
          // print(user);
        });
      } else {
        print('server status non-respone');
      }
    }
  }

  Future<void> verifyEditProfile() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['id'];
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:4000/user/editShipping/$userId'),
        body: {
          "address" : _addressController.text
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit Your Address Successful')),
        );
        Navigator.pop(context);
      } else {
        print('server status non-respone');
      }
    }
  }
}