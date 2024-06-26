import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GelirGider extends StatefulWidget {
  final String username;
  const GelirGider({super.key, required this.username});

  @override
  State<GelirGider> createState() => _GelirGiderState();
}

class _GelirGiderState extends State<GelirGider> {
  Map<String, dynamic> finances = {};
  @override
  void initState() {
    super.initState();
    fetchServiceRequests();
  }

  Future<void> fetchServiceRequests() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.110:3000/getProfitList/${widget.username}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        finances = data;
      });
    } else {
      throw Exception('Failed to load service requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelir Gider Takip', style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.grey[300],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard('Kazanılan Para', finances['totalIncome'].toString(),
                Colors.grey),
            _buildCard('Gider', finances['expense'].toString(), Colors.grey),
            _buildCard('Kar', finances['earnedMoney'].toString(), Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String amount, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
