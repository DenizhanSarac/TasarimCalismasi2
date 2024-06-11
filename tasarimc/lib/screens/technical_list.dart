import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TechList extends StatefulWidget {
  final String username;
  const TechList({super.key, required this.username});

  @override
  _TechListState createState() => _TechListState();
}

class _TechListState extends State<TechList> {
  List<Customer> customers = [];
  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    print(widget.username);
    final response = await http.get(
        Uri.parse('http://192.168.1.106:3000/getTsList/${widget.username}'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        customers = data.map((item) => Customer.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load service requests');
    }
  }

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
                customers[index].customerName,
                style: TextStyle(
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                'Cihaz: ${customers[index].model}\nÜcret: ${customers[index].fee} TL',
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
  final String customerName;
  final int fee;
  final String model;

  Customer({
    required this.customerName,
    required this.fee,
    required this.model,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerName: json['customer_name'],
      fee: json['fee'],
      model: json['model'],
    );
  }
}
