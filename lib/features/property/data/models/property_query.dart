import '../../../../core/constants/app_constants.dart';

class PropertyQuery {
  const PropertyQuery({
    this.keyword,
    this.city,
    this.state,
    this.minRent,
    this.maxRent,
    this.propertyTypeId,
    this.bedrooms,
    this.furnished,
    this.page = 1,
    this.pageSize = AppConstants.defaultPageSize,
  });

  final String? keyword;
  final String? city;
  final String? state;
  final double? minRent;
  final double? maxRent;
  final String? propertyTypeId;
  final int? bedrooms;
  final bool? furnished;
  final int page;
  final int pageSize;

  Map<String, String> toQueryParameters() {
    return {
      if (keyword != null && keyword!.isNotEmpty) 'search': keyword!,
      if (city != null && city!.isNotEmpty) 'city': city!,
      if (state != null && state!.isNotEmpty) 'state': state!,
      if (minRent != null) 'minRent': minRent.toString(),
      if (maxRent != null) 'maxRent': maxRent.toString(),
      if (propertyTypeId != null && propertyTypeId!.isNotEmpty)
        'propertyTypeId': propertyTypeId!,
      if (bedrooms != null) 'bedrooms': bedrooms.toString(),
      if (furnished != null) 'isFurnished': furnished.toString(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
  }
}
