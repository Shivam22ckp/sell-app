import 'package:flutter/material.dart';
import 'package:sellapp/pages/Home.dart';
import 'package:sellapp/pages/chat.dart';
import 'package:sellapp/pages/profile.dart';
import 'package:sellapp/pages/sell.dart';

class Bottomnav extends StatefulWidget {
  double distancefilter;
  String pricefilter;
  Bottomnav({required this.distancefilter, required this.pricefilter});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTabIndex = 0;
  late List<Widget> pages;

  late Widget currentPage;

  late Home home;
  late Sell sell;
  late Chat chat;
  late Profile profile;

  @override
  void initState() {
    super.initState();
    home = Home(
      distancefilter: widget.distancefilter,
      pricefilter: widget.pricefilter,
    );
    sell = Sell();
    chat = Chat();
    profile = Profile();
    pages = [home, sell, chat, profile];
    currentPage = home;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.black),
          showSelectedLabels: true,
          fixedColor: Colors.black,
          unselectedLabelStyle: TextStyle(color: Colors.black),
          showUnselectedLabels: true,
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
              currentPage = pages[index];
            });
          },
          currentIndex: currentTabIndex,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              activeIcon: Icon(Icons.home_outlined,
                  color: Color.fromARGB(255, 69, 90, 152)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sell),
              label: "Sell",
              activeIcon:
                  Icon(Icons.sell, color: Color.fromARGB(255, 69, 90, 152)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: "Chat",
              activeIcon: Icon(Icons.chat_outlined,
                  color: Color.fromARGB(255, 69, 90, 152)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              activeIcon:
                  Icon(Icons.person, color: Color.fromARGB(255, 69, 90, 152)),
            )
          ]),
      body: currentPage,
    );
  }
}
