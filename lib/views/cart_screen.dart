import 'package:flutter/material.dart';

import '../models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.allProducts,
    required this.initialQuantities,
    required this.formatCurrency,
  });

  final List<ProductModel> allProducts;
  final Map<int, int> initialQuantities;
  final String Function(double value) formatCurrency;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<int, int> _quantities;

  @override
  void initState() {
    super.initState();
    _quantities = Map<int, int>.from(widget.initialQuantities);
  }

  List<ProductModel> get _cartProducts => widget.allProducts
      .where((product) => (_quantities[product.id] ?? 0) > 0)
      .toList();

  double get _total => _cartProducts.fold<double>(
    0,
    (sum, product) => sum + (product.price * (_quantities[product.id] ?? 0)),
  );

  void _removeItem(ProductModel product) {
    setState(() {
      final current = _quantities[product.id];

      if (current == null) {
        return;
      }

      if (current <= 1) {
        _quantities.remove(product.id);
      } else {
        _quantities[product.id] = current - 1;
      }
    });
  }

  void _checkout() {
    if (_cartProducts.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Odeme akisi demo olarak tamamlandi.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cartProducts = _cartProducts;

    return PopScope<Map<int, int>>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(_quantities);
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(_quantities),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: const Text('Sepetim'),
        ),
        body: SafeArea(
          top: false,
          child: cartProducts.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Text(
                      'Sepetinde henuz urun yok.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: cartProducts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final product = cartProducts[index];
                            final quantity = _quantities[product.id] ?? 0;
                            final itemTotal = product.price * quantity;

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x12000000),
                                    blurRadius: 14,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 84,
                                    width: 84,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F1ED),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => const Icon(
                                            Icons.image_not_supported_outlined,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '$quantity adet',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          widget.formatCurrency(itemTotal),
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton.filled(
                                    onPressed: () => _removeItem(product),
                                    style: IconButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      foregroundColor: colorScheme.onPrimary,
                                    ),
                                    icon: const Icon(Icons.remove),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Toplam',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.formatCurrency(_total),
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton(
                              onPressed: _checkout,
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.secondary,
                                foregroundColor: colorScheme.onSecondary,
                                minimumSize: const Size(160, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Odemeyi Tamamla',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
