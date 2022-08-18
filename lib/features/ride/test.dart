import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utilities/constants/env.dart';
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
void thiss()async{
  Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.fullscreen, // Mode.overlay
      language: "en",
      components: [Component(Component.country, "pk")]);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Expanded(
          child: TextField(
            onChanged: (v){
              thiss();
            },
          ),
        ),
      ),
    );
  }
}
