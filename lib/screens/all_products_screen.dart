import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../widgets/fake_store_info_card.dart';
import '../models/product.dart';
import 'product_details_screen.dart';
import '../providers/favorites_provider.dart'; // Importa el nuevo provider

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final apiUrl = dotenv.env['FAKESTORE_API_URL']!;

    try {
      final response = await http.get(Uri.parse('$apiUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        setState(() {
          _products = productsJson.map((json) => Product.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _products.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const FakeStoreInfoCard();
        }

        final product = _products[index - 1];
        final favoritesProvider = Provider.of<FavoritesProvider>(context);
        final isFavorite = favoritesProvider.isFavorite(product.id);

        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('\$${product.price}'),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                favoritesProvider.toggleFavorite(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite ? 'Eliminado de favoritos.' : 'Agregado a favoritos.'),
                    duration: const Duration(milliseconds: 800),
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }
}