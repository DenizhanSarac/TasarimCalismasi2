import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TechList extends StatefulWidget {
  final String username;
  const TechList({super.key, required this.username});

  @override
  _TechListState createState() => _TechListState();
}

class _TechListState extends State<TechList> {
  List<Customer> customers = [];
  Set<int> _selectedIndices = Set<int>();
  String _filter = 'Hepsi';

  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
    _loadSelectedIndices();
  }

  Future<void> fetchServiceRequests() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.142:3000/getTsList/${widget.username}'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        customers = data.map((item) => Customer.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load service requests');
    }
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
    await prefs.setStringList('selectedIndices', _selectedIndices.map((index) => index.toString()).toList());
  }

  List<Customer> get _filteredCustomers {
    if (_filter == 'Tamamlandı') {
      return customers
          .asMap()
          .entries
          .where((entry) => _selectedIndices.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
    } else if (_filter == 'Tamamlanmadı') {
      return customers
          .asMap()
          .entries
          .where((entry) => !_selectedIndices.contains(entry.key))
          .map((entry) => entry.value)
          .toList();
    }
    return customers;
  }

  int get _totalEarnings {
    return customers
        .asMap()
        .entries
        .where((entry) => _selectedIndices.contains(entry.key))
        .map((entry) => entry.value.fee)
        .fold(0, (prev, amount) => prev + amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teknik Servis Takip Listesi'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            items: <String>['Hepsi', 'Tamamlandı', 'Tamamlanmadı']
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
      body: ListView.builder(
        itemCount: _filteredCustomers.length,
        itemBuilder: (context, index) {
          final customer = _filteredCustomers[index];
          final originalIndex = customers.indexOf(customer);
          final isSelected = _selectedIndices.contains(originalIndex);

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                customer.customerName,
                style: TextStyle(
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                'Cihaz: ${customer.model}\nÜcret: ${customer.fee} TL',
                style: TextStyle(
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedIndices.remove(originalIndex);
                  } else {
                    _selectedIndices.add(originalIndex);
                  }
                  _saveSelectedIndices();
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Toplam Kar: $_totalEarnings TL',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
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
