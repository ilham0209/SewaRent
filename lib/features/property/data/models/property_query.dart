import '../../../../core/constants/app_constants.dart';

class PropertyQuery {
  const PropertyQuery({
    this.keyword,
    this.location,
    this.minRent,
    this.maxRent,
    this.propertyTypeId,
    this.bedrooms,
    this.bathrooms,
    this.furnished,
    this.page = 1,
    this.pageSize = AppConstants.defaultPageSize,
    this.sortBy,
    this.sortDirection,
  });

  final String? keyword;
  final String? location;
  final int? minRent;
  final int? maxRent;
  final int? propertyTypeId;
  final int? bedrooms;
  final int? bathrooms;
  final bool? furnished;
  final int page;
  final int pageSize;
  final String? sortBy;
  final String? sortDirection;

  Map<String, String> toQueryParameters() {
    return {
      if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword!,
      if (location != null && location!.isNotEmpty) 'location': location!,
      if (minRent != null) 'minRent': minRent.toString(),
      if (maxRent != null) 'maxRent': maxRent.toString(),
      if (propertyTypeId != null) 'propertyTypeId': propertyTypeId.toString(),
      if (bedrooms != null) 'bedrooms': bedrooms.toString(),
      if (bathrooms != null) 'bathrooms': bathrooms.toString(),
      if (furnished != null) 'furnished': furnished.toString(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      if (sortBy != null && sortBy!.isNotEmpty) 'sortBy': sortBy!,
      if (sortDirection != null && sortDirection!.isNotEmpty)
        'sortDirection': sortDirection!,
    };
  }
}
