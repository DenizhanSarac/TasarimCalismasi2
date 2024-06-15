import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tasarimc/components/my_button.dart';
import 'package:tasarimc/components/my_textfield.dart';
import 'package:tasarimc/screens/dashboard.dart';
import 'package:tasarimc/screens/register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tasarimc/screens/reset_pass.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  // sign user in method
  Future signUserIn(BuildContext context) async {
    await dotenv.load(fileName: '.env');
    final apiLogin = dotenv.env['API_LOGIN'] ?? 'default_api_login';
    String apiUrl = apiLogin;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseData = jsonDecode(response.body);
      await prefs.setString('token', responseData['token']);
      prefs.setString('username', _usernameController.toString());
      prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } else {
      // Bir hata oluştu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'Kapat',
            onPressed: () {
              // Code to execute.
            },
          ),
          content: const Text('Kullanıcı adı veya şifre hatalı.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/resim/IMG_0966.jpg',
                ))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                child: Card(
                  elevation: 4.0,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Giriş Yap',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 115, 127, 143)),
                      ),
                      const SizedBox(height: 20),

                      //username textfield
                      MyTextField(
                        controller: _usernameController,
                        hintText: 'kullanıcı adı',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      //password textfield
                      MyTextField(
                        controller: _passwordController,
                        hintText: 'şifre',
                        obscureText: true,
                      ),

                      const SizedBox(height: 15),

                      //forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Resetpass(),
                                    ));
                              },
                              child: Text(
                                'Şifreni mi unuttun?',
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      //sign in button
                      MyButton(
                        onTap: (() {
                          signUserIn(context);
                        }),
                        text: 'Giriş Yap',
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hesabın yok mu?',
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                );
                              },
                              child: const Text(
                                ' Hesap oluştur.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
