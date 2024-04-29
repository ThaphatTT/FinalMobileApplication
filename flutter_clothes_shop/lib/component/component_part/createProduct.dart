import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class createProductScreen extends StatefulWidget {
  const createProductScreen({Key? key}) : super(key: key);

  @override
  _createProductScreenState createState() => _createProductScreenState();
}

class _createProductScreenState extends State<createProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _brand;
  String? _name;
  String? _price;
  String? _imagePath;

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
            DropdownButtonFormField<String>(
              hint: Text('Select Brand'),
              onChanged: (value) {
                setState(() {
                  _brand = value;
                });
              },
              items: ['Brand 1', 'Brand 2', 'Brand 3']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              hint: Text('Select Name'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              items: ['Name 1', 'Name 2', 'Name 3']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _price = value;
                });
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
          ],
        ),
      ),
    );
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
}
