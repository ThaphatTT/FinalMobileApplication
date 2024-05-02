import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class createProductScreen extends StatefulWidget {
  const createProductScreen({Key? key}) : super(key: key);

  @override
  _createProductScreenState createState() => _createProductScreenState();
}

class _createProductScreenState extends State<createProductScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _brand;
  List<Map<String, dynamic>> brandDropdownOptions = [];
  Map<String, dynamic>? _clothes;
  List<Map<String, dynamic>> clothesDropdownOptions = [];
  final _price = TextEditingController();
  String? _imagePath;
  @override
  void initState() {
    super.initState();
    getAllBrands();
    getAllClothes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            DropdownButtonFormField<Map<String, dynamic>>(
              hint: Text('Select Brand'),
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  _brand = newValue;
                  print(_brand!['id']);
                });
              },
              items: brandDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(value['name']),
                );
              }).toList(),
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
              hint: Text('Select Name'),
              onChanged: (Map<String, dynamic>? newValue)  {
                setState(() {
                  _clothes = newValue;
                  print(_clothes!['id']);
                });
              },
              items: clothesDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value){
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(value['name']),
                  );
              }).toList(),
            ),
            TextFormField(
              controller : _price,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Staring price';
                }
                return null;
              },
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: pickFile,
                  child: Text('Attach Image'),
                ),
                // แสดงผลภาพที่เลือก (หากมี)
                if (_imagePath != null) 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(_imagePath!),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            Container(
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.5)),
                child: InkWell(
                  onTap: () {
                    createClothes();
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                      child:Text(
                        'Confirm to create a product thumbnail',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Future<void> getAllBrands() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/getAllBrands'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> brands = body.map((dynamic item) => {'id': item['id'], 'name': item['clothes_brand']}).toList();
      setState(() {
        brandDropdownOptions = brands;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<void> getAllClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/getAllClothes'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> clothes = body.map((dynamic item) => {'id': item['id'], 'name': item['clothes_name']}).toList();
      setState(() {
        clothesDropdownOptions = clothes;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
        // รับเส้นทางไฟล์
        String? filePath = result.files.single.path;
        if (filePath != null) {
            // อัปเดตเส้นทางไฟล์ใน State
            setState(() {
                _imagePath = filePath;
            });
        }
    }
  }
  Future<void> createClothes() async {
  var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:4000/clothes/createClothes'));
  request.fields['c_brand'] = _brand!['id'].toString();
  request.fields['c_name'] = _clothes!['id'].toString();
  request.fields['c_price'] = _price.text;
  request.files.add(await http.MultipartFile.fromPath('c_image', _imagePath!));
  var response = await request.send();
  if (response.statusCode == 200) {
    print('Clothes created successed!');
    response.stream.transform(utf8.decoder).listen((value) {
      var data = jsonDecode(value);
      if (data['status'] == 'ok') {
        Navigator.pop(context);
      }
    });
  } else {
    print('Failed to create a user');
  }
}



}
