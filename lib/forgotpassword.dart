import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytolongbeli/loginscreen.dart';
//import 'theme/theme.dart' as Theme;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ResetPassword());

final TextEditingController _securityCodeController = TextEditingController();
final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _newPasswordController2 = TextEditingController();

String _secureCode = "";
String _newPassword = "";
String _newPassword2 = "";

bool _isCodeMatch = false;
String urlResetPass =
    'http://michannael.com/mytolongbeli/php/forgot_password.php';
String _email = "";

class ResetPassword extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ResetPassword> {
 // static const String _themePreferenceKey = 'isDark';
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    _loadResetEmail();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: new Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _securityCodeController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Security Code',
                    icon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 100,
                      height: 50,
                      child: Text(
                        'Cancel',
                        style: new TextStyle(
                            fontSize: 20.0,
                           // color: Theme.darkThemeData.primaryColorDark
                            ),
                      ),
                     // color: Theme.darkThemeData.primaryColor,
                      elevation: 15,
                      onPressed: _cancel,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 100,
                      height: 50,
                      child: Text(
                        'OK',
                        style: new TextStyle(
                            fontSize: 20.0,
                            //color: Theme.darkThemeData.primaryColorDark
                            ),
                      ),
                    //  color: Theme.darkThemeData.primaryColor,
                      elevation: 15,
                      onPressed: _checkCode,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                    focusNode: focusNode,
                    enabled: _isCodeMatch,
                    controller: _newPasswordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true),
                TextField(
                  enabled: _isCodeMatch,
                  controller: _newPasswordController2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Re-type Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  minWidth: 150,
                  height: 50,
                  child: Text(
                    'Save',
                    style: new TextStyle(
                        fontSize: 20.0,
                        //color: Theme.darkThemeData.primaryColorDark
                        ),
                  ),
                 // color: Theme.darkThemeData.primaryColor,
                  elevation: 15,
                  onPressed: _updatePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadResetEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('resetPassEmail');

    print('Reset Password Email : $_email');
  }

  void _updatePassword() {
    _newPassword = _newPasswordController.text;
    _newPassword2 = _newPasswordController2.text;

    if (_isCodeMatch) {
      if (_newPassword == _newPassword2) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);

        print(_newPassword);

        pr.style(message: "Updating Password");
        pr.show();
        http.post(urlResetPass, body: {
          "email": _email,
          "newPassword": _newPassword,
        }).then((res) {
          print("Password update : " + res.body);
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          if (res.body == "success") {
            pr.dismiss();
            _securityCodeController.text = "";
            _newPasswordController.text = "";
            _newPasswordController2.text = "";

            _removePrefsExceptTheme();

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            pr.dismiss();
          }
        }).catchError((err) {
          pr.dismiss();
          print(err);
        });
      } else {
        Toast.show('Password doesn\'t match', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show('Enter Security Code', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _removePrefsExceptTheme() async {
   // bool theme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
  //  theme = prefs.getBool(_themePreferenceKey); //get theme value
    prefs.clear(); //clear preferences
    //prefs.setBool(_themePreferenceKey, theme); //put back theme in preferences
  }

  void _cancel() async {
    _removePrefsExceptTheme();

    _securityCodeController.text = "";
    _newPasswordController.text = "";
    _newPasswordController2.text = "";
    _isCodeMatch = false;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  void _checkCode() {
    _secureCode = _securityCodeController.text;

    _loadCode().then((onValue) {
      if (_secureCode == onValue) {
        setState(() {
          _isCodeMatch = true;
        });

        Toast.show('Correct Code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //500 milis delay, give time to enable password text field
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(focusNode);
        });
      } else {
        _isCodeMatch = false;
        Toast.show('Wrong Code', context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  Future<String> _loadCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('secureCode');
    print('Reset Pass : saved secure code : ' + code);
    return code;
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}