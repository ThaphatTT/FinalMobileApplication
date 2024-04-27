import 'package:flutter/material.dart';

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
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  String dropdownValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    List<String> dropdownOptions = ['Option 1', 'Option 2', 'Option 3'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // ใช้ไอคอนที่คุณต้องการ
          onPressed: () {
            Navigator.pop(context); // นำทางกลับไปยังหน้าก่อนหน้า
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
                      minLines: 2, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: _addressController,
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
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration Successful')),
                      );
                    }
                  },
                  child: const Text(
                    'Register',
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
}