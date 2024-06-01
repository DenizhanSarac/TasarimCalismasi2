import 'package:flutter/material.dart';
import 'package:tasarimc/components/my_button.dart';
import 'package:tasarimc/components/my_textfield.dart';
import 'package:tasarimc/screens/Dashboard.dart';
import 'package:tasarimc/screens/RegisterScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tasarimc/screens/ResetPass.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // sign user in method
  Future signUserIn(BuildContext context) async {
    const String apiUrl = 'http://192.168.10.4:3000/login';

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
          content:  const Text('Kullanıcı adı veya şifre hatalı.'),
          duration:  const Duration(milliseconds: 1500),
          width: 380.0, // Width of the SnackBar.
          padding:  const EdgeInsets.symmetric(
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
            image: AssetImage('assets/resim/IMG_0966.jpg',))), 
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SizedBox(
                height: 400,
                child: Card(
                  elevation: 4.0,
                  color: Colors.transparent,
                  margin:  const EdgeInsets.only(left: 20, right: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                       const Text('Giriş Yap',style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 115, 127, 143)),),
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
                padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                         MaterialPageRoute(
                          builder: (context) => const Resetpass(),
                         ));
                      },
                    
                    child: Text(
                      'Şifreni mi unuttun?',
                      style: TextStyle(
                        color: Colors.grey[900],
                        decoration: TextDecoration.underline
                      ),
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
                  
                }), text: 'Giriş Yap',
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
                      child:  const Text(
                        ' Hesap oluştur.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline
                        ),
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
