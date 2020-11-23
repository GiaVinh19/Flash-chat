import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static final String id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email;
  String password;
  bool loadingSign = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loadingSign,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              CustomTextField(
                hint: "Enter your email",
                keyboard: TextInputType.emailAddress,
                onChange: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              CustomTextField(
                hint: "Enter your password",
                obscureText: true,
                onChange: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              CustomPadding(
                name: "Register",
                hue: Colors.blueAccent,
                onPress: () async {
                  setState(() {
                    loadingSign = true;
                  });
                  try {
                    final UserCredential newUser =
                        await auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      loadingSign = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      loadingSign = false;
                    });
                    if (e.code == 'invalid-email') {
                      print(e.code);
                      Alert(
                          context: context,
                          title: "Error",
                          desc: "This email address is invalid.",
                          buttons: [
                            DialogButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ]).show();
                    } else if (e.code == 'weak-password') {
                      print(e.code);
                      Alert(
                          context: context,
                          title: "Error",
                          desc: "This password is insecure.",
                          buttons: [
                            DialogButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ]).show();
                    } else if (e.code == 'email-already-in-use') {
                      print(e.code);
                      Alert(
                          context: context,
                          title: "Error",
                          desc: "This email is already registered.",
                          buttons: [
                            DialogButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ]).show();
                    } else {
                      Alert(
                          context: context,
                          title: "Error",
                          desc:
                              "Please enter a valid email address and password.",
                          buttons: [
                            DialogButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ]).show();
                    }
                  } catch (e) {
                    setState(() {
                      loadingSign = false;
                    });
                    Alert(
                        context: context,
                        title: "Error",
                        desc:
                            "Please enter a valid email address and password.",
                        buttons: [
                          DialogButton(
                            child: Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          )
                        ]).show();
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
