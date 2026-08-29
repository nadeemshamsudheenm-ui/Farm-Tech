import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductListingScreen extends StatefulWidget {
  final int? farmerId;

  const ProductListingScreen({super.key, required this.farmerId});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  bool _submitting = false;
  String? _statusMessage;

  Future<void> _submit() async {
    if (widget.farmerId == null) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _statusMessage = null;
    });
    try {
      final product = await ApiService.listProduct(
        name: _nameController.text,
        quantityAvailable: double.parse(_quantityController.text),
        pricePerUnit: double.parse(_priceController.text),
        farmerId: widget.farmerId!,
      );
      setState(() => _statusMessage = '"${product.productName}" is now live in the catalog.');
      _nameController.clear();
      _quantityController.clear();
      _priceController.clear();
    } catch (e) {
      setState(() => _statusMessage = 'Listing failed: $e');
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.farmerId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('List Produce')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Please register as a farmer first (Register tab) before listing produce.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('List Produce')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Produce name (e.g. Tomato)', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity available (kg)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Enter a valid quantity' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price per kg (₹)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Enter a valid price' : null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('List produce'),
              ),
              if (_statusMessage != null) ...[
                const SizedBox(height: 16),
                Text(_statusMessage!, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
