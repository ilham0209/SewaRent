import '../../../../core/constants/app_constants.dart';
import 'property_model.dart';

class PropertyPage {
  const PropertyPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
  });

  factory PropertyPage.fromJson(Map<String, dynamic> json) {
    final items = <PropertyModel>[];
    final rawItems = json['items'];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(PropertyModel.fromJson(item));
        }
      }
    }

    return PropertyPage(
      items: items,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize:
          (json['pageSize'] as num?)?.toInt() ?? AppConstants.defaultPageSize,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
    );
  }

  final List<PropertyModel> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
