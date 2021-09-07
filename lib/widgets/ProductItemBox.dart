import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductItemBox extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ProductItemBox({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        width: this.width,
        height: this.height,
        imageUrl: this.imageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
