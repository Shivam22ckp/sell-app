import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sellapp/pages/product_detailpage.dart';
import 'package:sellapp/pages/sell.dart';
import 'package:sellapp/service/shared_pref.dart';

class PaymentId extends StatefulWidget {
  String name, desc, price;
  File image, image1, image2;
  PaymentId(
      {required this.desc,
      required this.image,
      required this.image1,
      required this.image2,
      required this.name,
      required this.price});
  @override
  State<PaymentId> createState() => _PaymentIdState();
}

class _PaymentIdState extends State<PaymentId> {
  TextEditingController publishedcontroller = new TextEditingController();
  TextEditingController secretcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            children: [
              Text(
                "Add the Payment Gateway",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Your Stripe Published Key",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Container(
                        child: TextField(
                          controller: publishedcontroller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write the Published Key here...",
                              hintStyle: TextStyle(
                                  color: Colors.black87, fontSize: 18.0)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Your Stripe Secret Key",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Container(
                        child: TextField(
                          controller: secretcontroller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write the Secret Key here...",
                              hintStyle: TextStyle(
                                  color: Colors.black87, fontSize: 18.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  SharedPreferenceHelper()
                      .saveUserPublished(publishedcontroller.text);
                  SharedPreferenceHelper()
                      .saveUserSecret(secretcontroller.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Sell(
                                desc: widget.desc,
                                image1: widget.image1,
                                image2: widget.image2,
                                image: widget.image,
                                name: widget.name,
                                price: widget.price,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 60,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 69, 90, 152),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
