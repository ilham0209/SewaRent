import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_state.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: const EmptyState(
        icon: Icons.favorite_outline,
        message: 'No favourites yet',
        detail: 'Properties you save will appear here.',
      ),
    );
  }
}
