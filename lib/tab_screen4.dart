import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:mytolongbeli/loginscreen.dart';
import 'package:mytolongbeli/payment.dart';
import 'package:mytolongbeli/registrationscreen.dart';
//import 'package:mytolongbeli/splashscreen.dart';
import 'package:mytolongbeli/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';


String urlgetuser = "http://michannael.com/mytolongbeli/php/get_user.php";
String urluploadImage =
    "http://michannael.com/mytolongbeli/php/upload_imageprofile.php";
String urlupdate = "http://michannael.com/mytolongbeli/php/update_profile.php";
File _image;
int number = 0;
String _value;

class TabScreen4 extends StatefulWidget {
  //final String email;
  final User user;
  TabScreen4({this.user});

  @override
  _TabScreen4State createState() => _TabScreen4State();
}

class _TabScreen4State extends State<TabScreen4> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.cyan));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          Image.asset(
                            "asset/images/background1.jpg",
                            fit: BoxFit.fitWidth,
                          ),
                          Column(
                            children: <Widget>[
                              Center(
                                child: Text("MyTolongBeli",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: _takePicture,
                                child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://michannael.com/mytolongbeli/profile/${widget.user.email}.jpg?dummy=${(number)}'")))),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  widget.user.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.user.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.phone_android,
                                      ),
                                      Text(widget.user.phone ??
                                          'not registered'),
                                    ],
                                  ),
                                ],
                              ),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.rate_review,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RatingBar(
                                    itemCount: 5,
                                    itemSize: 12,
                                    initialRating: double.parse(
                                        widget.user.rating.toString() ?? 0.0),
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.rounded_corner,
                                      ),
                                      Text("Store Radius " +
                                              widget.user.radius +
                                              "KM" ??
                                          'Job Radius 0 KM'),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.credit_card,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: Text("You have " +
                                                widget.user.credit +
                                                " Credit" ??
                                            "You have 0 Credit"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(_currentAddress),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.cyan,
                                child: Center(
                                  child: Text("My Profile ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ),
                            ],
                          ),
                        ]),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Column(
                      children: <Widget>[
                         InkWell(
                   child: Container(
                     width: 400,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_changeName),
                              child: Center(
                                child: Text("CHANGE NAME",
                                    style: TextStyle(
                                        color: Colors.black,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                     //   MaterialButton(
                       //   onPressed: _changeName,
                         // child: Text("CHANGE NAME"),
                        //),
                         SizedBox(
                  height: 10,
                ),
                           InkWell(
                   child: Container(
                     width: 350,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_changePassword),
                              child: Center(
                                child: Text("CHANGE PASSWORD",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                     //   MaterialButton(
                       //   onPressed: _changePassword,
                         // child: Text("CHANGE PASSWORD"),
                        //),
                            SizedBox(
                  height: 10,
                ),
                           InkWell(
                   child: Container(
                     width: 300,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_changePhone),
                              child: Center(
                                child: Text("CHANGE PHONE",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                       // MaterialButton(
                         // onPressed: _changePhone,
                          //child: Text("CHANGE PHONE"),
                        //),
                            SizedBox(
                  height: 10,
                ),
                  InkWell(
                   child: Container(
                     width: 250,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_changeRadius),
                              child: Center(
                                child: Text("CHANGE RADIUS",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                       // MaterialButton(
                         // onPressed: _changeRadius,
                          //child: Text("CHANGE RADIUS"),
                        //),
                            SizedBox(
                  height: 10,
                ),
                 InkWell(
                   child: Container(
                     width: 200,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_loadPayment),
                              child: Center(
                                child: Text("BUY CREDIT",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                       // MaterialButton(
                         // onPressed: _loadPayment,
                          //child: Text("BUY CREDIT"),
                        //),
                            SizedBox(
                  height: 10,
                ),
                 InkWell(
                   child: Container(
                     width: 150,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_registerAccount),
                              child: Center(
                                child: Text("REGISTER",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                      //  MaterialButton(
                        //  onPressed: _registerAccount,
                          //child: Text("REGISTER"),
                        //),
                            SizedBox(
                  height: 10,
                ),
                 InkWell(
                   child: Container(
                     width: 100,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_gotologinPage),
                              child: Center(
                                child: Text("LOG IN",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                     //   MaterialButton(
                       //   onPressed: _gotologinPage,
                         // child: Text("LOG IN"),
                        //),
                            SizedBox(
                  height: 10,
                ),
                 InkWell(
                   child: Container(
                     width: 80,
                     height: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [// For the gradient colour of the box
                                Color(0xFF17ead9),//cyan
                                Color(0xFF6078ea),//blue
                                Color(0xFFFF4081)//pink
                              ]),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(0.5),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (_gotologout),
                              child: Center(
                                child: Text("LOG OUT",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 15,
                                        letterSpacing: 1.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
                     //   MaterialButton(
                       //   onPressed: _gotologout,
                        //  child: Text("LOG OUT"),
                        //)
                      ],
                    ),
                  );
                }
              }),
        ));
  }

  void _takePicture() async {
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }

  void _changeRadius() {
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    TextEditingController radiusController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change new Radius (km)?"),
          content: new TextField(
              keyboardType: TextInputType.number,
              controller: radiusController,
              decoration: InputDecoration(
                labelText: 'new radius',
                icon: Icon(Icons.map),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
                shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                if (radiusController.text.length < 1) {
                  Toast.show("Please enter new radius ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "radius": radiusController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.radius = dres[4];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text("No"),
                shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change name for " + widget.user.name + "?"),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
               shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              },
            ),
            new FlatButton(
              child: new Text("No"),
                shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.user.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for " + widget.user.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
              },
            ),
            new FlatButton(
              child: new Text("No"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register new account?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _gotologout() async {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                print("LOGOUT");
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            new FlatButton(
              child: new Text("No"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

  void _loadPayment() async {
    // flutter defined function
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Buy Credit?"),
          content: Container(
            height: 100,
            child: DropdownExample(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () async {
                Navigator.of(context).pop();
                var now = new DateTime.now();
                var formatter = new DateFormat('ddMMyyyyhhmmss-');
                String formatted = formatter.format(now)+randomAlphaNumeric(10);
                print(formatted);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PaymentScreen(user:widget.user,orderid:formatted, val:_value)));
              },
            ),
            new FlatButton(
              child: new Text("No"),
                shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(20.0)),
                    color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('50 C Credit (RM10)'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('100 C Credit (RM20)'),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text('150 C Credit (RM30)'),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Credit',style: TextStyle(color: Colors.black),),
        value: _value,
      ),
    );
  }
}