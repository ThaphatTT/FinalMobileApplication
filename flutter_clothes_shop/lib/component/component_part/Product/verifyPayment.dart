import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_clothes_shop/component/component_part/Product/successedPayment.dart';

class verifyPayment extends StatefulWidget {
  final idPost;
  final int getPrice;
  const verifyPayment({super.key, required this.idPost, required this.getPrice});

  @override
  State<verifyPayment> createState() => _verifyPaymentState();
}

class _verifyPaymentState extends State<verifyPayment> {
  String? _imagePath;
  final _copytextcontroller = '1298098683';
  void copy() async {
    await FlutterClipboard.copy(_copytextcontroller);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        "📝 Bank's number Copied to clipboard",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 20),
    ));
  }
  @override
  Widget build(BuildContext context) {
    print(widget.idPost);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Payment'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/icon_bank.png',
                      width: 70,
                      height: 70,
                      ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          child: Text(
                            '1298098683',
                            ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            'นาย ธภัทร มีชัยธนา',
                            ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            'ธนาคารกสิกรไทย',
                            ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: (){
                        copy();
                      },
                    ),
                  )
                ],
              ),
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
                    if(_imagePath!=null){
                      createOrderUserBuyProduct();
                    }
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
  Future<void> pickFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
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
      print(_imagePath);
  }
  Future<void> createOrderUserBuyProduct() async{
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        final decodedToken = JwtDecoder.decode(token);
        print(decodedToken['id']);
        final response = await http.post(
          Uri.parse('http://10.0.2.2:4000/order/orderBuying'),
          headers: <String, String>{
            'Content-Type' : 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String,String>{
            'idUser' :  decodedToken['id'].toString(),
            'idPost' : widget.idPost.toString(),
            'total' : widget.getPrice.toString(),
        })
      );

      if(response.statusCode == 200){
        print('User`s post created successed!');
        var data = jsonDecode(response.body);
        if(data['status'] == 'ok'){
          createImagePayment(data!['orderId']);
        }
      }else{
        print('Failed to create a user`s post');
      }
      }
  }
  Future<void> createImagePayment(int orderId) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:4000/order/orderBuying/imgPayment'));
      request.fields['orderId'] = orderId.toString();
      var file = await http.MultipartFile.fromPath('img_payment', _imagePath!);
      request.files.add(file);
      print(_imagePath);
      print(request);

      var response = await request.send();
      print(response);
      if (response.statusCode == 200) {
        print('Image created successed!');
        response.stream.transform(utf8.decoder).listen((value) {
          var data = jsonDecode(value);
          if (data['status'] == 'ok') {
            changeStatusPost();
          }
        }); 
      } else {
        print('Failed to create a image');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
  Future<void> changeStatusPost() async{
    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/order/ChangeStatus'),
      headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'idPost' : widget.idPost.toString(),
        'p_status' : 'The product has been purchased',
    })
    );
    if(response.statusCode == 200){
      print('ImgPayment`s created successed!');
      var data = jsonDecode(response.body);
      if(data['status'] == 'ok'){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => successedPayment())
        );
      }
    }else{
      print('Failed to create a ImgPayment');
    }
  }
}