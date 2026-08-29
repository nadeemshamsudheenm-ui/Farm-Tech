import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  late Future<List<Product>> _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = ApiService.browseCatalog();
  }

  void _refresh() => setState(() => _catalog = ApiService.browseCatalog());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fresh Produce Catalog')),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: FutureBuilder<List<Product>>(
          future: _catalog,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _errorView(snapshot.error.toString());
            }
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('No produce listed yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.eco)),
                    title: Text(p.productName),
                    subtitle: Text(
                      '₹${p.pricePerUnit.toStringAsFixed(2)} / unit · '
                      '${p.quantityAvailable.toStringAsFixed(1)} available · '
                      '${p.farmerLocation}',
                    ),
                    trailing: FilledButton(
                      onPressed: () => _openOrderSheet(p),
                      child: const Text('Order'),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _errorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.red),
            const SizedBox(height: 8),
            Text('Could not load catalog:\n$message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _refresh, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  void _openOrderSheet(Product product) {
    final quantityController = TextEditingController();
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ${product.productName}', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Your name / shop name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact number'),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Delivery address'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity (max ${product.quantityAvailable.toStringAsFixed(1)})',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a valid quantity';
                  if (n > product.quantityAvailable) return 'Exceeds available stock';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  try {
                    final result = await ApiService.placeOrder(
                      productId: product.productId,
                      buyerName: nameController.text,
                      buyerContact: contactController.text,
                      deliveryAddress: addressController.text,
                      quantityOrdered: double.parse(quantityController.text),
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Order #${result.orderId} placed — status: ${result.status}',
                          ),
                        ),
                      );
                      _refresh();
                    }
                  } catch (e) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text('Order failed: $e')),
                      );
                    }
                  }
                },
                child: const Text('Place order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
