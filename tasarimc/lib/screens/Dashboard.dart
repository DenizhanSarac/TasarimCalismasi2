// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tasarimc/screens/buysell_add.dart';
import 'package:tasarimc/screens/buysell_list.dart';
import 'package:tasarimc/screens/gelirgider.dart';
import 'package:tasarimc/screens/login_screen.dart';
import 'package:tasarimc/screens/technical_add.dart';
import 'package:tasarimc/screens/technical_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserData();
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anasayfa",
            style: TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 139, 30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              logOut(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Çıkış yap"),
                value: 1,
              )
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 40, crossAxisSpacing: 30),
          children: [
            //Teknik servis kaydı oluştur.
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Technical()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 139, 30),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 50, color: Color.fromARGB(255, 255, 255, 255)),
                    SizedBox(height: 10),
                    Text("Teknik Servis",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
            ),
            //Teknik servisteki ürünleri listele.
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TechList(username: _username.toString())));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 139, 30),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text("T.S. Liste",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
            ),
            //Alıp satılan ürünleri ekle.
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BuySell()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 139, 30),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text("Alım-Satım",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
            ),
            //Alıp satılan ürünleri listele.
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BuySellList(username: _username.toString())));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 139, 30),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text("A.S. Liste",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GelirGider()));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 139, 30),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list, size: 50, color: Colors.white),
                    SizedBox(height: 10),
                    Text("Gelir-Gider",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 25,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
