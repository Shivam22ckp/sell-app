import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:sellapp/pages/Items.dart';
import 'package:sellapp/pages/buy.dart';
import 'package:sellapp/pages/sell.dart';
import 'package:sellapp/pages/signin.dart';
import 'package:sellapp/pages/sold_item.dart';
import 'package:sellapp/service/auth.dart';
import 'package:sellapp/service/shared_pref.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _picker = ImagePicker();
  File? selectedImage;
  String? name, pic, email;
  getMyInfofromsharedpreference() async {
    name = await SharedPreferenceHelper().getDisplayName();
    pic = await SharedPreferenceHelper().getUserProfileUrl();
    email = await SharedPreferenceHelper().getUserEmail();

    setState(() {});
  }

  doonthisLoad() async {
    await getMyInfofromsharedpreference();
  }

  @override
  void initState() {
    doonthisLoad();
    super.initState();
  }

  uploadPic() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageref =
          FirebaseStorage.instance.ref().child(addId);

      final UploadTask task = firebaseStorageref.putFile(selectedImage!);

      var downloadurl = await (await task).ref.getDownloadURL();
      SharedPreferenceHelper().saveUserProfileUrl(downloadurl);

      setState(() {});
    }
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image!.path);
      print(selectedImage);
    });
    await uploadPic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 227, 250),
      body: pic == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: selectedImage != null
                          ? Center(
                              child: Container(
                              height: 120,
                              width: 120,
                              child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(60),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.file(
                                        selectedImage!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ))),
                            ))
                          : Center(
                              child: Container(
                                height: 120,
                                width: 120,
                                child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(60),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: Image.network(
                                          pic!,
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black45,
                              size: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18.0),
                                ),
                                Text(
                                  name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.black45,
                              size: 30.0,
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 18.0),
                                ),
                                Text(
                                  email!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Sold()));
                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.sell_rounded,
                                color: Colors.black45,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Text(
                                "Sold Items",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black45,
                                size: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Buy()));
                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.shopping_bag,
                                color: Colors.black45,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Text(
                                "Bought Items",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black45,
                                size: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Items()));
                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.shopping_bag,
                                color: Colors.black45,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              Text(
                                "Selling Items",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black45,
                                size: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        AuthMethods().signOut().then((value) => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn())),
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.all(13),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 69, 90, 152),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Text(
                          "LogOut",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
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
