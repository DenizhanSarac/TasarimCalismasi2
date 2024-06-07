import 'package:flutter/material.dart';
import 'package:tasarimc/components/my_button.dart';
import 'package:tasarimc/components/my_textfield.dart';
import 'package:tasarimc/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // text editing controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // sign user in method
  Future signUserUp(BuildContext context) async {
    await dotenv.load(fileName: '.env');
    final apiLogin = dotenv.env['API_REGISTER'] ?? 'default_api_register';
    String apiUrl = apiLogin;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
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
          content: const Text('Üye kaydı başarılı yönlendiriliyorsun.'),
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
          MaterialPageRoute(builder: (context) => LoginPage()),
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
          content: const Text('Kullanıcı adı veya mail adresi kullanılıyor.'),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
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
                height: 470,
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
                        'Kayıt Ol',
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

                      //email textfield
                      MyTextField(
                        controller: _emailController,
                        hintText: 'e-mail',
                        obscureText: false,
                      ),

                      const SizedBox(height: 10),

                      //password textfield
                      MyTextField(
                        controller: _passwordController,
                        hintText: 'şifre',
                        obscureText: true,
                      ),

                      const SizedBox(height: 25),

                      //sign in button
                      const SizedBox(height: 20),
                      MyButton(
                        onTap: () {
                          signUserUp(context);
                        },
                        text: 'Kayıt ol',
                      ),

                      const SizedBox(height: 50),
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
