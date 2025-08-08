import 'package:flutter/material.dart';
import 'dart:ui';

// A unique identifier for each element type
enum ElementType { text, image, table, container }

/// Abstract base class for any element that can be placed on a report page.
/// It defines the common properties like position, size, and a unique ID.
abstract class ReportElement {
  ReportElement({
    required this.id,
    required this.rect,
    this.name = '',
  });

  final String id;
  final Rect rect;
  final String name;

  /// The type of the element. Must be implemented by subclasses.
  ElementType get type;

  /// Creates a copy of this element with the given properties updated.
  /// This is useful for immutability when updating the state.
  ReportElement copyWith({
    String? id,
    Rect? rect,
    String? name,
  });

  /// Converts the element to a JSON map for serialization.
  Map<String, dynamic> toJson();

import 'image_element.dart';
import 'text_element.dart';

  /// Creates an element from a JSON map. This is a factory constructor.
  static ReportElement fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = ElementType.values.firstWhere((e) => e.toString() == typeString, orElse: () {
      throw Exception('Unknown element type: $typeString');
    });

    switch (type) {
      case ElementType.text:
        return TextElement.fromJson(json);
      case ElementType.image:
        return ImageElement.fromJson(json);
      default:
        throw UnimplementedError('Json conversion for $typeString not implemented.');
    }
  }
}
