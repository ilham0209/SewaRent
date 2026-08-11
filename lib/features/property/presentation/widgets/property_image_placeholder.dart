import 'package:flutter/material.dart';

class PropertyImagePlaceholder extends StatelessWidget {
  const PropertyImagePlaceholder({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.home_work_outlined,
        size: 56,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
