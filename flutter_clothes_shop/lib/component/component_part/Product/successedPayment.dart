import 'package:flutter/material.dart';

import 'package:flutter_clothes_shop/component/tabMenu.dart';

class successedPayment extends StatefulWidget {
  const successedPayment({super.key});

  @override
  State<successedPayment> createState() => _successedPaymentState();
}

class _successedPaymentState extends State<successedPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: Image.asset(
              "assets/images/coat_hanger.png",
              fit: BoxFit.cover,
              height: 155,
              width: 155,
            ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.verified_outlined,
                      color: Colors.green,
                      size: 50,
                      ),
                  ),
                  Container(
                    child: Text(
                      'Thank you for your payment',
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                          ),
                      ),
                  )
                ],
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                width: 350,
                  child: Text(
                  "Please waiting we`re verify your payment. If your payment corrent, Please waiting verify your product"
                  ),
              ),
            ),
            
            Container(
              child: Material(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.5)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TabMenu())
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                      child:Text(
                        'Return to Home',
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
}