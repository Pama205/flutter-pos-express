import 'package:flutter/material.dart';

class FakeStoreInfoCard extends StatelessWidget {
  const FakeStoreInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Fuente de Datos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Esta aplicación usa la API de FakeStore.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 4),
            Text(
              'Es una API gratuita y de prueba para prototipos de e-commerce.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 12),
            Text(
              'URL: https://fakestoreapi.com',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}