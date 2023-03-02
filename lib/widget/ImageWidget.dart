import 'package:flutter/material.dart';

import '/models/apiModel.dart';

class ImageCard extends StatelessWidget {
  final Apimodel imagecard;

  const ImageCard({super.key, 
    required this.imagecard,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
              imagecard.url,
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}
