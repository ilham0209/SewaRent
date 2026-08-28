import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../core/app_services.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../property/data/models/property_model.dart';
import '../../../property/data/models/property_query.dart';
import '../../../property/presentation/widgets/property_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoading = true;
  String? _errorMessage;
  var _properties = <PropertyModel>[];
  var _selectedCategory = 'All';
  // TODO: Set based on fetched user profile (landlordId != null).
  final _isLinkedToLandlord = true;

  static const _categories = <String>[
    'All',
    'Apartment',
    'Condominium',
    'Terrace House',
    'Room',
    'Studio',
  ];

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final page = await AppServices.propertyRepository.getProperties(
        query: PropertyQuery(page: 1, pageSize: 50),
      );
      if (!mounted) return;
      setState(() {
        _properties = page.items;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = _friendlyError(e);
      });
    }
  }

  String _friendlyError(Object e) {
    final message = e.toString();
    if (message.contains('401')) {
      return 'Your session has expired. Please log in again.';
    }
    if (message.contains('403')) {
      return 'You do not have permission to view properties.';
    }
    if (message.contains('404')) {
      return 'Properties could not be found.';
    }
    if (message.contains('500')) {
      return 'Something went wrong on our end. Please try again later.';
    }
    if (message.contains('Unable to reach') || message.contains('timed out')) {
      return 'Unable to reach the server. Please check your connection.';
    }
    return 'Failed to load properties. Please try again.';
  }

  List<PropertyModel> get _filteredProperties {
    if (_selectedCategory == 'All') {
      return _properties;
    }
    return _properties
        .where((p) => p.propertyTypeName == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildPropertyList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: EmptyState(
          icon: Icons.cloud_off_outlined,
          message: _errorMessage!,
          detail: 'Pull down to retry.',
        ),
      );
    }

    if (!_isLinkedToLandlord) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: EmptyState(
          icon: Icons.link_off_outlined,
          message: 'Link to your landlord',
          detail:
              'Enter your landlord\'s code to view available properties. '
              'You can do this from your profile.',
        ),
      );
    }

    final properties = _filteredProperties;

    if (properties.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: EmptyState(
          icon: Icons.home_work_outlined,
          message: 'No properties found',
          detail: 'There are no properties available for this category.',
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final property = properties[index];
          return PropertyCard(
            property: property.toEntity(),
            onTap: () => _openProperty(property),
          );
        },
      ),
    );
  }

  void _openProperty(PropertyModel property) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.propertyDetail, arguments: property.toEntity());
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
