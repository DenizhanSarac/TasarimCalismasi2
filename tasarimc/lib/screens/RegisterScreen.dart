import 'package:flutter/material.dart';
import 'package:tasarimc/components/my_button2.dart';
import 'package:tasarimc/components/my_textfield.dart';
import 'package:tasarimc/screens/Dashboard.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),


              /*
              Text(
                'Kayıt ol',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              */
             
              //username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'kullanıcı adı',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              //email textfield
              MyTextField(
                controller: emailController,
                hintText: 'email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              //password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'şifre',
                obscureText: true,
              ),


             
              const SizedBox(height: 25),

              //sign in button
              MyButton2(
                onTap: (() {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashboard(),));
                }
              ),
              ),

              const SizedBox(height: 50),
/*
              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
*/
/*
              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // google button
                  SquareTile(imagePath: 'lib/images/google.png'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(imagePath: 'lib/images/apple.png')
                ],
              ),
*/
              //const SizedBox(height: 30),

              // not a member? register now

            ],
          ),
        ),
      ),
    );
  }
}