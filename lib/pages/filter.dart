import 'package:flutter/material.dart';
import 'package:sellapp/pages/Home.dart';
import 'package:sellapp/pages/bottomnav.dart';

class Filter extends StatefulWidget {
  double distance;
  String price;
  Filter({required this.distance, required this.price});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  void initState() {
    value = widget.distance;
    values = RangeValues(50, double.parse(widget.price));
    super.initState();
  }

  RangeValues values = RangeValues(50, 100);
  double value = 30;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: Row(
            children: [
              SizedBox(
                width: 140,
              ),
              Text(
                "Filter",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel,
                  color: Color.fromARGB(255, 69, 90, 152),
                  size: 25.0,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "Price Range",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: RangeSlider(
            inactiveColor: Colors.grey,
            activeColor: Color.fromARGB(255, 69, 90, 152),
            min: 50,
            max: 300,
            divisions: 20,
            labels: RangeLabels(
                values.start.round().toString(), values.end.round().toString()),
            values: values,
            onChanged: (values) => setState(() {
              this.values = values;
            }),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "Distance (Km)",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Slider(
            inactiveColor: Colors.grey,
            activeColor: Color.fromARGB(255, 69, 90, 152),
            min: 1,
            max: 50,
            divisions: 20,
            label: value.round().toString(),
            value: value,
            onChanged: (value) => setState(() {
              this.value = value;
            }),
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Bottomnav(
                          distancefilter: value,
                          pricefilter: values.end.round().toString(),
                        )));
          },
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 69, 90, 152),
                borderRadius: BorderRadius.circular(18)),
            child: Text(
              "Apply Filter",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ]),
    );
  }
}
