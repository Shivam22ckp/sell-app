// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sellapp/pages/chat_screen.dart';
import 'package:sellapp/pages/payment_id.dart';
import 'package:sellapp/service/database.dart';
import 'package:sellapp/service/shared_pref.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  String pic,
      pic1,
      pic2,
      name,
      desc,
      price,
      condition,
      adminusername,
      adminname,
      adminimage,
      adminid,
      adminpublished,
      adminsecret;
  DetailPage(
      {required this.desc,
      required this.name,
      required this.pic,
      required this.price,
      required this.pic1,
      required this.pic2,
      required this.condition,
      required this.adminimage,
      required this.adminname,
      required this.adminusername,
      required this.adminid,
      required this.adminpublished,
      required this.adminsecret});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? myName, myProfilePic, myUserName, myEmail, id, myPublished, mySecret;
  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    id = await SharedPreferenceHelper().getUserId();
    myPublished = await SharedPreferenceHelper().getUserPublished();
    mySecret = await SharedPreferenceHelper().getUserSecret();
    print(myName);
    setState(() {});
  }

  getontheLoad() async {
    await getMyInfoFromSharedPreference();
    setState(() {});
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    Stripe.publishableKey = widget.adminpublished;

    getontheLoad();
    super.initState();
  }

  late Map<String, dynamic> paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 242, 242),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  child: PageView(
                    children: [
                      Image.network(
                        widget.pic,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      Image.network(
                        widget.pic1,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      Image.network(
                        widget.pic2,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 230,
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.0),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              var chatRoomId = getChatRoomIdByUsernames(
                                  myUserName!, widget.adminusername);
                              Map<String, dynamic> chatRoomInfoMap = {
                                "users": [myUserName, widget.adminusername]
                              };
                              DatabaseMethods()
                                  .createChatRoom(chatRoomId, chatRoomInfoMap);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          widget.adminusername,
                                          widget.adminname,
                                          widget.adminimage)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Icon(
                                Icons.chat_outlined,
                                color: Color.fromARGB(255, 69, 90, 152),
                                size: 30.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "£" + widget.price,
                        style: TextStyle(
                            color: Color.fromARGB(255, 69, 90, 152),
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "Condition :",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            widget.condition,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        widget.desc,
                        style: TextStyle(color: Colors.black54, fontSize: 18.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: 720, right: 10, left: 10, bottom: 20.0),
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.bottomRight,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "£" + widget.price,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 60.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        makePayment();
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
                          "Place Order",
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
          ),
        ]),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(
          widget.price, 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntentData['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        print('payment intent' + paymentIntentData['id'].toString());
        print('payment intent' + paymentIntentData['client_secret'].toString());
        print('payment intent' + paymentIntentData['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        Map<String, dynamic> addSoldItem = {
          "Images": widget.pic,
          "Name": widget.name,
          "Price": widget.price,
        };
        DatabaseMethods().addSoldItem(widget.adminid, addSoldItem);
        DatabaseMethods().addBuyItem(id!, addSoldItem);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': widget.price,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' + widget.adminsecret,
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
}
