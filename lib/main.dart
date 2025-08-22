import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'auth_wrapper.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env
  await dotenv.load(fileName: ".env");

  // Inicializa Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Inicializa Stripe con tu clave publicable
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TiendaExpress POS',
        theme: ThemeData(
          primaryColor: const Color(0xFFE65100),
          hintColor: const Color(0xFF9C27B0),
          scaffoldBackgroundColor: Colors.white,

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFE65100),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65100),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE65100)),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            labelStyle: TextStyle(color: Colors.black54),
            floatingLabelStyle: TextStyle(color: Color(0xFFE65100)),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}