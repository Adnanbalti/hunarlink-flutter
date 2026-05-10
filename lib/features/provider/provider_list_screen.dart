import 'package:flutter/material.dart';
import '../../shared/models/provider_model.dart';
import 'provider_service.dart';
import 'provider_detail_screen.dart';

class ProviderListScreen extends StatefulWidget {
  final String skill;
  const ProviderListScreen({super.key, required this.skill});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  List<ProviderModel> _providers = [];
  bool _loading = true;
  String _cityFilter = '';

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _loading = true);
    try {
      final providers = await ProviderService.getProviders(
        skill: widget.skill,
        city: _cityFilter.isEmpty ? null : _cityFilter,
      );
      setState(() => _providers = providers);
    } catch (e) {
      setState(() => _providers = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.skill)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'City se filter karo...',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _loadProviders,
                ),
              ),
              onChanged: (v) => _cityFilter = v,
              onSubmitted: (_) => _loadProviders(),
            ),
          ),
          Expanded(
            child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _providers.isEmpty
                ? const Center(child: Text('Koi provider nahi mila'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _providers.length,
                    itemBuilder: (context, index) {
                      final p = _providers[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) =>
                            ProviderDetailScreen(provider: p))),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: const Color(0xFF0F3460),
                                child: Text(
                                  p.user.name.isNotEmpty
                                    ? p.user.name[0].toUpperCase()
                                    : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.user.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(p.city,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                        Text(' ${p.averageRating.toStringAsFixed(1)}',
                                          style: const TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Rs. ${p.hourlyRate.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF0F3460))),
                                  Text('/hr',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}