import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';

class EditCryptoPage extends StatefulWidget {
  final Crypto crypto;

  const EditCryptoPage({Key? key, required this.crypto}) : super(key: key);

  @override
  State<EditCryptoPage> createState() => _EditCryptoPageState();
}

class _EditCryptoPageState extends State<EditCryptoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
        _descriptionController = TextEditingController(text: widget.crypto.description ?? '');
  }

  Future<void> _updateCrypto() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedCrypto = Crypto(
          id: widget.crypto.id,
          name: widget.crypto.name,
          symbol: widget.crypto.symbol,
          imageUrl: widget.crypto.imageUrl,
          price: widget.crypto.price,
          marketCap: widget.crypto.marketCap,
          priceChange24h: widget.crypto.priceChange24h,
          description: _descriptionController.text, // Новое поле
        );

        await CryptoService().updateCrypto(updatedCrypto);

        Navigator.pop(context, updatedCrypto);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при обновлении криптовалюты')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать криптовалюту')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateCrypto,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
