import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class DevMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: RamoMap(),
    ));
  }
}

class RamoMap extends StatefulWidget {
  State createState() => _RamoState();
}

class _RamoState extends State<RamoMap> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Maps');

  GeoFlutterFire geo = GeoFlutterFire();

  Set<Marker> _markers = HashSet<Marker>();

  // statefull Data
  //BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100.0);
  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(100);
  Stream<dynamic> query;

  StreamSubscription subscription;

  int _markeridcounter = 0;
  build(context) {
    return Stack(children: [
      Text('GOOGLE MAPS'),
      GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(10.724385052445099, 122.55735211174608), zoom: 15),
        onMapCreated: _onMapCreated,
        markers: _markers,
        onTap: (point) {
          _addMarker(point);
        },
        myLocationEnabled: true,
      ),
      Positioned(
        bottom: 50,
        left: 10,
        child: Slider(
            min: 100.0,
            max: 500.0,
            divisions: 4,
            value: radius.value,
            label: 'Radius ${radius.value}km',
            onChanged: (value) {
              print('Value changed $value');
              _updateQuery(value);
            }),
      )
    ]);
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _startQuery();
    _animateToUser();
  }

  _addMarker(LatLng point) async {
    final String markerIdVal = 'marker_id_val_$_markeridcounter';
    _markeridcounter++;

    setState(() {
      print('Marker | lat ${point.latitude} long ${point.longitude}');

      _markers.add(Marker(markerId: MarkerId(markerIdVal), position: point));

      _addGeoPoint(point);
    });
    // final GoogleMapController controller = await _controller.future;
    // var marker = Marker(
    //   position: controller.getLatLng(screenCoordinate)
    // );
  }

  _updateMarkersfromQuery(marker) {
    print('RECIEVED Marker from query | lat ${marker.position}');
    final String markerIdVal = 'Marker # $_markeridcounter';
    _markeridcounter++;
    setState(() {
      print('SETSTATE MARKER | lat ${marker.position}');
      _markers.add(
          Marker(markerId: MarkerId(markerIdVal), position: marker.position));
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print('Called UpdateMarkers');
    print(documentList);
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data()['position']['geopoint'];
      double distance = document.data()['distance'];
      var marker = Marker(
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarker,
        // infoWindow: InfoWindow('$distance kilometers from query center'),
        //infoWindowText: InfoWindowText('Magic Marker', '$distance kilometers from query center')
      );

      _updateMarkersfromQuery(marker);
    });
  }

  // void _updateMarkers(List<DocumentSnapshot> documentlist) async {
  //   //   final GoogleMapController controller = await _controller.future;
  //   print(documentlist);

  //   //  controller;
  //   documentlist.forEach((DocumentSnapshot document) {
  //     GeoPoint pos = document.data()['position']['geopoint'];
  //     double distance = document.data()['distance'];
  //     final String markerIdVal = '$distance kilometers from query center';

  //     setState(() {
  //       print(
  //           'GETTING MARKERS FROM QUERY | lat ${pos.latitude} long ${pos.longitude}');

  //       _markers.add(Marker(
  //           markerId: MarkerId(markerIdVal),
  //           position: LatLng(pos.latitude, pos.longitude)));
  //     });
  //   });
  // }

  _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    // Make a referece to firestore
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: userCollection).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    }).listen(_updateMarkers);
    //.listen(_updateMarkers);
  }

  _updateQuery(value) {
    setState(() {
      radius.add(value);
      _startQuery();
    });
  }

  _animateToUser() async {
    print('animate to user!');
    final GoogleMapController controller = await _controller.future;
    var pos = await location.getLocation();
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 17.0),
      ),
    );
  }

  Future<DocumentReference> _addGeoPoint(point) async {
    //var pos = await location.getLocation();
    GeoFirePoint pointFinal =
        geo.point(latitude: point.latitude, longitude: point.longitude);

    return await userCollection
        .add({'position': pointFinal.data, 'counterval': _markeridcounter});
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }
}
