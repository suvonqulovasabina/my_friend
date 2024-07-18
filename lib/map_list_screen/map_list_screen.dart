import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../user.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class ListMapScreen extends StatefulWidget {
  final List<AppUser> list;
  const ListMapScreen({super.key, required this.list});

  @override
  State<ListMapScreen> createState() => _ListMapScreenState();
}

class _ListMapScreenState extends State<ListMapScreen> {
  late YandexMapController _mapController;
  List<PlacemarkMapObject> _placemarks = [];

  Future<void> _initMap() async {

    final placemarkFutures = widget.list.map((mate) async {
      final latitude = double.tryParse(mate.lat) ?? 0.0;
      final longitude = double.tryParse(mate.long) ?? 0.0;
      final bitmapImg = await _toBitmap(mate.image); // Assuming _toBitmap returns Uint8List

      return PlacemarkMapObject(
        mapId: MapObjectId(mate.name),
        point: Point(latitude: latitude, longitude: longitude),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: 0.8,
            image: BitmapDescriptor.fromBytes(bitmapImg),
          ),
        ),
      );
    }).toList();

    final placemarks = await Future.wait(placemarkFutures);

    setState(() {
      _placemarks = placemarks;
    });


    if (_placemarks.isNotEmpty) {
      final points = _placemarks.map((placemark) => placemark.point).toList();

      final northEast = Point(
        latitude: points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b),
        longitude: points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b),
      );
      final southWest = Point(
        latitude: points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b),
        longitude: points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b),
      );

      final boundingBox = BoundingBox(
        northEast: northEast,
        southWest: southWest,
      );

      await _mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: boundingBox.northEast,
            zoom: 18,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initMap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _initMap();
            },
            mapObjects: _placemarks,
          ),
          _buildMarkerOverlays(),
        ],
      ),
    );
  }

  Widget _buildMarkerOverlays() {
    return Stack(
      children: _placemarks.asMap().entries.map((entry) {
        final int index = entry.key;
        final placemark = entry.value;

        final imageUrl = widget.list[index].image;

        return Positioned(
          left: (placemark.point.longitude - 0.02) * MediaQuery.of(context).size.width,
          top: (placemark.point.latitude - 0.05) * MediaQuery.of(context).size.height,
          child: Container(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              )
                  : const Icon(Icons.image_not_supported),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<Uint8List> _toBitmap(String imagePath) async {
    print("imagePath: $imagePath");
    var request = await http.get(Uri.parse(imagePath));
    var bytes = request.bodyBytes;


    // Decode the image to manipulate it
    var image = img.decodeImage(bytes);

    // Resize the image to 24x24
    var resizedImage = img.copyResize(image!, width: 72, height: 72);

    // Encode the image back to bytes
    return Uint8List.fromList(img.encodePng(resizedImage));
  }




}
