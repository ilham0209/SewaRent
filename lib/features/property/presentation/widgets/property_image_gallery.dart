import 'package:flutter/material.dart';

import 'property_image.dart';
import 'property_image_placeholder.dart';

class PropertyImageGallery extends StatelessWidget {
  const PropertyImageGallery({super.key, required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: PropertyImagePlaceholder(),
      );
    }
    return SizedBox(
      height: 260,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return PropertyImage(imageUrl: images[index]);
        },
      ),
    );
  }
}
