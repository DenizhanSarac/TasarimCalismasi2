import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuySellList extends StatefulWidget {
  final String username;
  const BuySellList({super.key, required this.username});

  @override
  _BuySellListState createState() => _BuySellListState();
}

class _BuySellListState extends State<BuySellList> {
  List<CustomerBuySell> product = [];

  String _filter = 'Satılmadı';

  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    final response = await http.get(
        Uri.parse('http://192.168.1.110:3000/getBsList/${widget.username}'));

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        product = data.map((item) => CustomerBuySell.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load service requests');
    }
  }

  Future<void> _updateProductStatus(int id) async {
    final response = await http
        .put(Uri.parse('http://192.168.1.110:3000/updateBsStatus/$id'));

    if (response.statusCode == 200) {
      setState(() {
        product.firstWhere((product) => product.id == id).isSell = true;
      });
    } else {
      throw Exception('Failed to update customer status');
    }
  }

  int _calculateProfit() {
    int profit = 0;
    for (var i = 0; i < product.length; i++) {
      if (product.contains(i)) {
        if (product[i].isSell) {
          profit += product[i].fee;
        } else if (!product[i].isSell) {
          profit -= product[i].fee;
        }
      }
    }
    return profit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Listesi'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            items: <String>['Tümü', 'Satıldı', 'Satılmadı'].map((String value) {
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
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final product = _filteredCustomers[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      product.customerName,
                      style: TextStyle(
                        decoration:
                            product.isSell ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      'Cihaz: ${product.model}\nÜcret: ${product.fee} TL',
                      style: TextStyle(
                        decoration:
                            product.isSell ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (!product.isSell) {
                          print("Girdim.");
                          _updateProductStatus(product.id);
                        }
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
            'Toplam Kar: ${_calculateProfit().toString()} TL',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  List<CustomerBuySell> get _filteredCustomers {
    if (_filter == 'Satıldı') {
      return product.where((product) => product.isSell).toList();
    } else if (_filter == 'Satılmadı') {
      return product.where((product) => !product.isSell).toList();
    }
    return product;
  }
}

class CustomerBuySell {
  final String customerName;
  final int fee;
  final String model;
  bool isSell;
  final int id;

  CustomerBuySell({
    required this.customerName,
    required this.fee,
    required this.model,
    required this.isSell,
    required this.id,
  });

  factory CustomerBuySell.fromJson(Map<String, dynamic> json) {
    return CustomerBuySell(
      customerName: json['customer_name'],
      fee: json['fee'],
      model: json['model'],
      isSell: json['issell'],
      id: json['id'],
    );
  }
}
