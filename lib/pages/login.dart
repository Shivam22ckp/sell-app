import 'package:flutter/material.dart';
import 'package:sellapp/pages/signin.dart';
import 'package:sellapp/pages/signup.dart';

class LogIn extends StatefulWidget {
  LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 196, 76),
      body: (SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "images/gym.png",
                    height: 370,
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 69, 68, 68),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "I'm New",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "---------- Already a member? --------",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 179, 179, 179),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
