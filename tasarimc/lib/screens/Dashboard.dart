// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tasarimc/screens/TechnicalAdd.dart';


class Dashboard extends StatelessWidget{
  const Dashboard({super.key});
 
 

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const Text("Anasayfa",style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.grey[300],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25)
          )
        ),

        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,color: Colors.black,),
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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Technical()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey[300],),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.add_circle_outline,size: 50,color: Colors.black),
              SizedBox(height: 10),
              Text("Teknik Servis",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.black,fontSize: 25, )),
            ],),
            ),
          ),
          //Teknik servisteki ürünleri listele.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Technical()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.amber,),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.list,size: 50,color: Colors.white),
              SizedBox(height: 10),
              Text("Teknik Servis",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 25, )),
            ],),
            ),
          ),
          //Alıp satılan ürünleri ekle.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Technical()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.amber,),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.add_circle_outline,size: 50,color: Colors.white),
              SizedBox(height: 10),
              Text("Teknik Servis",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 25, )),
            ],),
            ),
          ),
          //Alıp satılan ürünleri listele.
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Technical()));
            },
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.amber,),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.list,size: 50,color: Colors.white),
              SizedBox(height: 10),
              Text("Teknik Servis",style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white,fontSize: 25, )),
            ],),
            ),
          ), 
        ],
        ),
      ),
    );
    
  }
  
  
}