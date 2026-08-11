import 'package:flutter/material.dart';

class PropertyActionButton extends StatelessWidget {
  const PropertyActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.send_outlined),
      label: const Text('Request to Rent'),
    );
  }
}
