import 'package:flutter/material.dart';
import 'package:flutter_clothes_shop/component/tabMenu.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String dropdownValue = 'male';

  @override
  Widget build(BuildContext context) {
    List<String> dropdownOptions = ['male', 'female',];
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                        border: OutlineInputBorder()
                        ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _lnameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder()
                        ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
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
                        border: OutlineInputBorder()
                        ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder()
                        ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
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
                      labelStyle: TextStyle(
                        color: Colors.black
                      ),
                      filled : true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)
                      )
                      ),
                      readOnly : true,
                      onTap: (){
                        _selectDate();
                      },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your birthday';
                      }
                      return null;
                    },
                  ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder()
                        ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile phone';
                        }
                        return null;
                      },
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
                      minLines: 2,
                      controller : _addressController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                              labelText: 'Address',
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Theme(
                            data: ThemeData(dialogBackgroundColor: Colors.white), // เปลี่ยนสีที่นี่
                            child: AlertDialog(
                              title: Text('Confirmation'),
                              content: Text('Please check your data is correct, Do you want to register?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'NO',
                                    style: TextStyle(
                                      color: Colors.grey
                                    ),
                                    ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'YES',
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                    ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    registerUser();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
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
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.grey,
          ),
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary
          ),
        ),
        child: child!,
      );
    }
      );

      if(_picked !=null){
        setState((){
          _birthdayController.text = _picked.toString().split(" ")[0];
        });
      }
  }
  Future<void> registerUser() async{
    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/createUser'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'email' : _emailController.text ,
        'password' : _passwordController.text,
        'fname' : _fnameController.text,
        'lname' : _lnameController.text,
        'birthday' : _birthdayController.text,
        'mphone' : _phoneController.text,
        'sex' : dropdownValue,
        'address' : _addressController.text
      })
    );

    if(response.statusCode == 200){
      print('User created successed!');
      var data = jsonDecode(response.body);
      if(data['status'] == 'ok'){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TabMenu()
            )
        );
      }
    }else{
      print('Failed to create a user');
    }
  }
}