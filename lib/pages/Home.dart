import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sellapp/pages/filter.dart';
import 'package:sellapp/pages/product_detailpage.dart';
import 'package:sellapp/service/database.dart';
import 'package:sellapp/service/shared_pref.dart';
import 'package:sellapp/widget/tools_widget.dart';

class Home extends StatefulWidget {
  double distancefilter;
  String pricefilter;
  Home({required this.distancefilter, required this.pricefilter});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isshowing = false;
  bool fitness = false,
      clicked = false,
      strength = false,
      weight = false,
      storage = false,
      accessories = false;
  String? name, pic, item;
  double distance = 5.0;
  var distanceImMeter;
  Position? _currentUserLocation;
  int? finaldistance;
  Stream? itemStream;
  bool searched = false;

  distanceCovered(double shoplatitude, double shoplongitude) async {
    distanceImMeter = await Geolocator.distanceBetween(
      _currentUserLocation!.latitude,
      _currentUserLocation!.longitude,
      shoplatitude,
      shoplongitude,
    );
    finaldistance = distanceImMeter!.round().toInt();
    distance = finaldistance! / 1000;
    print(_currentUserLocation!.latitude);
    print(distance);
    print(shoplatitude);
  }

  getoncecurrentlocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    _currentUserLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Widget shopList() {
    return StreamBuilder(
        stream: itemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 900,
                      mainAxisSpacing: 10.0),
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    distanceCovered(ds["latitude"], ds["longitude"]);

                    return widget.distancefilter >= distance &&
                            int.parse(widget.pricefilter) >=
                                int.parse(ds["Price"])
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          pic: ds["Pic"],
                                          name: ds["Name"],
                                          price: ds["Price"],
                                          desc: ds["Description"],
                                          condition: ds["Condition"],
                                          adminname: ds["AdminName"],
                                          adminusername: ds["Username"],
                                          adminimage: ds["AdminPic"],
                                          adminid: ds["AdminId"],
                                          adminpublished: ds["PublishedKey"],
                                          adminsecret: ds["SecretKey"],
                                          pic1: ds["Pic1"],
                                          pic2: ds["Pic2"])));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      child: Image.network(
                                        ds["Pic"],
                                        width: 200,
                                        height: 125,
                                        fit: BoxFit.fill,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "£" + ds["Price"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      child: Text(
                                        ds["Name"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(135, 11, 11, 11),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 0.0,
                          );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  getMyInfofromsharedpreference() async {
    name = await SharedPreferenceHelper().getDisplayName();
    pic = await SharedPreferenceHelper().getUserProfileUrl();
    print(name);
    setState(() {});
  }

  getThisUserinfo() async {
    await getMyInfofromsharedpreference();
    await getoncecurrentlocation();
    itemStream = searched
        ? await DatabaseMethods().getSearchedItem(item!)
        : await DatabaseMethods().getLocatedItems();
    setState(() {});
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      isshowing = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  void initState() {
    getThisUserinfo();
    super.initState();
  }

  Widget fitnesscategory() {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Treadmills";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Treadmills")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Exercise Bikes";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Exercise Bikes")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Cross Trainers";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Cross Trainers")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Rowing Machines";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Rowing Machines")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Battle Ropes";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Battle Ropes")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Exercise Mats";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Exercise Mats")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Punch Bags";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Punch Bags")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Resistance Bands";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Resistance Bands")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Skipping Ropes";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Skipping Ropes"))
      ],
    );
  }

  Widget strengthcategory() {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Back Machines";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Back Machines")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Cable Machines";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Cable Machines")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Chest Machines";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Chest Machines")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Dip Stations";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Dip Stations")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Leg Machines";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Leg Machines")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Pull Up Bars";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Pull Up Bars")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Smith Machines";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Smith Machines")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Squat Racks";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Squat Racks")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Weight Benches";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Weight Benches")),
      ],
    );
  }

  Widget weightcategory() {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Barbells and Collars";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Barbells and Collars")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Bumper Plates";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Bumper Plates")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Dumbbells";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Dumbbells")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Kettlebells";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Kettlebells")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Weight Plates";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Weight Plates")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Wearable Weights";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Wearable Weights")),
      ],
    );
  }

  Widget storagecategory() {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Wearble Weights";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Bar Storage")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Dumbbell Storage";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Dumbbell Storage")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Plate Storag";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Plate Storage")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Rack Mounted Storages";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Rack Mounted Storage")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Wall Mounted Storage";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Wall Mounted Storage")),
      ],
    );
  }

  Widget accessoriescategory() {
    return Column(
      children: [
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Barbell Pads";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Barbell Pads")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Clothings";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Clothings")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Gloves";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Gloves")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Grip Training";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Grip Training")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Gym Floor Mats";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Gym Floor Mats")),
        SizedBox(
          height: 20.0,
        ),
        GestureDetector(
            onTap: () async {
              isshowing = false;
              searched = true;
              clicked = false;
              item = "Weightlifting Belts";
              await getThisUserinfo();
              setState(() {});
            },
            child: AppWidget.addfilter("Weightlifting Belts")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 227, 250),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 45.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello, " + name!,
                          style: TextStyle(
                              color: Color.fromARGB(255, 67, 66, 66),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                    pic!,
                                    fit: BoxFit.cover,
                                  ))),
                        )
                      ],
                    ),
                    Text(
                      "Find Gym\nEquipment For You",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextField(
                                  onChanged: (value) {
                                    initiateSearch(value);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search for items',
                                      prefixIcon: Icon(Icons.search)),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              context: context,
                              builder: (context) => Filter(
                                distance: widget.distancefilter,
                                price: widget.pricefilter,
                              ),
                            );
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(12),
                            elevation: 5.0,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(
                                Icons.menu,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    isshowing
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              isshowing = true;
                              setState(() {});
                            },
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Categories",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 52, 48, 48),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20.0,
                    ),
                    isshowing
                        ? Column(
                            children: [
                              ListView(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  primary: false,
                                  shrinkWrap: true,
                                  children: tempSearchStore.map((element) {
                                    return buildResultCard(element);
                                  }).toList()),
                              SizedBox(
                                height: 10.0,
                              ),
                              clicked
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        strength = false;
                                        fitness = true;
                                        weight = false;
                                        storage = false;
                                        accessories = false;
                                        clicked = true;
                                        setState(() {});
                                      },
                                      child: AppWidget.addfilter(
                                          "Fitness Equipment")),
                              clicked
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              clicked
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        strength = true;
                                        fitness = false;
                                        weight = false;
                                        storage = false;
                                        accessories = false;
                                        clicked = true;
                                        setState(() {});
                                      },
                                      child: AppWidget.addfilter(
                                          "Strength Equipment")),
                              clicked
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              clicked
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        strength = false;
                                        fitness = false;
                                        weight = true;
                                        storage = false;
                                        accessories = false;
                                        clicked = true;
                                        setState(() {});
                                      },
                                      child: AppWidget.addfilter(
                                          "Weights & Barbells")),
                              clicked
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              clicked
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        strength = false;

                                        fitness = false;
                                        weight = false;
                                        storage = true;
                                        accessories = false;
                                        clicked = true;
                                        setState(() {});
                                      },
                                      child: AppWidget.addfilter("Storage")),
                              clicked
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              clicked
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        strength = false;
                                        fitness = false;
                                        weight = false;
                                        storage = false;
                                        accessories = true;
                                        clicked = true;
                                        setState(() {});
                                      },
                                      child:
                                          AppWidget.addfilter("Accessories")),
                              clicked
                                  ? SizedBox(
                                      height: 0.0,
                                    )
                                  : SizedBox(
                                      height: 20.0,
                                    ),
                              clicked
                                  ? fitness
                                      ? fitnesscategory()
                                      : strength
                                          ? strengthcategory()
                                          : weight
                                              ? weightcategory()
                                              : storage
                                                  ? storagecategory()
                                                  : accessories
                                                      ? accessoriescategory()
                                                      : Container()
                                  : Container()
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Near to you",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(height: 350, child: shopList()),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                    pic: data["Pic"],
                    name: data["Name"],
                    price: data["Price"],
                    desc: data["Description"],
                    condition: data["Condition"],
                    adminname: data["AdminName"],
                    adminusername: data["Username"],
                    adminimage: data["AdminPic"],
                    adminid: data["AdminId"],
                    adminpublished: data["PublishedKey"],
                    adminsecret: data["SecretKey"],
                    pic1: data["Pic1"],
                    pic2: data["Pic2"])));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                data["Pic"],
                height: 60,
                width: 60,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                data["Name"],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
