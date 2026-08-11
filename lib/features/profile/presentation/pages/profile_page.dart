import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const EmptyState(
        icon: Icons.person_outline,
        message: 'Profile coming soon',
        detail: 'Sign in to manage your account and preferences.',
      ),
    );
  }
}
