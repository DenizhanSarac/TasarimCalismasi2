import 'package:flutter/material.dart';
import 'package:tasarimc/components/my_button.dart';
import 'package:tasarimc/components/my_textfield.dart';

class Resetpass extends StatelessWidget {
  const Resetpass({super.key});

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
            image: AssetImage('assets/resim/IMG_0966.jpg',))
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [            

              SizedBox(
                height: 330,
                child: Card(
                  elevation: 4.0,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      const Text('Şifre sıfırlama bağlantısını göndermek için lütfen sisteme kayıtlı e-mail bilginizi giriniz.',style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 115, 127, 143)),),
                      const SizedBox(height: 30),


              //email textfield
              const MyTextField(
                controller: null,
                hintText: 'e-mail',
                obscureText: false,
              ),


              //sign in button
              const SizedBox(height: 40),
              MyButton(onTap: () {
                signUserOn(context);
              }, text: 'Gönder',), 

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
  
  void signUserOn(BuildContext context) {}
}
