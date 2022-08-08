import 'dart:ffi';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:random_string/random_string.dart';
import 'package:sellapp/pages/bottomnav.dart';
import 'package:sellapp/pages/payment_id.dart';
import 'package:sellapp/service/database.dart';
import 'package:sellapp/service/shared_pref.dart';

class Sell extends StatefulWidget {
  String? name, desc, price;
  File? image, image1, image2;
  Sell(
      {this.desc, this.image, this.image1, this.image2, this.name, this.price});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  Position? _currentUserLocation;
  String? myName, myProfilePic, myUserName, id, myPublished, mySecret;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    id = await SharedPreferenceHelper().getUserId();
    myPublished = await SharedPreferenceHelper().getUserPublished();
    mySecret = await SharedPreferenceHelper().getUserSecret();
    setState(() {});
  }

  getontheLoad() async {
    await getMyInfoFromSharedPreference();
    setState(() {});
  }

  @override
  void initState() {
    getontheLoad();
    getoncecurrentlocation();
    if (widget.price != null) {
      sellingcontroller.text = widget.desc!;
      namecontroller.text = widget.name!;
      image2 = widget.image1;
      image3 = widget.image2;
      selectedImage = widget.image;
      pricecontroller.text = widget.price!;
    }
    super.initState();
  }

  getoncecurrentlocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    _currentUserLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  TextEditingController sellingcontroller = new TextEditingController();
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();

  final _picker = ImagePicker();
  late String getsub;
  List<String> data = [];
  File? selectedImage, image2, image3;
  bool isSearching = false;
  List<String> items = [
    'Fitness Equipment',
    'Strength Equipment',
    'Weights & Barbells',
    'Storage',
    'Accessories'
  ];
  String? selectedItem;

  List<String> fitnessitems = [
    'Treadmills',
    'Exercise Bikes',
    'Cross Trainers',
    'Rowing Machines',
    'Battle Ropes',
    'Exercise Mats',
    'Punch Bags',
    'Resistance Bands',
    'Skipping Ropes',
  ];
  String? fitnessselectedItem;

  List<String> strengthitems = [
    'Back Machines',
    'Cable Machines',
    'Chest Machines',
    'Dip Stations',
    'Leg Machines',
    'Pull Up Bars',
    'Smith Machines',
    'Squat Racks',
    'Weight Benches'
  ];
  String? strengthItem;

  List<String> weightitems = [
    'Barbells and Collars',
    'Bumper Plates',
    'Dumbbells',
    'Kettlebells',
    'Weight Plates',
    'Wearble Weights'
  ];
  String? weightItem;

  List<String> storageitems = [
    'Bar Storage',
    'Dumbbell Storage',
    'Plate Storage',
    'Rack Mounted Storage',
    'Wall Mounted Storage'
  ];
  String? storageItem;

  List<String> accessoriesitem = [
    'Barbell Pads',
    'Clothings',
    'Gloves',
    'Grip Training',
    'Gym Floor Mats',
    'Weightlifting Belts'
  ];
  String? accessories;

  List<String> conditionitem = ['New', 'Like New', 'Good', 'Fair', 'Poor'];
  String? selectedItemcondition;

  List<String> deliveryitem = ['Collection', 'Delivery'];
  String? selectedItemdelivery;

  uploadPic() async {
    if (selectedImage != null &&
        selectedItemcondition != null &&
        namecontroller.text != "" &&
        sellingcontroller.text != "" &&
        pricecontroller.text != "") {
      print(getsub);
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageref =
          FirebaseStorage.instance.ref().child(addId);

      final UploadTask task = firebaseStorageref.putFile(selectedImage!);
      String addId1 = randomAlphaNumeric(10);
      Reference firebaseStorageref1 =
          FirebaseStorage.instance.ref().child(addId1);
      final UploadTask task1 = firebaseStorageref1.putFile(image2!);
      String addId2 = randomAlphaNumeric(10);
      Reference firebaseStorageref2 =
          FirebaseStorage.instance.ref().child(addId2);
      final UploadTask task2 = firebaseStorageref2.putFile(image3!);

      var downloadurl = await (await task).ref.getDownloadURL();
      var downloadurl1 = await (await task1).ref.getDownloadURL();
      var downloadurl2 = await (await task2).ref.getDownloadURL();

      String key = namecontroller.text.substring(0, 1).toUpperCase();

      Map<String, dynamic> userStatus = {
        "Name": namecontroller.text,
        "Pic": downloadurl,
        "Pic1": downloadurl1,
        "Pic2": downloadurl2,
        "Description": sellingcontroller.text,
        "Category": selectedItem == "Fitness Equipment"
            ? fitnessselectedItem
            : selectedItem == "Strength Equipment"
                ? strengthItem
                : selectedItem == "Weights & Barbells"
                    ? weightItem
                    : selectedItem == "Storage"
                        ? storageItem
                        : accessories,
        "Delivery": selectedItemdelivery,
        "Price": pricecontroller.text,
        "Condition": selectedItemcondition,
        "latitude": _currentUserLocation!.latitude,
        "longitude": _currentUserLocation!.longitude,
        "id": addId,
        "Key": key,
        "Username": myUserName,
        "AdminName": myName,
        "AdminPic": myProfilePic,
        "AdminId": id,
        "PublishedKey": myPublished,
        "SecretKey": mySecret,
      };
      DatabaseMethods()
          .addUserSellingItem(userStatus, getsub, addId)
          .then((value) {
        DatabaseMethods().addUserItem(userStatus, addId);
        Fluttertoast.showToast(
            msg: "Product Uploaded Successfully!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff5ac18e),
            textColor: Colors.white,
            fontSize: 16.0);
      }).then((value) {
        selectedImage = null;
        namecontroller.text = "";
        sellingcontroller.text = "";
        pricecontroller.text = "";
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Bottomnav(distancefilter: 5.0, pricefilter: "100")));
      });

      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "Fill all the data Completely!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff5ac18e),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage == null
          ? selectedImage = File(image!.path)
          : image2 == null
              ? image2 = File(image!.path)
              : image3 = File(image!.path);
      print(selectedImage);
      print(image2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 242, 242),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            children: [
              Text(
                "Sell",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      selectedImage != null
                          ? Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: DottedBorder(
                                  dashPattern: [10, 6],
                                  radius: Radius.circular(20),
                                  padding: EdgeInsets.all(20),
                                  color: Colors.black54,
                                  strokeWidth: 2,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Color.fromARGB(255, 69, 90, 152),
                                    size: 50.0,
                                  ),
                                ),
                              ),
                            ),
                      image2 != null
                          ? Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image2!,
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: DottedBorder(
                                  dashPattern: [10, 6],
                                  radius: Radius.circular(20),
                                  padding: EdgeInsets.all(20),
                                  color: Colors.black54,
                                  strokeWidth: 2,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Color.fromARGB(255, 69, 90, 152),
                                    size: 50.0,
                                  ),
                                ),
                              ),
                            ),
                      image3 != null
                          ? Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image3!,
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: DottedBorder(
                                  dashPattern: [10, 6],
                                  radius: Radius.circular(20),
                                  padding: EdgeInsets.all(20),
                                  color: Colors.black54,
                                  strokeWidth: 2,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Color.fromARGB(255, 69, 90, 152),
                                    size: 50.0,
                                  ),
                                ),
                              ),
                            ),
                    ]),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
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
                          controller: namecontroller,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write the name of your product..",
                              hintStyle: TextStyle(
                                  color: Colors.black87, fontSize: 18.0)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What are you selling?",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                      Container(
                        height: 140,
                        child: TextField(
                          controller: sellingcontroller,
                          maxLines: 6,
                          maxLength: 300,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Describe your item in as much detail as you can...",
                              hintStyle: TextStyle(
                                  color: Colors.black87, fontSize: 18.0)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        onChanged: (item) => setState(() {
                              selectedItem = item!;
                              data = selectedItem == "Fitness Equipment"
                                  ? fitnessitems
                                  : selectedItem == "Strength Equipment"
                                      ? strengthitems
                                      : selectedItem == "Weights & Barbells"
                                          ? weightitems
                                          : selectedItem == "Storage"
                                              ? storageitems
                                              : accessoriesitem;
                            }),
                        hint: Text(
                          "Category",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                        value: selectedItem,
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 22),
                                )))
                            .toList()),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        onChanged: (item) => setState(() {
                              selectedItem == "Fitness Equipment"
                                  ? fitnessselectedItem = item
                                  : selectedItem == "Strength Equipment"
                                      ? strengthItem = item
                                      : selectedItem == "Weights & Barbells"
                                          ? weightItem = item
                                          : selectedItem == "Storage"
                                              ? storageItem = item
                                              : accessories = item!;
                              getsub = item!;
                            }),
                        hint: Text(
                          "Sub-Category",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                        value: selectedItem == "Fitness Equipment"
                            ? fitnessselectedItem
                            : selectedItem == "Strength Equipment"
                                ? strengthItem
                                : selectedItem == "Weights & Barbells"
                                    ? weightItem
                                    : selectedItem == "Storage"
                                        ? storageItem
                                        : accessories,
                        items: data
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 22),
                                )))
                            .toList()),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        onChanged: (item) => setState(() {
                              selectedItemcondition = item!;
                            }),
                        hint: Text(
                          "Condition",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                        value: selectedItemcondition,
                        items: conditionitem
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 22),
                                )))
                            .toList()),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Delivery",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              onChanged: (item) => setState(() {
                                    selectedItemdelivery = item!;
                                  }),
                              hint: Text(
                                "Choose delivery options",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.0),
                              ),
                              value: selectedItemdelivery,
                              items: deliveryitem
                                  .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(fontSize: 22),
                                      )))
                                  .toList()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "Pound(£)",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: Container(
                              child: TextField(
                                controller: pricecontroller,
                                decoration: InputDecoration(
                                    hintText: "How much do you want for it?",
                                    hintStyle: TextStyle(
                                        color: Colors.black87, fontSize: 17.0)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  myPublished == null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentId(
                                  desc: sellingcontroller.text,
                                  image: selectedImage!,
                                  image1: image2!,
                                  image2: image3!,
                                  name: namecontroller.text,
                                  price: pricecontroller.text)))
                      : uploadPic();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 69, 90, 152),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(
                    "Sell it",
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
