class PropertyImageModel {
  const PropertyImageModel({
    required this.id,
    required this.imageUrl,
    this.isPrimary = false,
    this.sortOrder = 0,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      isPrimary: json['isPrimary'] == true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;
}
