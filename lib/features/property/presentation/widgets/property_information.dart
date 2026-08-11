import 'package:flutter/material.dart';

import '../../domain/entities/property.dart';

class PropertyInformation extends StatelessWidget {
  const PropertyInformation({super.key, required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final items = <_InfoItem>[
      _InfoItem(
        icon: Icons.king_bed_outlined,
        label: '${property.bedrooms} Bedrooms',
      ),
      _InfoItem(
        icon: Icons.bathtub_outlined,
        label: '${property.bathrooms} Bathrooms',
      ),
      if (property.parkingSpaces != null)
        _InfoItem(
          icon: Icons.local_parking_outlined,
          label: '${property.parkingSpaces} Parking',
        ),
      _InfoItem(
        icon: property.isFurnished ? Icons.chair_outlined : Icons.crop_square,
        label: property.isFurnished ? 'Furnished' : 'Unfurnished',
      ),
      if (property.propertyType != null)
        _InfoItem(
          icon: Icons.home_work_outlined,
          label: property.propertyType!,
        ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final item in items) _InfoChip(item: item)],
    );
  }
}

class _InfoItem {
  const _InfoItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(item.label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
