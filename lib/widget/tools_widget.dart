import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle lightsmallertext() {
    return TextStyle(
        color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.w500);
  }

  static Widget addfilter(String name){
    return  Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: AppWidget.lightsmallertext()
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      );
  }
}
