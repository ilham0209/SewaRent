import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../property/domain/entities/property.dart';
import '../../../property/presentation/widgets/property_card.dart';
import '../../data/mock_properties.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _selectedCategory = 'All';

  static const _categories = <String>[
    'All',
    'Apartment',
    'Condominium',
    'Terrace House',
    'Room',
    'Studio',
  ];

  List<Property> get _recommendedProperties {
    if (_selectedCategory == 'All') {
      return mockProperties;
    }
    return mockProperties
        .where((property) => property.propertyType == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final properties = _recommendedProperties;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _GreetingHeader(),
            const SizedBox(height: 20),
            const _HomeSearchBar(),
            const SizedBox(height: 24),
            _CategoryRow(
              categories: _categories,
              selected: _selectedCategory,
              onSelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Recommended for you',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (properties.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('No properties found for this category.'),
                ),
              )
            else
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: properties.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return PropertyCard(
                      property: property,
                      onTap: () => _openProperty(property),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _openProperty(Property property) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.propertyDetail, arguments: property);
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greetingText(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Find your next home',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _greetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    // TODO: Navigate to the search screen when search is implemented in Phase 2.
    return const TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Search properties, location...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            label: Text(category),
            selected: category == selected,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
