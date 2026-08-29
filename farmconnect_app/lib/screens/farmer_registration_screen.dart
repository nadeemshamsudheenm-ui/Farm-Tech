import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  final void Function(int farmerId) onRegistered;

  const FarmerRegistrationScreen({super.key, required this.onRegistered});

  @override
  State<FarmerRegistrationScreen> createState() => _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  bool _submitting = false;
  String? _statusMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _statusMessage = null;
    });
    try {
      final farmer = await ApiService.registerFarmer(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
      );
      widget.onRegistered(farmer.id);
      setState(() => _statusMessage = 'Registered! Your Farmer ID is ${farmer.id}. '
          'You can now list produce in the Sell tab.');
    } catch (e) {
      setState(() => _statusMessage = 'Registration failed: $e');
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Your name and phone number are kept private and are never '
                'shown to buyers — only your product listings and general '
                'location are made visible.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location (village/town)', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Register'),
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
