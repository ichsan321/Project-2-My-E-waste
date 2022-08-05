import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mytolongbeli/mainscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytolongbeli/user.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:place_picker/place_picker.dart';

File _image;
String pathAsset = 'asset/images/cart.png';
String urlUpload = "http://michannael.com/mytolongbeli/php/upload_job.php";
String urlgetuser = "http://michannael.com/mytolongbeli/php/get_user.php";

TextEditingController _jobcontroller = TextEditingController();
final TextEditingController _desccontroller = TextEditingController();
final TextEditingController _pricecontroller = TextEditingController();
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position _currentPosition;
String _currentAddress = "Searching your current location...";

class NewJob extends StatefulWidget {
  final User user;

  const NewJob({Key key, this.user}) : super(key: key);

  @override
  _NewJobState createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('REQUEST STORE'),
            backgroundColor: Colors.cyan,
          ),
          body: SingleChildScrollView(
            child: Container(
        
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage('asset/images/background1.jpg'),
                    fit: BoxFit.fill)),
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: CreateNewJob(widget.user),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class CreateNewJob extends StatefulWidget {
  final User user;
  CreateNewJob(this.user);

  @override
  _CreateNewJobState createState() => _CreateNewJobState();
}

class _CreateNewJobState extends State<CreateNewJob> {
  String defaultValue = 'Pickup';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () => mainBottomSheet(context),
            child: Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image:
                    _image == null ? AssetImage(pathAsset) : FileImage(_image),
                fit: BoxFit.fill,
              )),
            )),
        Text('Click on cart above to take store picture'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.time_to_leave),
                  onPressed: _automotive),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.fastfood),
                  onPressed: _changeFood),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.smartphone),
                  onPressed: _smartphone),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.add_shopping_cart),
                  onPressed: _groceries),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.child_friendly),
                  onPressed: _babies),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.usb),
                  onPressed: _electronicAccesories),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.devices_other),
                  onPressed: _electronicDevice),
              new IconButton(
                  iconSize: 40,
                  icon: new Icon(Icons.border_color),
                  onPressed: _schooll),
            ],
          ),
        ),
        TextField(
            controller: _jobcontroller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(10.0))),
                child: Icon(
                  Icons.title,
                  color: Colors.lightBlue,
                )),
            hintText: "Store title",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
           ),
            SizedBox(
          height: 5,
        ),
        TextField(
            controller: _pricecontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(10.0))),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.lightBlue,
                )),
            hintText: "Item price",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
           ),
           
        SizedBox(
          height: 5,
        ),
        TextField(
            controller: _desccontroller,
             keyboardType: TextInputType.text,
            textInputAction: TextInputAction.previous,
            maxLines: 3,
               decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16.0),
            prefixIcon: Container(
                padding: const EdgeInsets.only(top: 48.0, bottom: 16.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(10.0))),
                child: Icon(
                  Icons.info,
                  color: Colors.lightBlue,
                )),
            hintText: "Item Description",
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.cyan.withOpacity(0.8),
          ),
           ),
    
        SizedBox(
          height: 5,
        ),
        GestureDetector(
            onTap: _loadmap,
            child: Container(
              alignment: Alignment.topLeft,
              child: Text("Store Location",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Icon(Icons.location_searching),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(_currentAddress),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
          InkWell(
                   child: Container(
                     width: 300,
                     height: 50,
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
                              onTap: (_onAddJob),
                              child: Center(
                                child: Text("Request New Store",
                                    style: TextStyle(
                                        color: Colors.white,// LOGIN Name
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 2.0)),//for the space of the text
                              ),
                            ),
                          ),
                        ),
                      ),
      ],
    );
  }

  // void _choose() async {
  // _image =
  //   await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 400);
  //setState(() {});
  //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //}

  void _onAddJob() {
    if (_image == null) {
      Toast.show("Please take picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_jobcontroller.text.isEmpty) {
      Toast.show("Please enter store title", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_pricecontroller.text.isEmpty) {
      Toast.show("Please enter item price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Requesting...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());
    print(_currentPosition.latitude.toString() +
        "/" +
        _currentPosition.longitude.toString());

    http.post(urlUpload, body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
      "jobtitle": _jobcontroller.text,
      "jobdesc": _desccontroller.text,
      "jobprice": _pricecontroller.text,
      "latitude": _currentPosition.latitude.toString(),
      "longitude": _currentPosition.longitude.toString(),
      "credit": widget.user.credit,
      "rating": widget.user.rating
    }).then((res) {
      print(urlUpload);
      Toast.show(res.body, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (res.body.contains("success")) {
        _image = null;
        _jobcontroller.text = "";
        _pricecontroller.text = "";
        _desccontroller.text = "";
        pr.dismiss();
        print(widget.user.email);
        _onLogin(widget.user.email, context);
      } else {
        pr.dismiss();
        Toast.show(res.body + ". Please reload", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        // print(_getCurrentLocation);
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
      });
    } catch (e) {
      print(e);
    }
  }

  void _onLogin(String email, BuildContext ctx) {
    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            radius: dres[4],
            credit: dres[5],
            rating: dres[6]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadmap() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyCGNpWzJBpO0o75BJjebMGagglst5EB62E")));

    // Handle the result in your way
    print("MAP SHOW:");
    print(result);
  }

  void _automotive() {
    _jobcontroller.text = "Automotive & Motorcycle";
  }

  void _changeFood() {
    _jobcontroller.text = "Food";
  }

  void _smartphone() {
    _jobcontroller.text = "Smartphone";
  }

  void _groceries() {
    _jobcontroller.text = "Groceries";
  }

  void _babies() {
    _jobcontroller.text = "Babies & Toys";
  }

  void _electronicAccesories() {
    _jobcontroller.text = "Electronic Accesories";
  }

  void _electronicDevice() {
    _jobcontroller.text = "Electronic Device";
  }

  void _schooll() {
    _jobcontroller.text = "Scholl Accesories";
  }

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _createTile(context, 'Camera', Icons.camera, _action1),
              _createTile(context, 'Gallery', Icons.photo_album, _action2),
            ],
          );
        });
  }

  ListTile _createTile(
      BuildContext context, String name, IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  //Take profile picture from camera
  _action1() async {
    print('action camera');
    File _cameraImage;

    _cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (_cameraImage != null) {
      //Avoid crash if user cancel picking image
      _image = _cameraImage;
      setState(() {});
    }
  }

  //Take profile picture from gallery
  _action2() async {
    print('action gallery');
    File _galleryImage;

    _galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_galleryImage != null) {
      //Avoid crash if user cancel picking image
      _image = _galleryImage;
      setState(() {});
    }
  }
}
