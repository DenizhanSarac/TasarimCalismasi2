import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  String _filter = 'Tamamlanmadı';

  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.110:3000/getTsList/${widget.username}'));

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        customers = data.map((item) => Customer.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load service requests');
    }
  }

  List<Customer> get _filteredCustomers {
    if (_filter == 'Tamamlandı') {
      return customers.where((customer) => customer.isFinished).toList();
    } else if (_filter == 'Tamamlanmadı') {
      return customers.where((customer) => !customer.isFinished).toList();
    }
    return customers;
  }

  int get _totalEarnings {
    return customers
        .where((customer) => customer.isFinished)
        .map((customer) => customer.fee)
        .fold(0, (prev, amount) => prev + amount);
  }

  Future<void> _updateCustomerStatus(int id) async {
    final response = await http
        .put(Uri.parse('http://192.168.1.110:3000/updateTsStatus/$id'));

    if (response.statusCode == 200) {
      setState(() {
        customers.firstWhere((customer) => customer.id == id).isFinished = true;
      });
    } else {
      throw Exception('Failed to update customer status');
    }
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

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                customer.customerName,
                style: TextStyle(
                  decoration:
                      customer.isFinished ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                'Cihaz: ${customer.model} \nAriza: ${customer.ariza} \nÜcret: ${customer.fee} TL',
                style: TextStyle(
                  decoration:
                      customer.isFinished ? TextDecoration.lineThrough : null,
                ),
              ),
              onTap: () {
                if (!customer.isFinished) {
                  _updateCustomerStatus(customer.id);
                }
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
  final String ariza;
  bool isFinished;
  final int id;

  Customer({
    required this.customerName,
    required this.fee,
    required this.model,
    required this.ariza,
    required this.isFinished,
    required this.id,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerName: json['customer_name'],
      fee: json['fee'],
      model: json['model'],
      ariza: json['ariza'],
      isFinished: json['isfinished'],
      id: json['id'],
    );
  }
}
