import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuySellList extends StatefulWidget {
  const BuySellList({super.key});

  @override
  _BuySellListState createState() => _BuySellListState();
}

class _BuySellListState extends State<BuySellList> {
  final List<Product> products = [
    Product(urun: 'iPhone 13', ucret: 150.0, gelirgider: 'gelir'),
    Product(urun: 'iPhone SE', ucret: 200.0, gelirgider: 'gider'),
  ];

  Set<int> _selectedIndices = Set<int>();
  String _filter = 'Tümü';

  @override
  void initState() {
    super.initState();
    _loadSelectedIndices();
  }

  Future<void> _loadSelectedIndices() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedIndices = prefs.getStringList('selectedIndices') ?? [];
    setState(() {
      _selectedIndices = selectedIndices.map((index) => int.parse(index)).toSet();
    });
  }

  Future<void> _saveSelectedIndices() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedIndices', _selectedIndices.map((index) => index.toString()).toList());
  }

  double _calculateProfit() {
    double profit = 0.0;
    for (var i = 0; i < products.length; i++) {
      if (_selectedIndices.contains(i)) {
        if (products[i].gelirgider == 'gelir') {
          profit += products[i].ucret;
        } else if (products[i].gelirgider == 'gider') {
          profit -= products[i].ucret;
        }
      }
    }
    return profit;
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = _filterProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Listesi'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            items: <String>['Tümü', 'Satıldı', 'Satılmadı']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _filter = newValue!;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final productIndex = products.indexOf(product);
                final isSelected = _selectedIndices.contains(productIndex);

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
                          _selectedIndices.remove(productIndex);
                        } else {
                          _selectedIndices.add(productIndex);
                        }
                        _saveSelectedIndices();
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Toplam Kar: ${_calculateProfit().toStringAsFixed(2)} TL',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  List<Product> _filterProducts() {
    if (_filter == 'Satıldı') {
      return products.where((product) => _selectedIndices.contains(products.indexOf(product))).toList();
    } else if (_filter == 'Satılmadı') {
      return products.where((product) => !_selectedIndices.contains(products.indexOf(product))).toList();
    }
    return products;
  }
}

class Product {
  final String urun;
  final double ucret;
  final String gelirgider;

  Product({required this.urun, required this.ucret, required this.gelirgider});
}
