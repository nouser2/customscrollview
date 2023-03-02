// ignore: unused_import
import 'package:flutter/material.dart';

class Apimodel {
  final String type;
  final String url;
  final String title;
  final String desc;

  const Apimodel({
    required this.type,
    this.url = 'url',
    this.title = 'title',
    this.desc = 'desc',
  });
}
