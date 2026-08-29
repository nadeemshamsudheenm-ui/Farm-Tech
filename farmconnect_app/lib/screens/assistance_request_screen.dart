import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AssistanceRequestScreen extends StatefulWidget {
  final int? farmerId;

  const AssistanceRequestScreen({super.key, required this.farmerId});

  @override
  State<AssistanceRequestScreen> createState() => _AssistanceRequestScreenState();
}

class _AssistanceRequestScreenState extends State<AssistanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _submitting = false;
  String? _statusMessage;

  static const List<String> commonTopics = [
    'Pest control',
    'Fertilizer advice',
    'Irrigation',
    'Crop disease',
    'Modern farming techniques',
  ];

  Future<void> _submit() async {
    if (widget.farmerId == null) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _statusMessage = null;
    });
    try {
      await ApiService.submitAssistanceRequest(
        farmerId: widget.farmerId!,
        topic: _topicController.text,
        description: _descriptionController.text,
      );
      setState(() => _statusMessage = 'Your request was submitted. Our agricultural '
          'support team will reach out with guidance.');
      _topicController.clear();
      _descriptionController.clear();
    } catch (e) {
      setState(() => _statusMessage = 'Submission failed: $e');
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.farmerId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cultivation Support')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Please register as a farmer first (Register tab) to request support.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cultivation Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Need help with crop care, pest control, fertilizers, or modern '
                'farming techniques? Submit a request and get expert guidance.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: commonTopics
                    .map((t) => ActionChip(
                          label: Text(t),
                          onPressed: () => setState(() => _topicController.text = t),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: 'Topic', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Describe the issue / what help you need',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Submit request'),
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
