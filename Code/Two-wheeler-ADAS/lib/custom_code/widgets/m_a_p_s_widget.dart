// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:mapmyindia_gl/mapmyindia_gl.dart' as lsg show LatLng;

import 'package:mapmyindia_gl/mapmyindia_gl.dart';

// class MAPSWidget extends StatefulWidget {
  // const MAPSWidget({
  //   Key? key,
  //   this.width,
  //   this.height,
  // }) : super(key: key);

  // final double? width;
  // final double? height;

//   @override
//   _MAPSWidgetState createState() => _MAPSWidgetState();
// }

// class _MAPSWidgetState extends State<MAPSWidget> {
//   mappls.MapmyIndiaMapController? mapController;

//   @override
//   void initState() {
//     super.initState();

  //   // Set the MapMyIndia SDK configurations when the widget is created
  //   mappls.MapmyIndiaAccountManager.setMapSDKKey("9ecfc7e4bcb6da425d8941adf2383839");
  //   mappls.MapmyIndiaAccountManager.setRestAPIKey("9ecfc7e4bcb6da425d8941adf2383839");
  //   mappls.MapmyIndiaAccountManager.setAtlasClientId(
  //       "96dHZVzsAusKgu2yHZK5-aY0cac29gie6NsuzimJlEreNNug01KScoJwWwLA6wPqLMkUT4Z14ObEAzNPa8RdIA==");
  //   mappls.MapmyIndiaAccountManager.setAtlasClientSecret(
  //       "lrFxI-iSEg-CNpsO-sWoH91q22uIcIIJru4KA5r2NB-ADLPh0e3i2c9wtpnNF0c_6N41CXivQ9CsQLBH5Ir2KHf_J_B0qerI");
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: mappls.MapmyIndiaMap(
//         initialCameraPosition: mappls.CameraPosition(
//           target: mappls.LatLng(19.048996361609245, 72.90004858515886),
//           zoom: 14.0,
//         ),
//           myLocationEnabled: true,    
//   myLocationTrackingMode: mappls.MyLocationTrackingMode.TrackingGPS,    
//         onMapCreated: (map) => {
//           mapController = map,
//         },
//       ),
//     );
//   }

// }



///////////////////////////// MAIN APP ///////////////////////////



import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mappls_flutter_sdk/utils/color.dart';
// import 'package:mappls_flutter_sdk/utils/polyline.dart';
import 'package:mappls_gl/mappls_gl.dart' as mappls;
// import 'package:mapmyindia_gl/mapmyindia_gl.dart' as mappls;
import 'dart:math' show pow, sin, cos, pi, sqrt;

// class MyColor
class MyColor {
  static const colorPrimary = Color(0xFFE52629);
  static const colorPrimaryDark = Color(0xFFE7392A);
  static const colorAccent = Color(0xFFEC672C);
}








// // Class PolyLine



class Polyline {
  //  --- Instance Variables
  bool get isPolyline => true;
  String? encodedString;
  List<List<double>>? decodedCoords = [];
  int precision = 5;
  double? distance;
  String unit = 'kilometers';

  //  --- Named Constructors
  /// .Decode(str, p)
  Polyline.decode({this.encodedString, this.precision = 5}) {
    decodedCoords = _decode(encodedString!, precision);
    encodedString = encodedString;
  }

  /// .Encode(coords, p)
  Polyline.encode({this.decodedCoords, this.precision = 5}) {
    encodedString = _encodePoly(decodedCoords!, precision);
    decodedCoords = decodedCoords;
  }

  // .Distance(str, u)
  Polyline.distance({this.encodedString, this.unit = 'kilometers'}) {
    distance = _length(encodedString!, unit);   // _length sets decodedCoords
    encodedString = encodedString;
  }




  //  ------------- ENCODE & DECODE -------------

  /// Decodes encoded polyline string to a [latitude, longitude] coordinates list.
  /// @decode_poly Function
  /// @param {String} str
  /// @param {int} precision
  /// @returns {List<dynamic>}
  List<List<double>> _decode(String str, int precision) {
    int index = 0,
        lat = 0,
        lng = 0,
        shift = 0,
        result = 0;
    int? byte,
        latitudeChange,
        longitudeChange,
        factor = pow(10, precision).toInt();
    // ignore: omit_local_variable_types
    List<List<double>> coordinates = [];

    // Coordinates have variable length when encoded, so just keep
    // track of whether we've hit the end of the string. In each
    // loop iteration, a single coordinate is decoded.
    while (index < str.length) {
      // Reset shift, result, and byte
      byte = null;
      shift = 0;
      result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      latitudeChange = (((result & 1) == 1) ? ~(result >> 1) : (result >> 1));

      shift = result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      longitudeChange = ((result & 1) == 1 ? ~(result >> 1) : (result >> 1));

      lat += latitudeChange;
      lng += longitudeChange;

      coordinates.add([lat / factor, lng / factor]);
    }

    decodedCoords = coordinates;
    return coordinates;
  }

  /// Encodes the given [latitude, longitude] coordinates list to an encoded string.
  /// @encode_poly Function
  /// @param {List<dynamic>} coordinates
  /// @param {int} precision
  /// @returns {String}
  String _encodePoly(List<List<double>> coordinates, int precision) {
    // if (coordinates.length == null) {
    //   return '';
    // }

    int factor = pow(10, precision is int ? precision : 5).toInt();
    var output = _encode(coordinates[0][0], 0, factor) +
        _encode(coordinates[0][1], 0, factor);

    for (var i = 1; i < coordinates.length; i++) {
      var a = coordinates[i], b = coordinates[i - 1];
      output += _encode(a[0], b[0], factor);
      output += _encode(a[1], b[1], factor);
    }

    return output;
  }

  /// Returns the character string
  /// @param {double} current
  /// @param {double} previous
  /// @param {int} factor
  /// @returns {String}
  String _encode(double current, double previous, int factor) {
    final _current = (current * factor).round();
    final _previous = (previous * factor).round();

    var coordinate = _current - _previous;
    coordinate <<= 1;
    if (_current - _previous < 0) {
      coordinate = ~coordinate;
    }

    var output = '';
    while (coordinate >= 0x20) {
      output += String.fromCharCode((0x20 | (coordinate & 0x1f)) + 63);
      coordinate >>= 5;
    }
    output += String.fromCharCode(coordinate + 63);
    return output;
  }


  /// Calculate the distance of the polyline. If radius is not provided, distance is flat, else distance is haversine distance
  /// NOTE: Support flat surface and sphere
  /// @param {string} polyline - The polyline to calculate from
  /// @param  String of 'meter' or 'kilometer' unit - returned unit value.
  /// @return {double} length - unit based on options.radius unit
  double _length(String polyline, String unit) {
    List<List<double>> decodedPolyline;
    decodedPolyline = _decode(polyline, 5);

    // setting class instance vars
    decodedCoords  = decodedPolyline;

    double distanceOfDecoded = 0;
    for (var i = 0; i < decodedPolyline.length - 1; i++) {
      final lat = [decodedPolyline[i][0], decodedPolyline[i][1]];
      final lon = [decodedPolyline[i + 1][0], decodedPolyline[i + 1][1]];

      distanceOfDecoded += _haversineDistance(lat, lon);
    }

    if(unit == 'meter') return  distanceOfDecoded * 1000;
    if(unit == 'kilometer') return distanceOfDecoded;

    distance = distanceOfDecoded;
    return distanceOfDecoded;
  }

  //  ------------- HAVERSINE -------------

  /// Convert Degree to Radian
  /// @param {double} deg - Degree
  /// @return {double} Radia
  double _degToRad(double deg) {
    return (deg * pi) / 180;
  }


  /// Calculate haversine of a number
  /// @param {double} number - input number
  /// @return {double} haversine
  double _haversine(double number) {
    if(number == null) {
      throw TypeError();
    }
    return pow(sin(number / 2), 2).toDouble();
  }


  /// Calculate the haversine distance between 2 points
  /// on the Earth, using radius of 6371 km
  /// @param {List<double>} point1 - lat, lon are mandatory
  /// @param {List<double>} point2 - lat, lon are mandatory
  /// @return {double} distance
  double _haversineDistance(List<double> _point1, List<double> _point2) {
    _point1.map((item) => item != null ?  _degToRad(item) : throw Exception('Value cannot be null'));
    _point2.map((item) => item != null ?  _degToRad(item) : throw Exception('Value cannot be null'));

    const radius = 6371;
    final point1 = [_point1[0], _point1[1] ];
    final point2 = [_point2[0], _point2[1] ];

    final a = _haversine(point2[0] - point1[0]);
    final b = cos(point1[0]) * cos(point2[0]) * _haversine(point2[1] - point1[1]);
    final distance = 2 * radius * sqrt(a + b);

    return distance;
  }
}

/////////PolyLine Finished


































// // Class MAPSWidget

class MAPSWidget extends StatefulWidget {
   const MAPSWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

   final double? width;
  final double? height;


  @override
  State<StatefulWidget> createState() {
    return _MAPSWidgetState();
  }

}

class _MAPSWidgetState extends State {

  static  final mappls.CameraPosition _kInitialPosition = mappls.CameraPosition(
    target: mappls.LatLng(28.594475, 77.202432),
    zoom: 10.0,
  );

  late mappls.MapplsMapController controller;
  List<String> profile = [
    mappls.DirectionCriteria.PROFILE_DRIVING,
    mappls.DirectionCriteria.PROFILE_BIKING,
    mappls.DirectionCriteria.PROFILE_WALKING,
  ];
  List<ResourceList> resource = [
    ResourceList(mappls.DirectionCriteria.RESOURCE_ROUTE, "Non Traffic"),
    ResourceList(mappls.DirectionCriteria.RESOURCE_ROUTE_ETA, "Route ETA"),
    ResourceList(mappls.DirectionCriteria.RESOURCE_ROUTE_TRAFFIC, "Traffic"),
  ];
  int selectedIndex = 0;
  late ResourceList selectedResource;
  mappls.DirectionsRoute? route;
  

  @override
  void initState() {
    super.initState();

        // Set the MapMyIndia SDK configurations when the widget is created
   mappls.MapplsAccountManager.setMapSDKKey("9ecfc7e4bcb6da425d8941adf2383839");
    mappls.MapplsAccountManager.setRestAPIKey("9ecfc7e4bcb6da425d8941adf2383839");
    mappls.MapplsAccountManager.setAtlasClientId(
        "96dHZVzsAusKgu2yHZK5-aY0cac29gie6NsuzimJlEreNNug01KScoJwWwLA6wPqLMkUT4Z14ObEAzNPa8RdIA==");
    mappls.MapplsAccountManager.setAtlasClientSecret(
        "lrFxI-iSEg-CNpsO-sWoH91q22uIcIIJru4KA5r2NB-ADLPh0e3i2c9wtpnNF0c_6N41CXivQ9CsQLBH5Ir2KHf_J_B0qerI");


      setState(() {
      selectedResource = resource[0];
    });



  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Expanded(
            child: Stack(children: [
              mappls.MapplsMap(
                initialCameraPosition: _kInitialPosition,
                onMapCreated: (map) =>
                {
                  controller = map,
                },
                onStyleLoadedCallback: () => {callDirection()},
              ),
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: DefaultTabController(
                        length: 3,
                        child: TabBar(
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.directions_car),
                              text: "Driving",
                            ),
                            Tab(
                              icon: Icon(Icons.directions_bike),
                              text: "Biking",
                            ),
                            Tab(
                              icon: Icon(Icons.directions_walk),
                              text: "Walking",
                            )
                          ],
                          onTap: (value) =>
                          {
                            setState(() {
                              selectedIndex = value;
                            }),
                            if (value != 0) {selectedResource = resource[0]},
                            callDirection()
                          },
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  selectedIndex == 0
                      ? Container(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: resource
                          .map((data) =>
                          Expanded(
                              child: RadioListTile(
                                  title: Text(
                                    data.text,
                                    style: const TextStyle(fontSize: 10,color: Colors.black),
                                  ),
                                  value: selectedResource,
                                  groupValue: data,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedResource = data;
                                    });
                                    callDirection();
                                  })))
                          .toList(),
                    ),
                  )
                      : Container()
                ],
              )
            ])),
        (route != null && route!.distance!=null && route!.duration!=null)
            ? Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Text(getDurationAndDistance(), style: const TextStyle(fontSize: 18,color: Colors.black)),
        )
            : Container()
      ]),
    );
  }


  String getDurationAndDistance() {
    return 'Distance :- ${getFormattedDistance(route!.distance!.floor())}\nTime :- ${getFormattedDuration(route!.duration!.floor())}';
  }

  String getFormattedDuration(int duration) {
    int min = (duration % 3600 / 60).floor();
    int hours =  (duration % 86400 / 3600).floor();
    int days = (duration / 86400).floor();
    if (days > 0) {
      return '$days ${(days > 1 ? "Days" : "Day")} $hours hr ${(min > 0 ? "$min min": "")}';
    } else {
      return (hours > 0 ? '$hours hr ${(min > 0 ? "$min min" : "")}': '$min min');
    }
  }

  String getFormattedDistance(int distance) {

    if ((distance / 1000) < 1) {
      return '$distance mtr.';
    }
    return '${(distance/ 1000).toStringAsFixed(2)} Km.';
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return controller.addImage(name, list);
  }


  callDirection() async {
    await addImageFromAsset("icon", "assets/images/custom-icon.png");

    controller.clearSymbols();
    controller.clearLines();
    setState(() {
      route = null;
    });
    try {
      mappls.DirectionResponse? directionResponse = await mappls.MapplsDirection(
          origin: const mappls.LatLng(30.73596, 76.77810),
          destination: const mappls.LatLng(28.554676, 77.186982),
          alternatives: false,
          steps: true,
          resource: selectedResource.value,
          profile: profile[selectedIndex])
          .callDirection();
      if (directionResponse != null &&
          directionResponse.routes != null &&
          directionResponse.routes!.isNotEmpty) {
        setState(() {
          route = directionResponse.routes![0];
        });
        Polyline polyline = Polyline.decode(
            encodedString: directionResponse.routes![0].geometry, precision: 6);
        List<mappls.LatLng>? latlngList = [];
        if (polyline.decodedCoords != null) {
          polyline.decodedCoords?.forEach((element) {
            latlngList.add(mappls.LatLng(element[0], element[1]));
          });
        }
        if (directionResponse.waypoints != null) {
          List<mappls.SymbolOptions> symbols = [];
          directionResponse.waypoints?.forEach((element) {
            symbols.add(mappls.SymbolOptions(geometry: element.location, iconImage: 'icon'),);
          });
          controller.addSymbols(symbols);
        }
        drawPath(latlngList);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
    }
  }

  void drawPath(List<mappls.LatLng>? latlngList) {
    controller.addLine(mappls.LineOptions(
      geometry: latlngList,
      lineColor: "#3bb2d0",
      lineWidth: 4,
    ));
    mappls.LatLngBounds latLngBounds = boundsFromLatLngList(latlngList);
    controller
        .animateCamera(mappls.CameraUpdate.newLatLngBounds(latLngBounds, top: 100, bottom: 20, left: 10, right: 10));
  }

  boundsFromLatLngList(List<mappls.LatLng>? list) {
    assert(list!=null && list.isNotEmpty);
    double? x0, x1, y0, y1;
    if(list!=null)
    {
    for (mappls.LatLng latLng in list) {
      if (x0 == null || x1 == null || y0 == null || y1 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    }
    
    else 
    print("Abe Hag Diya Idhar");

    return mappls.LatLngBounds(
        northeast: mappls.LatLng(x1!, y1!), southwest: mappls.LatLng(x0!, y0!));
  }
}

class ResourceList {
  final String value;
  final String text;

  ResourceList(this.value, this.text);
}
