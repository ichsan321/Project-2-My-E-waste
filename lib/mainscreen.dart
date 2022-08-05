import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytolongbeli/tab_screen2.dart';
import 'package:mytolongbeli/tab_screen3.dart';
import 'package:mytolongbeli/tab_screen4.dart';
import 'package:mytolongbeli/user.dart';
import 'tab_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      TabScreen(user: widget.user),
      TabScreen2(user: widget.user),
      TabScreen3(user: widget.user),
      TabScreen4(user: widget.user),
    ];
  }

  String $pagetitle = "My Tolong Beli";

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.cyanAccent));
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
             color: Colors.lightBlue,),
            
            title: Text("Store" ,style: TextStyle(color: Colors.white)),
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.lightBlue, ),
            title: Text("Posted Store" ,style: TextStyle(color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event,  color: Colors.lightBlue,),
            title: Text("My Store" ,style: TextStyle(color: Colors.white)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.lightBlue, ),
            title: Text("Profile" ,style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}