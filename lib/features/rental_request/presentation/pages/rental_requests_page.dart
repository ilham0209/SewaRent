import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_state.dart';

class RentalRequestsPage extends StatelessWidget {
  const RentalRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body: const EmptyState(
        icon: Icons.assignment_outlined,
        message: 'No rental requests yet',
        detail: 'Requests you submit will appear here.',
      ),
    );
  }
}
