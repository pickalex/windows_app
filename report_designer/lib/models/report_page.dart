import 'package:flutter/material.dart';
import 'report_element.dart';

/// Defines standard paper sizes in points (1/72 inch).
class PaperSize {
  static const a4 = Size(595, 842);
  static const letter = Size(612, 792);
  static const legal = Size(612, 1008);
}

/// Represents a single page in the report.
/// It holds a list of elements and defines the page dimensions.
class ReportPage {
  ReportPage({
    this.elements = const [],
    this.size = PaperSize.a4,
    this.margins = const EdgeInsets.all(72), // 1 inch margins
  });

  final List<ReportElement> elements;
  final Size size;
  final EdgeInsets margins;

  ReportPage copyWith({
    List<ReportElement>? elements,
    Size? size,
    EdgeInsets? margins,
  }) {
    return ReportPage(
      elements: elements ?? this.elements,
      size: size ?? this.size,
      margins: margins ?? this.margins,
    );
  }

  factory ReportPage.fromJson(Map<String, dynamic> json) {
    return ReportPage(
      elements: (json['elements'] as List)
          .map((item) => ReportElement.fromJson(item))
          .toList(),
      size: Size(json['size']['w'], json['size']['h']),
      margins: EdgeInsets.fromLTRB(
        json['margins']['l'],
        json['margins']['t'],
        json['margins']['r'],
        json['margins']['b'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elements': elements.map((e) => e.toJson()).toList(),
      'size': {'w': size.width, 'h': size.height},
      'margins': {
        'l': margins.left,
        't': margins.top,
        'r': margins.right,
        'b': margins.bottom,
      },
    };
  }
}
