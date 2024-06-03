import 'package:flutter/material.dart';


class BuySellList extends StatefulWidget {
  const BuySellList({super.key});

  @override
  _BuySellListState createState() => _BuySellListState();
}

class _BuySellListState extends State<BuySellList> {
  final List<Product> products = [
    Product(urun: 'iPhone 13', ucret: 150.0, gelirgider:'gelir'),
    Product(urun: 'iPhone SE', ucret: 200.0, gelirgider:'gider'),
  ];

  // Tıklanmış öğeleri takip etmek için bir Set kullanıyoruz
  Set<int> _selectedIndices = Set<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Listesi'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isSelected = _selectedIndices.contains(index);

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                product.urun,
                style: TextStyle(
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                'Gelir-Gider: ${product.gelirgider}\nÜcret: ${product.ucret}', 
                style: TextStyle(
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedIndices.remove(index);
                  } else {
                    _selectedIndices.add(index);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class Product {
  final String urun;
  final double ucret;
  final String gelirgider;

  Product({required this.urun, required this.ucret, required this.gelirgider});
}
