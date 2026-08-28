import 'package:flutter/material.dart';

import '../../../../core/app_services.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../property/presentation/pages/property_detail_page.dart';
import '../../data/models/favourite_item_model.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  var _isLoading = true;
  String? _errorMessage;
  var _items = <FavouriteItemModel>[];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await AppServices.favouriteRepository.getFavourites();
      if (!mounted) return;
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load favourites. Pull down to retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return RefreshIndicator(
        onRefresh: _loadFavourites,
        child: ListView(
          children: [
            const SizedBox(height: 64),
            EmptyState(
              icon: Icons.cloud_off_outlined,
              message: _errorMessage!,
              detail: 'Pull down to retry.',
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadFavourites,
        child: ListView(
          children: const [
            SizedBox(height: 64),
            EmptyState(
              icon: Icons.favorite_outline,
              message: 'No favourites yet',
              detail: 'Properties you save will appear here.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavourites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.home_work_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(item.title ?? 'Property'),
              subtitle: Text(
                [
                  if (item.city != null && item.state != null)
                    '${item.city}, ${item.state}',
                  if (item.monthlyRent != null)
                    'RM ${item.monthlyRent!.toStringAsFixed(0)}/month',
                ].join(' - '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final property = item.toPropertyModel().toEntity();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PropertyDetailPage(property: property),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
