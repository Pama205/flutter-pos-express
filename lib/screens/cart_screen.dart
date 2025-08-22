import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // Obtener variables del impuesto del archivo .env
    final taxName = dotenv.env['TAX_NAME'] ?? 'Impuesto';
    final taxRate = double.tryParse(dotenv.env['TAX_RATE_PERCENTAGE'] ?? '0.0') ?? 0.0;
    final isTaxIncluded = dotenv.env['TAX_INCLUDED_IN_PRICE'] == 'true';

    final subtotal = cart.totalAmount;
    final taxAmount = isTaxIncluded ? 0.0 : subtotal * (taxRate / 100);
    final totalWithTax = subtotal + taxAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Tu carrito está vacío.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.network(cartItem.product.image),
                          title: Text(cartItem.product.title),
                          subtitle: Text(
                            '\$${(cartItem.product.price).toStringAsFixed(2)} x ${cartItem.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.red),
                                onPressed: () {
                                  if (cartItem.quantity > 1) {
                                    cartItem.decrementQuantity();
                                    cart.notifyListeners();
                                  } else {
                                    cart.removeProduct(cartItem);
                                  }
                                },
                              ),
                              Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  cartItem.incrementQuantity();
                                  cart.notifyListeners();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '\$${subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Impuesto
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$taxName ($taxRate%):',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '\$${taxAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Total final
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Final:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${totalWithTax.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                      );
                    },
                    child: const Text('Proceder Pago'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Carrito vaciado.')),
                      );
                    },
                    child: const Text('Vaciar Carrito'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}