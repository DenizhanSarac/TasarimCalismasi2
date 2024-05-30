// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Dashboard extends StatelessWidget{
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: const [
                SizedBox(height:150)
                ],
            ),
            
          ),
          Container(
            color: Colors.indigo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(200)
                )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard('Ürün Kayıt', CupertinoIcons.arrow_down_right, Colors.amber),
                  itemDashboard('Ürün Listesi', CupertinoIcons.list_bullet, Colors.green),
                  itemDashboard('İletişim', CupertinoIcons.envelope_circle, Colors.purple),
                  itemDashboard('', CupertinoIcons.zzz, Colors.brown),
                  itemDashboard('', CupertinoIcons.zzz, Colors.indigo),
                  itemDashboard('', CupertinoIcons.zzz, Colors.teal),

                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
  itemDashboard(String title, IconData iconData, Color background) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 5),
          color: Color.fromARGB(115, 63, 81, 181),
          spreadRadius: 3,
          blurRadius: 7
        )
      ]
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: Colors.white)
        ),
        const SizedBox(height: 8),
        Text(title.toUpperCase(), )
      ],
    ),
  );

}