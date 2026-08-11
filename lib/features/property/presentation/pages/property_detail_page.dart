import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/property.dart';
import '../widgets/property_action_button.dart';
import '../widgets/property_image_gallery.dart';
import '../widgets/property_information.dart';

class PropertyDetailPage extends StatelessWidget {
  const PropertyDetailPage({super.key, required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Property Details')),
      body: ListView(
        children: [
          PropertyImageGallery(images: property.imageUrls),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PriceAndTitle(property: property),
                const SizedBox(height: 16),
                PropertyInformation(property: property),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Description'),
                const SizedBox(height: 8),
                Text(
                  property.description ?? 'No description provided.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Location'),
                const SizedBox(height: 8),
                _AddressSection(property: property),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Landlord'),
                const SizedBox(height: 8),
                _LandlordSection(property: property),
                const SizedBox(height: 24),
                PropertyActionButton(
                  onPressed: () {
                    // TODO: Submit a rental request in Phase 2.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rental requests are coming soon.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceAndTitle extends StatelessWidget {
  const _PriceAndTitle({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${formatCurrency(property.monthlyRent)}/month',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(property.title, style: theme.textTheme.titleLarge),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = [
      property.addressLine1,
      if (property.addressLine2 != null) property.addressLine2!,
      if (property.postcode != null) property.postcode!,
      property.locationLabel,
    ];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(parts.join(', '), style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _LandlordSection extends StatelessWidget {
  const _LandlordSection({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person_outline,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.landlordName ?? 'Property owner',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 2),
              Text(
                'Verified landlord',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.verified_outlined, color: theme.colorScheme.primary),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
