import 'package:flutter/material.dart';

class GelirGider extends StatefulWidget {
  const GelirGider({super.key});

  @override
  State<GelirGider> createState() => _GelirGiderState();
}

class _GelirGiderState extends State<GelirGider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelir Gider Takip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard('Kazanılan Para', '₺1000', Colors.grey),
            _buildCard('Gider', '₺500', Colors.grey),
            _buildCard('Kar', '₺500', Colors.grey),

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
