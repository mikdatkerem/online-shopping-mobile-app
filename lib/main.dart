import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/product_model.dart';
import 'services/api_service.dart';
import 'views/cart_screen.dart';
import 'views/home_screen.dart';
import 'views/product_detail_screen.dart';

void main() {
  runApp(const MobileShoppingApp());
}

class MobileShoppingApp extends StatelessWidget {
  const MobileShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF9B2739);
    const secondary = Color(0xFF279B8A);
    const background = Color(0xFFD9D9D9);
    const dark = Color(0xFF1A1C1E);

    final baseTextTheme = GoogleFonts.soraTextTheme();
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: background,
      onSurface: dark,
      onSurfaceVariant: const Color(0xFF5D6267),
      outline: const Color(0xFFB7B3AD),
      outlineVariant: const Color(0xFFD4CFC9),
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: dark,
      onInverseSurface: Colors.white,
      inversePrimary: const Color(0xFFE7B4BD),
      surfaceTint: primary,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping',
      theme: ThemeData(
        colorScheme: scheme,
        scaffoldBackgroundColor: background,
        useMaterial3: true,
        textTheme: baseTextTheme.apply(bodyColor: dark, displayColor: dark),
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          foregroundColor: dark,
          titleTextStyle: baseTextTheme.titleLarge?.copyWith(
            color: dark,
            fontWeight: FontWeight.w800,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: baseTextTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7A7F85),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => baseTextTheme.labelMedium?.copyWith(
              color: states.contains(WidgetState.selected) ? primary : dark,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w600,
            ),
          ),
          iconTheme: WidgetStateProperty.resolveWith(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? primary : dark,
            ),
          ),
        ),
      ),
      home: const StoreRoot(),
    );
  }
}

class StoreRoot extends StatefulWidget {
  const StoreRoot({super.key});

  @override
  State<StoreRoot> createState() => _StoreRootState();
}

class _StoreRootState extends State<StoreRoot> {
  final ApiService _apiService = ApiService();
  final Map<int, int> _cartQuantities = <int, int>{};
  final Set<int> _favoriteIds = <int>{};
  final ValueNotifier<int> _cartCountNotifier = ValueNotifier<int>(0);

  late Future<List<ProductModel>> _productsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.fetchProducts();
  }

  int get _cartCount =>
      _cartQuantities.values.fold<int>(0, (sum, quantity) => sum + quantity);

  @override
  void dispose() {
    _cartCountNotifier.dispose();
    super.dispose();
  }

  void _syncCartCount() {
    _cartCountNotifier.value = _cartCount;
  }

  void _addToCart(ProductModel product) {
    setState(() {
      _cartQuantities.update(
        product.id,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    });
    _syncCartCount();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} sepete eklendi.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _toggleFavorite(ProductModel product) {
    setState(() {
      if (_favoriteIds.contains(product.id)) {
        _favoriteIds.remove(product.id);
      } else {
        _favoriteIds.add(product.id);
      }
    });
  }

  String _formatCurrency(double value) {
    final fixed = value.toStringAsFixed(2).replaceAll('.', ',');
    return '$fixed TL';
  }

  Future<void> _openCart(List<ProductModel> products) async {
    final updatedQuantities = await Navigator.of(context).push<Map<int, int>>(
      MaterialPageRoute<Map<int, int>>(
        builder: (_) => CartScreen(
          allProducts: products,
          initialQuantities: _cartQuantities,
          formatCurrency: _formatCurrency,
        ),
      ),
    );

    if (updatedQuantities == null) {
      return;
    }

    setState(() {
      _cartQuantities
        ..clear()
        ..addAll(updatedQuantities);
    });
    _syncCartCount();
  }

  void _openDetails(ProductModel product, List<ProductModel> products) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(
          product: product,
          onAddToCart: () => _addToCart(product),
          onOpenCart: () => _openCart(products),
          cartCountListenable: _cartCountNotifier,
          formatCurrency: _formatCurrency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 52),
                    const SizedBox(height: 16),
                    const Text(
                      'Veriler yuklenirken bir sorun olustu.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _productsFuture = _apiService.fetchProducts();
                        });
                      },
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final products = snapshot.data ?? <ProductModel>[];

        return HomeScreen(
          products: products,
          searchQuery: _searchQuery,
          onSearchChanged: (value) => setState(() => _searchQuery = value),
          onProductTap: (product) => _openDetails(product, products),
          onAddToCart: _addToCart,
          onOpenCart: () => _openCart(products),
          cartCount: _cartCount,
          favoriteIds: _favoriteIds,
          onFavoriteToggle: _toggleFavorite,
          formatCurrency: _formatCurrency,
        );
      },
    );
  }
}
