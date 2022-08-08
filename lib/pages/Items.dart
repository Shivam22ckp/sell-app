import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellapp/service/database.dart';
import 'package:sellapp/service/shared_pref.dart';

class Items extends StatefulWidget {
  Items({Key? key}) : super(key: key);

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  String? id;
  Stream? soldStream;

  getMyInfoFromSharedPreference() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  getontheLoad() async {
    await getMyInfoFromSharedPreference();
    soldStream = await DatabaseMethods().getOwnItem(id!);
    setState(() {});
  }

  @override
  void initState() {
    getontheLoad();
    super.initState();
  }

  Widget galleryList() {
    return StreamBuilder(
        stream: soldStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  ds["Pic"],
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      ds["Name"],
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 69, 90, 152),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "Price :" + "\$" + ds["Price"],
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .runTransaction((Transaction
                                              myTransaction) async {
                                        await myTransaction.delete(snapshot
                                            .data.docs[index].reference);
                                      });
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 69, 90, 152),
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 227, 250),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Selling Items",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(height: 700, child: galleryList())
            ],
          ),
        ),
      ),
    );
  }
}
