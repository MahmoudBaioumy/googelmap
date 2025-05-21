import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class NewMap extends StatefulWidget {
  const NewMap({super.key});

  @override
  State<NewMap> createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> {
  var myMarkers = HashSet<Marker>();
  late BitmapDescriptor customMarker;
  List<Polyline> myPolyline = [];

  LatLng? apiLatLng; // <-- هنا هنخزن الإحداثيات الراجعة من الـ API

  @override
  void initState() {
    super.initState();
    createPolyline();
    fetchLocationFromApi(); // <-- استدعاء الـ API هنا
  }
// ========================== 🔥 fetchLocationFromApi 🔥 ========================== //

  Future<void> fetchLocationFromApi() async {
    try {
      final response = await http.get(Uri.parse('https://yourapi.com/location'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double lat = data['latitude'];
        double lng = data['longitude'];

        setState(() {
          apiLatLng = LatLng(lat, lng);
          myMarkers.add(Marker(
            markerId: MarkerId('fromApi'),
            position: apiLatLng!,
            infoWindow: InfoWindow(
              title: 'Location from API',
              snippet: 'This marker is from backend',
            ),
            // icon: customMarker,
          ));
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

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
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Google Map'), centerTitle: true),
      body: apiLatLng == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: apiLatLng!, // <-- من الـ API
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              print('Map created');
            },
            markers: myMarkers,
            /*
                  polygons: myPolygon(),
                  circles: myCircles,
                  polylines: myPolyline.toSet(),
                  */
          ),
        ],
      ),
    );
  }
}
