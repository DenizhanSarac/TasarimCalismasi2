import 'dart:collection';
import 'dart:io';
import 'package:tasarimc/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasarimc/screens/Dashboard.dart';

class Technical extends StatefulWidget {
  const Technical({super.key});

  @override
  _TechnicalState createState() => _TechnicalState();
}

class _TechnicalState extends State<Technical> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final ImagePicker _picker = ImagePicker();
  String? _qrTextFromGallery;
  String? _username;

  final _cihazController = TextEditingController();
  final _musteriController = TextEditingController();
  final _ucretController = TextEditingController();

  // Değişkenleri tanımlayın
  String cihazMarkaModel = '';
  String musteriAdiSoyadi = '';
  String ucret = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cihazController.dispose();
    _musteriController.dispose();
    _ucretController.dispose();
    controller?.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await dotenv.load(fileName: '.env');
    final apiLogin = dotenv.env['API_ME'] ?? 'default_api_me';
    String apiUrl = apiLogin;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': token!,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _username = responseData['username'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı bilgileri getirilemedi!')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  Future<void> addTsVariable() async {
    await dotenv.load(fileName: '.env');
    final apiLogin = dotenv.env['API_ADD_TSV'] ?? 'default_api_tsv';
    String apiUrl = apiLogin;
    setState(() {
      cihazMarkaModel = _cihazController.text;
      musteriAdiSoyadi = _musteriController.text;
      ucret = _ucretController.text;
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _username,
        'model': cihazMarkaModel,
        'customer': musteriAdiSoyadi,
        'fee': ucret,
        'qr_code': _qrTextFromGallery,
      }),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'Kapat',
            onPressed: () {
              // Code to execute.
            },
          ),
          content: const Text('Ürün kaydı başarılı yönlendiriliyorsun.'),
          duration: const Duration(milliseconds: 1500),
          width: 380.0, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'Kapat',
            onPressed: () {
              // Code to execute.
            },
          ),
          content: const Text('Bu QR kullanılıyor.'),
          duration: const Duration(milliseconds: 1500),
          width: 380.0, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }

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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String? data = await QrCodeToolsPlugin.decodeFrom(pickedFile.path);
      setState(() {
        _qrTextFromGallery = data;
        image = File(pickedFile.path);
        print('Burada=> $_qrTextFromGallery');
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
        leading: const BackButton(
          color: Colors.black,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
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
          _buildFormField(
            label: 'Cihaz marka ve model',
            icon: Icons.mobile_friendly_sharp,
            controller: _cihazController,
          ),
          SizedBox(height: height * 0.02),
          _buildFormField(
              label: 'Müşteri adı soyadı',
              icon: Icons.person_outline,
              controller: _musteriController),
          SizedBox(height: height * 0.02),
          _buildFormField(
              label: 'Ücret', icon: Icons.money, controller: _ucretController),
          MyButton(onTap: addTsVariable, text: "Kaydet"),
        ],
      ),
    );
  }

  Widget _buildFormField(
      {required String label,
      required IconData icon,
      required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
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
      onPressed: () => getImage(ImageSource.gallery),
    );
  }
}
