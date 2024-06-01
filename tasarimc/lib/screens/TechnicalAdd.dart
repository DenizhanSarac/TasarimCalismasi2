import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Technical extends StatefulWidget {
  const Technical({super.key});

  @override
  _TechnicalState createState() => _TechnicalState();
}

class _TechnicalState extends State<Technical> {
  final picker = ImagePicker();
  File? image;

  double get height => MediaQuery.of(context).size.height;

  Future<void> onImageButtonPressed(ImageSource source) async {
    try {
      await getImage(source);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
      floatingActionButton: _buildFloatingActionButtons,
    );
  }

  AppBar get _buildAppBar => AppBar(title: const Text('Image Picker Example'));

  Center get _buildBody {
    return Center(
      child: image == null
          ? const Text('Fotoğraf seçilmedi.')
          : Image.file(image!),
    );
  }

  Widget get _buildFloatingActionButtons {
    return Column(
      children: [
        const Spacer(),
        _buildAppIconButtonNewPhoto,
        SizedBox(height: height * 0.01),
        _buildAppIconButtonPickImageFromGallery,
      ],
    );
  }

  FloatingActionButton get _buildAppIconButtonNewPhoto {
    return FloatingActionButton.extended(
      label: const Text('Fotoğraf Çek'),
      icon: const Icon(Icons.photo_camera),
      onPressed: () => onImageButtonPressed(ImageSource.camera),
    );
  }

  FloatingActionButton get _buildAppIconButtonPickImageFromGallery {
    return FloatingActionButton.extended(
      label: const Text('Galeriden Seç'),
      icon: const Icon(Icons.photo_library),
      onPressed: () => onImageButtonPressed(ImageSource.gallery),
    );
  }
}
