import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_clothes_shop/component/component_part/successedPayment.dart';

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
    print(widget.getPrice);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => successedPayment())
                      );
                    }else{
                      
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
      print(_imagePath);
  }

}