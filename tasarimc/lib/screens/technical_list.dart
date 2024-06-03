import 'package:flutter/material.dart';


class TechList extends StatefulWidget {
  const TechList({super.key});

  @override
  _TechListState createState() => _TechListState();
}

class _TechListState extends State<TechList> {
  final List<Customer> customers = [
    Customer(phone: '555-1234', name: 'Ebru', price: 150.0),
    Customer(phone: '555-5678', name: 'Deniz', price: 200.0),
  ];

  // Tıklanmış öğeleri takip etmek için bir Set kullanıyoruz
  Set<int> _selectedIndices = Set<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teknik Servis Takip Listesi'),
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          final isSelected = _selectedIndices.contains(index);

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                customer.name,
                style: TextStyle(
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                'Cihaz: ${customer.phone}\nÜcret: \$${customer.price}',
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

class Customer {
  final String phone;
  final String name;
  final double price;

  Customer({required this.phone, required this.name, required this.price});
}
