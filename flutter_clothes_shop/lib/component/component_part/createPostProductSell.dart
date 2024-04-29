import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class createPostProductScreen extends StatefulWidget {
  const createPostProductScreen({Key? key}) : super(key: key);

  @override
  _createPostProductScreenState createState() => _createPostProductScreenState();
}

class _createPostProductScreenState extends State<createPostProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _brand;
  String? _name;
  String? _size;
  String? _price;
  List<String>? _imagePaths;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Your Order'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            DropdownButtonFormField<String>(
              hint: Text('Select Condition'),
              onChanged: (value) {
                setState(() {
                  _brand = value;
                });
              },
              items: ['Brand New', 'Pre-owened']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              hint: Text('Select Equipment'),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              items: ['Box', 'Not have a Box']
                  .map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      ))
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              hint: Text('Select Size'),
              onChanged: (value) {
                setState(() {
                  _size = value;
                });
              },
              items: ['Size 1', 'Size 2', 'Size 3']
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
                  onPressed: pickFiles,
                  child: Text('Attach Image'),
                ),
                if (_imagePaths != null) 
                  ..._imagePaths!.map((paths) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(paths),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )).toList(),
              ],
            ),
            Container(
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.5)),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                      child:Text(
                        'Confirm payment  ',
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

    Future<void> pickFiles() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        // รับเส้นทางไฟล์
        List<String> filePaths = result.paths.map((path) => path!).toList();
        if (filePaths != null) {
          setState(() {

          if (_imagePaths == null) {
            _imagePaths = filePaths;
          } else {
            _imagePaths!.addAll(filePaths);
          }
        });
        }
      }
    }

}
