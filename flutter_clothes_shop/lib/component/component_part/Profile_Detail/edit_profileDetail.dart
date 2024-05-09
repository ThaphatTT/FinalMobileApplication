import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class editProfileDetail extends StatefulWidget {
  const editProfileDetail({super.key});
  
  @override
  _editProfileDetailState createState() => _editProfileDetailState();
}

class _editProfileDetailState extends State<editProfileDetail> {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  String dropdownValue = 'male';
  Map<String, dynamic>? user = null;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownOptions = ['male', 'female'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
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
                      controller: _fnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: user != null ? user!['fname'] : 'null',
                        border: OutlineInputBorder()
                        ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _lnameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        hintText: user != null ? user!['lname'] : 'null' ,
                        border: OutlineInputBorder()
                        ),
                    ),
                  ),
                ],
              )
              ),
              Container(
                margin : EdgeInsets.fromLTRB(5, 15, 5, 15),
                child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: user != null ? user!['email'] : 'null' ,
                        border: OutlineInputBorder()
                        ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: user != null ? user!['password'] : 'null' ,
                        border: OutlineInputBorder()
                        ),
                    ),
                  ),
                ],
              )
              ),
              Container(
                margin : EdgeInsets.fromLTRB(5, 15, 5, 15),
                child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                    controller: _birthdayController,
                    decoration: InputDecoration(
                            labelText: 'Your Birthday',
                            filled : true,
                            prefixIcon: Icon(Icons.calendar_today),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)
                            )
                            ),
                            readOnly : true,
                            onTap: (){
                              _selectDate();
                            },
                  ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText: user != null ? user!['mphone'] : 'null' ,
                        border: OutlineInputBorder()
                        ),
                    ),
                  ),
                ],
              )
              ),
              Container(
                margin : EdgeInsets.fromLTRB(5, 15, 5, 15),
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  decoration: InputDecoration(
                    labelText: 'Select your sex',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
  
  Future<void> _selectDate() async{
    DateTime ? _picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
      );

      if(_picked !=null){
        setState((){
          _birthdayController.text = _picked.toString().split(" ")[0];
        });
      }
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
        Uri.parse('http://10.0.2.2:4000/user/editProfile/$userId'),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          user = responseBody['user'];
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
      final Map<String, String> updatedProfile = {};
      updatedProfile['fname'] = _fnameController.text.isNotEmpty ? _fnameController.text : user!['fname'];
      updatedProfile['lname'] = _lnameController.text.isNotEmpty ? _lnameController.text : user!['lname'];
      updatedProfile['email'] = _emailController.text.isNotEmpty ? _emailController.text : user!['email'];
      updatedProfile['password'] = _passwordController.text.isNotEmpty ? _passwordController.text : user!['password'];
      updatedProfile['birthday'] = _birthdayController.text.isNotEmpty ? _birthdayController.text : user!['birthday'];
      updatedProfile['mphone'] = _phoneController.text.isNotEmpty ? _phoneController.text : user!['mphone'];
      updatedProfile['sex'] = dropdownValue.isNotEmpty ? dropdownValue : user!['sex'];

      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['id'];
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:4000/user/editProfile/$userId'),
        body: updatedProfile,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit Profile Successful')),
        );
        Navigator.pop(context);
      } else {
        print('server status non-respone');
      }
    }
  }
}