import 'package:flutter/material.dart';

import '/models/apiModel.dart';

class HeaderCard extends StatelessWidget {
  final Apimodel item;
  const HeaderCard(
    this.item, {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(item.url),
          fit: BoxFit.cover,
        ),
      ),
      child: Text(
        item.title,
        style: const TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }
}
