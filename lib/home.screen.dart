import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps/widgets/home.mapa.dart';
import 'package:google_maps/widgets/user.drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:location/location.dart';
import 'package:screen/screen.dart';

class HomeScreen extends StatefulWidget {
  static LocationData localizacaoAtual;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = Location();
  StreamSubscription<LocationData> localizacaoAtual;
  Completer<GoogleMapController> _controller = Completer();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    localizacaoAtual = location.onLocationChanged().listen((valor) {
      setState(() {
        HomeScreen.localizacaoAtual = valor;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    localizacaoAtual.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    return Scaffold(
      key: _drawerKey,
      body: HomeMapa(),
      floatingActionButton: Container(
        height: 40.0,
        width: 40.0,
        child: CircularGradientButton(
          heroTag: 'BotaoMenu',
          elevation: 10.0,
          child: Icon(
            Icons.more_horiz,
            size: 30.0,
          ),
          gradient: Gradients.backToFuture,
          callback: () {
            _drawerKey.currentState.openEndDrawer();
          },
        ),
      ),
      endDrawer: UserDrawer(),
    );
  }
}
