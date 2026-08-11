class PropertyImageModel {
  const PropertyImageModel({required this.id, required this.imageUrl});

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: (json['id'] as num).toInt(),
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  final int id;
  final String imageUrl;
}
