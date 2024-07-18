import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_friend/list/list.dart';
import 'package:my_friend/my_shar.dart';
import 'package:my_friend/user.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../util/app_lat_long.dart';
import '../util/location_service.dart';

class RegisterScreen extends StatefulWidget {
  final storageRef = FirebaseStorage.instance;

  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late File selectedImage;
  late String imageUrl;
  var lat;
  var long;
  var text = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final mapControllerCompleter = Completer<YandexMapController>();

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

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
      lat = location.lat;
      long = location.long;
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location.lat, location.long);
  }

  @override
  void initState() {
    _initPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Keep the text at the top
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "My Friend",
                textAlign: TextAlign.right, // Align text to the right
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff003154),
                  fontFamily:
                      'Roboto', // Replace 'Roboto' with your desired font family
                ),
              ),
              Text("Lacation",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: Colors.indigoAccent)),
            ],
          ),
          Expanded(
            // This will expand to take the remaining space
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 32, right: 32, bottom: 56),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // x, y
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // To ensure the column takes minimum space
                  children: [
                    Container(
                        margin: EdgeInsets.all(16),
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                        decoration: InputDecoration(
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                          hintText: 'Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.clear,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        controller: text,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors.indigo, // Set the border color
                                    width: 2.0, // Set the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10), // Optional: Add border radius if needed
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        pickImageFromGallery();
                                      },
                                      child: const Icon(Icons.photo),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    const Text("Open Camera")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors.indigo, // Set the border color
                                    width: 2.0, // Set the border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10), // Optional: Add border radius if needed
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        pickImageFromGallery();
                                      },
                                      child: const Icon(
                                          Icons.photo_camera_rounded),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    const Text("Open Camera")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        var s = long.toString();
                        var l = lat.toString();

                        var user = AppUser(
                            long: s, lat: l, image: imageUrl, name: text.text);
                        setFirebase(user);

                        MyShare.setName(true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListScreen()),
                        );
                      },
                      child: Container(
                        height: 60,
                        margin: EdgeInsets.only(
                            left: 16, right: 16, bottom: 14, top: 32),
                        decoration: BoxDecoration(
                          color: Color(0xff003154),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // boshqa Container xususiyatlari
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setFirebase(AppUser user) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    users.add(user.toMap()).then((value) {
      print('User Added');
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }

  Future pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      selectedImage = File(pickedImage.path);
    });
    imageUrl = await uploadPhotoToFirebase(selectedImage);
  }

  Future _pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    setState(() {
      selectedImage = File(pickedImage.path);
    });
    imageUrl = await uploadPhotoToFirebase(selectedImage);
  }

  Future<String> uploadPhotoToFirebase(File photo) async {
    try {
      // Rasmni 50x50 piksel o'lchamda qayta o'lchash
      final image = await photo.readAsBytes();
      final resizedImage = await FlutterImageCompress.compressWithList(
        image,
        minHeight: 100,
        minWidth: 100,
        quality: 100,
      );
      final compressedFile = File('${photo.path}.jpg')
        ..writeAsBytesSync(resizedImage);

      String ref = 'images/img-${DateTime.now().toString()}.jpeg';
      final storageRef = FirebaseStorage.instance.ref().child(ref);
      UploadTask uploadTask = storageRef.putFile(compressedFile);
      var url = await uploadTask.then((task) => task.ref.getDownloadURL());
      return url;
    } on FirebaseException catch (e) {
      print(e);
      throw Exception('exaption${e.code}');
    }
  }
}
