import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import 'product_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> _allProducts = [];
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
          _allProducts = productsJson.map((json) => Product.fromJson(json)).toList();
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
    
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteProducts = _allProducts
        .where((product) => favoritesProvider.isFavorite(product.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
      ),
      body: favoriteProducts.isEmpty
          ? const Center(
              child: Text(
                'No tienes productos favoritos.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
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
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Eliminado de favoritos.'),
                            duration: Duration(milliseconds: 800),
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
            ),
    );
  }
}