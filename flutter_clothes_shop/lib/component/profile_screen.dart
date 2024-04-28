import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/component_part/registerScreen.dart';
import 'package:flutter_clothes_shop/component/component_part/profile_detail.dart';
import 'package:flutter_clothes_shop/component/tabMenu.dart';

class Profile_HomeScreen extends StatefulWidget {
  final Function onLoginSuccess;
  const Profile_HomeScreen({super.key, required this.onLoginSuccess});

  @override
  State <StatefulWidget> createState(){
    return LoginScreenState();
  }
}

class LoginScreenState extends State<Profile_HomeScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title : Image.asset(
          'assets/images/coat_hanger.png',
          fit: BoxFit.cover,
              height: 55,
              width: 55,
          ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child : Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  
                  ),
              ),
              Padding(
                padding: EdgeInsets.all(2),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your Email',
                      border: OutlineInputBorder()
                      ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Please input your email';
                      }else if(!value.contains('@')){ // check character @
                        return 'Please enter valid email';
                      }
                  },
                ),
                  ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    controller : _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility
                        ),
                      )
                      ),
                      obscureText: _obscurePassword, // password
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Please input your password';
                    }
                  },
                ),
                ),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email : $email \nPassword : $password')),
                        );
                        widget.onLoginSuccess();
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        
                        ),
                      ),
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                ],
                ),
                )
            ],
          )
        ),
      )
    );
  }
}