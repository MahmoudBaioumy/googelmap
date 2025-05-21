import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // -------------------------- empty array to add markers here -------------------------- //
  var myMarkers = HashSet<Marker>(); ///collection

late BitmapDescriptor customMarker;

  List<Polyline>  myPolyline=[];
// ========================== 🔥 fun of change marker to another icon 🔥 ========================== //

getCustomMarker()async{
  customMarker= await BitmapDescriptor.fromAssetImage(
  ImageConfiguration.empty,
      'assets/images/c2s.png'
  );
}
// -------------------------- make shape of polygon like road -------------------------- //
  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = [
      LatLng(37.43296265331129, -122.08832357078792),
      LatLng(37.43006265331129, -122.08832357078792),
      LatLng(37.43006265331129, -122.08332357078792),
      LatLng(37.43296265331129, -122.08332357078792),
    ];

    return {
      Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,
        strokeWidth: 1,
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.2), // اختياري لو عايز تلوّن البوليغون
      ),
    };
  }
  // -------------------------- this function to make circle -------------------------- //
  Set<Circle> myCircles = Set.from([
    Circle(
      circleId: CircleId('1'),
      center: LatLng(30.168270890711423, 31.450133798777962),
      radius: 1000,
      strokeWidth: 1,
    )
  ]);

// -------------------------- create Polyline -------------------------- //
  createPolyline() {
    myPolyline.add(
      Polyline(
        polylineId: PolylineId('1'),
        color: Colors.blue,
        width: 3,
        points: [
          LatLng(29.990000, 31.1490000),
          LatLng(29.999000, 31.1499000),
        ],
        // -------------------------- this make the line like .... to the location -------------------------- //
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(10),
        ]
      )
    );
  }
@override
  void initState() {
    super.initState();
    //getCustomMarker();
    createPolyline();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Google Map'), centerTitle: true),
      body: Stack(
        children: [
          // -------------------------- to open the Map -------------------------- //
          GoogleMap(
            // -------------------------- type of map -------------------------- //
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(29.990940, 31.149248),
              zoom: 14,
            ),
            // -------------------------- build the markers and add the position and add markers to array myMarkers  -------------------------- //
            onMapCreated: (GoogleMapController googleMapController) {
              setState(() {
                // -------------------------- markerId will back from api in the Future -------------------------- //
                myMarkers.add(Marker(markerId: MarkerId('1'),
                // -------------------------- it also markerId will back from api in the Future -------------------------- //
                position: LatLng(29.990940, 31.149248),
                  infoWindow: InfoWindow(
                    title: 'GermanTek',
                    // -------------------------- description -------------------------- //
                    snippet:'please share code on social' ,
                    // -------------------------- when you tab the marker do any thing like push to another page... -------------------------- //
                    onTap: () {
                        print('marker tab');
                    },
                  ),
                  // -------------------------- to change the icon of Marker  -------------------------- //
                 // icon: customMarker,
                ));
              });
            },
            /*
            polygons:myPolygon() ,
            circles: myCircles ,
            polylines: myPolyline.toSet(),
            */
            markers: myMarkers,

          ),
        ],
      ),
    );
  }
}
