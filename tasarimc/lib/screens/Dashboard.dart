// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tasarimc/screens/buysell_add.dart';
import 'package:tasarimc/screens/technical_add.dart';
import 'package:tasarimc/screens/technical_list.dart';


class Dashboard extends StatelessWidget{
  const Dashboard({super.key});
 
 

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const Text("Anasayfa",style: TextStyle(fontSize: 25, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 255, 139, 30),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25)
          )
        ),

        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,color: Colors.white,),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text("Çıkış yap"))
        
        ],
        ),
        ],
        
        ),


      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 40,crossAxisSpacing: 30),
        children: [
          //Teknik servis kaydı oluştur.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Technical()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 255, 139, 30),),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.add_circle_outline,size: 50,color: Color.fromARGB(255, 255, 255, 255)),
              SizedBox(height: 10),
              Text("Teknik Servis",style: TextStyle(fontWeight: FontWeight.w300, color: Color.fromARGB(255, 255, 255, 255),fontSize: 25, )),
            ],),
            ),
          ),
          //Teknik servisteki ürünleri listele.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const TechList()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 255, 139, 30),),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.list,size: 50,color: Colors.white),
              SizedBox(height: 10),
              Text("T.S. Liste",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 25, )),
            ],),
            ),
          ),
          //Alıp satılan ürünleri ekle.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const BuySell()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 255, 139, 30),),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.add_circle_outline,size: 50,color: Colors.white),
              SizedBox(height: 10),
              Text("Alım-Satım",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 25, )),
            ],),
            ),
          ),
          //Alıp satılan ürünleri listele.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Technical()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 255, 139, 30),),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.list,size: 50,color: Colors.white),
              SizedBox(height: 10),
              Text("A.S. Liste",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 25, )),
            ],),
            ),
          ), 
        ],
        ),
      ),
    );
    
  }
  
  
}