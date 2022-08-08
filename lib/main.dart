import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sellapp/pages/Home.dart';
import 'package:sellapp/pages/bottomnav.dart';
import 'package:sellapp/pages/login.dart';
import 'package:sellapp/pages/sell.dart';
import 'package:sellapp/pages/signup.dart';
import 'package:sellapp/service/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Bottomnav(
                distancefilter: 5.0,
                pricefilter: "100",
              );
            } else {
              return LogIn();
            }
          },
        ));
  }
}
