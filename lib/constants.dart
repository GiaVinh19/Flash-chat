import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.blueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.blueAccent, width: 2.0),
  ),
);

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.hint, this.onChange, this.obscureText = false, this.keyboard});
  final Function onChange;
  final String hint;
  final bool obscureText;
  final TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboard,
      textAlign: TextAlign.center,
      obscureText: obscureText,
      onChanged: onChange,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}

class CustomPadding extends StatelessWidget {
  CustomPadding({this.name, this.onPress, this.hue});
  final Function onPress;
  final String name;
  final Color hue;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: name,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          color: hue,
          borderRadius: BorderRadius.circular(30.0),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: onPress,
            minWidth: 200.0,
            height: 42.0,
            child: Text(name),
          ),
        ),
      ),
    );
  }
}

class Flasher extends StatelessWidget {
  Flasher({this.animation});
  final dynamic animation;

  @override
  Widget build(BuildContext context) {
    if (animation != 1.0) {
      return Text(
        ((animation * 100).toInt()).toString() + "%",
        style: TextStyle(
            fontSize: 45.0, fontWeight: FontWeight.w900, color: Colors.white),
      );
    } else {
      return ColorizeAnimatedTextKit(
          speed: Duration(milliseconds: 420),
          repeatForever: true,
          text: ["Flash Chat"],
          textStyle: TextStyle(
              fontSize: 45.0, fontWeight: FontWeight.w900, color: Colors.white),
          colors: [
            Colors.white,
            Colors.white,
            Colors.purple,
            Colors.blue,
            Colors.yellow,
            Colors.red,
          ],
          textAlign: TextAlign.start,
          alignment: AlignmentDirectional.topStart);
    }
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.msg, this.name, this.position, this.hue, this.bubbleDirection});

  final List<String> msg;
  final List<String> name;
  final List<CrossAxisAlignment> position;
  final List<Color> hue;
  final List<double> bubbleDirection;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: name.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: position[index],
                children: [
                  Text(
                    name[index],
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Material(
                    color: hue[index],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(0 + bubbleDirection[index]),
                        topRight: Radius.circular(30 - bubbleDirection[index])),
                    elevation: 5.0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        msg[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
