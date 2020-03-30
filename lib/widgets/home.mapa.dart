import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps/widgets/locais.search.bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:location/location.dart';

import '../home.screen.dart';

class HomeMapa extends StatefulWidget {
  @override
  _HomeMapaState createState() => _HomeMapaState();
}

class _HomeMapaState extends State<HomeMapa> {
  Location location = Location();
  Set<Marker> marcadores = Set();
  Completer<GoogleMapController> _controller = Completer();
  bool pressionado = false;

  void tocouMapa(LatLng) {
    setState(() {
      if (pressionado == false) {
        pressionado = true;
      } else {
        pressionado = false;
      }
    });
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        pressionado = !pressionado;
      });
    });
  }

  void focarLocalizacao() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 0,
      target: LatLng(HomeScreen.localizacaoAtual.latitude,
          HomeScreen.localizacaoAtual.longitude),
      zoom: 17.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          zoomGesturesEnabled: true,
          compassEnabled: false,
          buildingsEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          indoorViewEnabled: true,
          trafficEnabled: true,
          mapType: MapType.normal,
          markers: marcadores,
          onTap: tocouMapa,
          initialCameraPosition: CameraPosition(
              target: LatLng(HomeScreen.localizacaoAtual.latitude,
                  HomeScreen.localizacaoAtual.longitude),
              zoom: 16.4746),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        pressionado == true
            ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0),
                  child: LocaisSearchBar(),
                ))
            : Container(),
        pressionado == true
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        width: 30.0,
                        child: CircularGradientButton(
                          elevation: 10.0,
                          child: Icon(
                            Icons.my_location,
                            size: 20.0,
                          ),
                          gradient: Gradients.backToFuture,
                          callback: focarLocalizacao,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 30.0,
                        width: 30.0,
                        child: CircularGradientButton(
                          elevation: 10.0,
                          child: Icon(
                            Icons.map,
                            size: 20.0,
                          ),
                          gradient: Gradients.backToFuture,
                          callback: focarLocalizacao,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
