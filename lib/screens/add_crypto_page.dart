import 'package:flutter/material.dart';
import '../services/crypto_service.dart';
import '../models/crypto.dart';

class AddCryptoPage extends StatefulWidget {
  final Function(Crypto) onAddCrypto;

  const AddCryptoPage({Key? key, required this.onAddCrypto}) : super(key: key);

  @override
  State<AddCryptoPage> createState() => _AddCryptoPageState();
}

class _AddCryptoPageState extends State<AddCryptoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final symbol = _symbolController.text.trim();
      final description = _descriptionController.text.trim();

      try {
        final crypto = await CryptoService().createCrypto(symbol, description);
        widget.onAddCrypto(crypto);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при добавлении криптовалюты')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить криптовалюту')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _symbolController,
                decoration: const InputDecoration(labelText: 'Символ криптовалюты'),
                validator: (value) => value == null || value.isEmpty ? 'Введите символ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                validator: (value) => value == null || value.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
