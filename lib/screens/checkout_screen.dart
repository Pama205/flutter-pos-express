import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/cart_provider.dart';
import '../home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Future<void> makePayment() async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    // Obtener variables de entorno para el impuesto
    final taxRate = double.tryParse(dotenv.env['TAX_RATE_PERCENTAGE'] ?? '0.0') ?? 0.0;
    final isTaxIncluded = dotenv.env['TAX_INCLUDED_IN_PRICE'] == 'true';

    final subtotal = cart.totalAmount;
    final taxAmount = isTaxIncluded ? 0.0 : subtotal * (taxRate / 100);
    final totalWithTax = subtotal + taxAmount;

    final serverUrl = dotenv.env['SERVER_URL']!;

    try {
      // 1. Llama a tu servidor local para crear un PaymentIntent
      final response = await http.post(
        Uri.parse('$serverUrl/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          // Envía el total con el impuesto a tu servidor
          'amount': totalWithTax, 
        }),
      );

      final paymentIntentData = json.decode(response.body);
      final clientSecret = paymentIntentData['clientSecret'];

      // 2. Inicializa el PaymentSheet de Stripe
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Tienda Express',
        ),
      );

      // 3. Muestra el PaymentSheet y espera el resultado del pago
      await Stripe.instance.presentPaymentSheet();
      
      // Si el pago es exitoso
      if (mounted) {
        // Vacía el carrito primero
        cart.clearCart(); 

        // Muestra un diálogo de éxito
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('¡Pago Exitoso!'),
              content: const Text('Tu compra se ha completado con éxito.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Volver al Inicio'),
                  onPressed: () {
                    // Cierra el diálogo y navega al home
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e, stackTrace) {
      // Opcional: Obtener el ID del usuario si está autenticado
      final userId = Supabase.instance.client.auth.currentUser?.id;

      // Registrar el error en la base de datos de Supabase
      await Supabase.instance.client
        .from('error_logs')
        .insert({
          'error_message': e.toString(),
          'stack_trace': stackTrace.toString(),
          'user_id': userId,
        });

      // Mostrar el mensaje de error al usuario
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de Stripe: ${e.error.localizedMessage}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ha ocurrido un error inesperado: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final taxName = dotenv.env['TAX_NAME'] ?? 'Impuesto';
    final taxRate = double.tryParse(dotenv.env['TAX_RATE_PERCENTAGE'] ?? '0.0') ?? 0.0;
    final isTaxIncluded = dotenv.env['TAX_INCLUDED_IN_PRICE'] == 'true';

    final subtotal = cart.totalAmount;
    final taxAmount = isTaxIncluded ? 0.0 : subtotal * (taxRate / 100);
    final totalWithTax = subtotal + taxAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Resumen de la compra
            Text(
              'Resumen de la Orden:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                Text('\$${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$taxName ($taxRate%):', style: const TextStyle(fontSize: 16)),
                Text('\$${taxAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(),
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
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (totalWithTax > 0) {
                  makePayment();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El total no puede ser cero.')),
                  );
                }
              },
              child: const Text('Pagar con Tarjeta'),
            ),
          ],
        ),
      ),
    );
  }
}