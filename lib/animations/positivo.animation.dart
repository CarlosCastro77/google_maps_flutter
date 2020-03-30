import 'package:flare_flutter/flare_actor.dart';
import "package:flutter/material.dart";

import '../home.screen.dart';

class PositivoAnimation extends StatefulWidget {
  @override
  _PositivoAnimationState createState() => _PositivoAnimationState();
}

class _PositivoAnimationState extends State<PositivoAnimation> {
  void initState() {
    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Center(
            child: FlareActor(
              "assets/Success.flr",
              animation: "play",
            ),
          ),
        ),
      ),
    );
  }
}
