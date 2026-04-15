t 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State
<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  File? _image;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      
setState(() {});
    });
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> _takePicture() async {
    if (controller!.value.isTakingPicture) {
      return;
    }

    try {
      final XFile file = await controller!.takePicture();
      _image = File(file.path);

      // Embed geotag in photo
      final img.Image image = img.decodeImage(_image!.readAsBytesSync())!;
      final img.Image updatedImage = img.drawImage(image, img.drawString(
          image,
          img.arial_24,
          10,
          10,
          'Lat: ${_currentPosition!.latitude}, Long: ${_currentPosition!.longitude}',
          color: img.getColor(0, 0, 0)));

      // Append draw image to photo
      final File updatedFile = File('${_image!.path}_updated.jpg');
      await updatedFile.writeAsBytes(img.encodeJpg(updatedImage));

      setState(() {
        _image = updatedFile;
      });
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}