import 'package:flutter/material.dart';
import 'report_element.dart';

/// Represents an image element on the report page.
class ImageElement extends ReportElement {
  ImageElement({
    required super.id,
    required super.rect,
    super.name,
    this.source = '', // Could be a URL or an asset path
    this.fit = BoxFit.cover,
  });

  final String source;
  final BoxFit fit;

  @override
  ElementType get type => ElementType.image;

  @override
  ImageElement copyWith({
    String? id,
    Rect? rect,
    String? name,
    String? source,
    BoxFit? fit,
  }) {
    return ImageElement(
      id: id ?? this.id,
      rect: rect ?? this.rect,
      name: name ?? this.name,
      source: source ?? this.source,
      fit: fit ?? this.fit,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'rect': {'l': rect.left, 't': rect.top, 'w': rect.width, 'h': rect.height},
      'name': name,
      'source': source,
      'fit': fit.toString(),
    };
  }

  factory ImageElement.fromJson(Map<String, dynamic> json) {
    final rectJson = json['rect'];
    return ImageElement(
      id: json['id'],
      rect: Rect.fromLTWH(rectJson['l'], rectJson['t'], rectJson['w'], rectJson['h']),
      name: json['name'],
      source: json['source'],
      fit: BoxFit.values.firstWhere((e) => e.toString() == json['fit']),
    );
  }
}
