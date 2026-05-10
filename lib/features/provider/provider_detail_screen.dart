import 'package:flutter/material.dart';
import '../../shared/models/provider_model.dart';

class ProviderDetailScreen extends StatelessWidget {
  final ProviderModel provider;
  const ProviderDetailScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(provider.user.name)),
      body: const Center(
        child: Text('Provider Detail — Coming Soon!'),
      ),
    );
  }
}