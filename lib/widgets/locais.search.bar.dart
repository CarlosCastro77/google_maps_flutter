import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class LocaisSearchBar extends StatefulWidget {
  @override
  _LocaisSearchBarState createState() => _LocaisSearchBarState();
}

class _LocaisSearchBarState extends State<LocaisSearchBar> {
  @override
  Widget build(BuildContext context) {
    const GoogleApiKey = "AIzaSyBttdzZVhE-cjhbt7AuVnIGALqbZ9H42wQ";

    return Container(
      padding: EdgeInsets.only(top: 24.0, left: 5.0, right: 5.0),
      width: MediaQuery.of(context).size.width,
      height: 74.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        elevation: 5.0,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Pesquisar endereço",
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            )
          ],
        ),
        onPressed: () async {
          Prediction p = await PlacesAutocomplete.show(
              context: context,
              apiKey: GoogleApiKey,
              mode: Mode.overlay,
              language: "pt",
              hint: "Pesquisar endereço");
          //displayPrediction(p);
        },
      ),
    );
  }
}
