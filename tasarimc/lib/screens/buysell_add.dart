import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuySell extends StatefulWidget {
  const BuySell({super.key});

  @override
  _BuySellState createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> {
  final picker = ImagePicker();
  File? image;
  bool isIncome = false;
  bool isExpense = false;

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
    );
  }

  AppBar get _buildAppBar => AppBar(
    title: const Text("Kayıt Oluştur", style: TextStyle(fontSize: 25)),
    backgroundColor: Colors.grey[300],
    leading: const BackButton(color: Colors.black,),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25)
      )
    ),
  );

  Widget get _buildBody {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildFloatingActionButtons,
          SizedBox(height: height * 0.02),
          Expanded(
            child: Center(
              child: image == null
                  ? const Text('Fotoğraf seçilmedi.')
                  : Image.file(image!),
            ),
          ),
          SizedBox(height: height * 0.02),
          _buildFormField(label: 'Cihaz marka ve model', icon: Icons.mobile_friendly_sharp),
          SizedBox(height: height * 0.02),
          _buildFormField(label: 'Müşteri adı soyadı', icon: Icons.person_outline),
          SizedBox(height: height * 0.02),
          _buildFormField(label: 'Ücret', icon: Icons.money),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCheckbox('Gelir', isIncome, (value) {
                setState(() {
                  isIncome = value!;
                  if (isIncome) {
                    isExpense = false;
                  }
                });
              }),
              SizedBox(width: height * 0.02),
              _buildCheckbox('Gider', isExpense, (value) {
                setState(() {
                  isExpense = value!;
                  if (isExpense) {
                    isIncome = false;
                  }
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required IconData icon}) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget get _buildFloatingActionButtons {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAppIconButtonNewPhoto,
        SizedBox(width: height * 0.02),
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

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
