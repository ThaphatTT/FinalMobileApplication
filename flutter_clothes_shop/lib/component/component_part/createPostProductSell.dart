import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class createPostProductScreen extends StatefulWidget {
  final int id;
  const createPostProductScreen({super.key, required this.id,});

  @override
  _createPostProductScreenState createState() => _createPostProductScreenState();
}

class _createPostProductScreenState extends State<createPostProductScreen> {
  final _formKey = GlobalKey<FormState>();
  var products = [];
  Map<String, dynamic>? _condition;
  List<Map<String, dynamic>> conditionDropdownOptions = [];
  Map<String, dynamic>? _equipment;
  List<Map<String, dynamic>> equipmentDropdownOptions = [];
  List<Map<String, dynamic>> allSizeclothesDropdownOptions = [];
  Map<String, dynamic>? _sizeclothes;
  List<Map<String, dynamic>> sizeclothesDropdownOptions = [];
  Map<String, dynamic>? _typeclothes;
  List<Map<String, dynamic>> typeDropdownOptions = [];
  final _price = TextEditingController();
  List<String>? _imagePaths;

  @override
  void initState() {
    super.initState();
    getAllCondition();
    getAllEquipment();
    getAllTypeClothes();
    getAllSizeClothes();
    print(widget.id);
  }

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
            DropdownButtonFormField<Map<String, dynamic>>(
              hint: Text('Select Condition'),
              onChanged: (Map<String, dynamic>? newValue)  {
                setState(() {
                  _condition = newValue;
                });
              },
              items: conditionDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value){
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(value['name']),
                  );
              }).toList(),
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
              hint: Text('Select Equipment'),
              onChanged: (Map<String, dynamic>? newValue)  {
                setState(() {
                  _equipment = newValue;
                });
              },
              items: equipmentDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value){
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(value['name']),
                  );
              }).toList(),
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
              hint: Text('Select Type Clothes'),
              onChanged: (Map<String, dynamic>? newValue)  {
                setState(() {
                  _typeclothes = newValue;
                  _sizeclothes = null;
                  print(_sizeclothes);
                  print(_typeclothes!['id']);
                  sizeclothesDropdownOptions = allSizeclothesDropdownOptions.where((sizeclothes) => sizeclothes['type'] == _typeclothes!['id']).toList();
                });
              },
              items: typeDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value){
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(value['type']),
                  );
              }).toList(),
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
              key: UniqueKey(),
              hint: Text('Select Size Clothes'),
              value : _sizeclothes,
              onChanged: (Map<String, dynamic>? newValue)  {
                setState(() {
                  _sizeclothes = newValue;
                  print(_sizeclothes!['id']);
                });
              },
              items: sizeclothesDropdownOptions.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value){
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
                    createPostUserProduct();
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                      child:Text(
                        'Confirm sell your product  ',
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
  Future<void> getAllCondition() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/condition'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> condition = body.map((dynamic item) => {'id': item['id'], 'name': item['c_condition']}).toList();
      setState(() {
        conditionDropdownOptions = condition;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<void> getAllEquipment() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/post/equipment'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> equipment = body.map((dynamic item) => {'id': item['id'], 'name': item['c_equipment']}).toList();
      setState(() {
        equipmentDropdownOptions = equipment;
      });
    } else {
      throw Exception('Failed to load brands');
    }
  }
  Future<void> getAllSizeClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/AllNewSize'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> sizeclothes = body.map((dynamic item) => {'id': item['id'], 'name': item['size'], 'type': item['type_clothes']}).toList();
      setState(() {
        allSizeclothesDropdownOptions = sizeclothes;
        sizeclothesDropdownOptions = sizeclothes;
      });
    } else {
      throw Exception('Failed to load brands');
    }
    // print(sizeclothesDropdownOptions);
  }
    Future<void> getAllTypeClothes() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/clothes/AllNewType'),
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Map<String, dynamic>> typeclothes = body.map((dynamic item) => {'id': item['id'], 'type': item['clothes_type']}).toList();
      setState(() {
        typeDropdownOptions = typeclothes;
      });
    } else {
      throw Exception('Failed to load brands');
    }
    // print(typeDropdownOptions);
  }
    Future<void> pickFiles() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true
        );

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
    
    Future<void> createPostUserProduct() async{
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
      final decodedToken = JwtDecoder.decode(token);
      print(decodedToken['id']);
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4000/post/createPostUserProduct'),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String,String>{
          'user_id' :  decodedToken['id'].toString(),
          'clothes_id' : widget.id.toString(),
          'condition_id' : _condition!['id'].toString(),
          'equipment_id' : _equipment!['id'].toString(),
          'sizeclothes_id' : _sizeclothes!['name'].toString(),
          'typeclothes_id' : _typeclothes!['id'].toString(),
          'product_price' : _price.text
        })
      );

      if(response.statusCode == 200){
        print('User`s post created successed!');
        var data = jsonDecode(response.body);
        if(data['status'] == 'ok'){
          createImage(data!['postId']);
        }
      }else{
        print('Failed to create a user`s post');
      }
      }
  }
  Future<void> createImage(int postId) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:4000/post/createImage'));
      request.fields['postId'] = postId.toString();
      if (_imagePaths != null) {
        for (var imagePath in _imagePaths!) {
          request.files.add(await http.MultipartFile.fromPath('img_post', imagePath));
          print(imagePath);
        }
      }
      print(_imagePaths);
      print(request);

      var response = await request.send();
      print(response);
      if (response.statusCode == 200) {
        print('Clothes created successed!');
        response.stream.transform(utf8.decoder).listen((value) {
          var data = jsonDecode(value);
          if (data['status'] == 'ok') {
            Navigator.pop(context);
          }
        }); 
      } else {
        print('Failed to create many image');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

}
