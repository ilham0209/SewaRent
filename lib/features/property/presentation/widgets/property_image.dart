import 'package:flutter/material.dart';

import 'property_image_placeholder.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({super.key, required this.imageUrl, this.fit});

  final String imageUrl;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return const PropertyImagePlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return const PropertyImagePlaceholder();
      },
    );
  }
}
