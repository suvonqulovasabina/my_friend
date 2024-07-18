import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_friend/util/app_lat_long.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'api_service.dart';

class MapScreen extends StatefulWidget {
  final String long;
  final String lat;
  final String image;
  const MapScreen({super.key, required this.long, required this.lat, required this.image});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final List<MapObject> mapObjects = [];

  void getBranches() async {
    final result = await ApiService().getBranches();
    for (var element in result.data.data[0].openedStores) {
      print(element.name);
      //print();
      mapObjects.add(PlacemarkMapObject(
          mapId: MapObjectId(element.id.toString()),
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
              scale: 0.8,
              image: BitmapDescriptor.fromAssetImage('assets/btn.png'))),
          point: Point(
              latitude: double.parse(element.lat),
              longitude: double.parse(element.long))));
    }
    // _moveToCurrentLocation(double.parse(result.data.data.first.openedStores.first.lat), double.parse(result.data.data.first.openedStores.first.long));
    /*setState(() {

    });*/
  }


  Future<void> _moveToCurrentLocation(double lat, double lon) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: lat,
            longitude: lon,

          ),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      var l=double.parse(widget.lat);
      var d=double.parse(widget.long);
      location = AppLatLong(lat:l  , long: d);
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location.lat,location.long);
  }
  @override
  void initState() {

   _fetchCurrentLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: YandexMap(
            onMapCreated: (controller){
              mapControllerCompleter.complete(controller);
            },
            onMapTap: (point){
              print('LAT ----------------------');
              print(point.latitude);
            },

            onObjectTap: (geoObject){
              print('NAMEEE -[-------------------');
              print(geoObject.name);
            },
            zoomGesturesEnabled: true,
            mapObjects: mapObjects /*[
          PlacemarkMapObject(
            onTap: (object, point) {
              print('Object tappeppp');
              print(object.mapId.value);
            },
            text: PlacemarkText(
                text: "BUTTON", style: PlacemarkTextStyle(size: 12,placement: TextStylePlacement.bottom)),
            mapId: MapObjectId('154'),
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
                scale: 0.8,
                image: BitmapDescriptor.fromAssetImage('assets/btn.png'))),
            point: Point(latitude: 41.311081, longitude: 69.240562))

        ],*/
        )
    );
  }
}
