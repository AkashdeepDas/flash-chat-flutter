import 'package:flash_chat/constants.dart';
import 'package:flash_chat/custom_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show PlatformException;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String errorTextMail = '';
  String errorTextPass = '';

  Function onPressed() {
    return () async {
      setState(() {
        showSpinner = true;
      });
      if (this.email == null) {
        errorTextMail = "Email Field Can't Be Empty!";
      } else {
        errorTextMail = null;
      }
      if (this.password == null) {
        errorTextPass = "Password Field Can't Be Empty!";
      } else {
        errorTextPass = null;
      }

      if (this.email != null && this.password != null) {
        try {
          final newUser = await _auth.createUserWithEmailAndPassword(
              email: this.email, password: this.password);
          if (newUser != null) {
            Navigator.pushNamed(context, ChatScreen.id);
          }
        } on PlatformException catch (e) {
          print(e.code);
          if (e.code == "ERROR_INVALID_EMAIL") {
            errorTextMail = 'Enter a valid email address';
          } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
            errorTextMail = 'Email Already in Use';
          } else {
            errorTextMail = null;
          }

          if (e.code == "ERROR_WEAK_PASSWORD") {
            errorTextPass = "Password should be at least 6 characters";
          } else {
            errorTextPass = null;
          }
        } finally {
          showSpinner = false;
        }
      }
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: kHeroTag,
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    this.email = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Enter your email',
                    errorText: errorTextMail,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    this.password = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: "Enter your password",
                    errorText: errorTextPass,
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                CustomButton(
                  buttonColor: Colors.blueAccent,
                  buttonText: Text(
                    'Register',
                  ),
                  onPressed: onPressed(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
