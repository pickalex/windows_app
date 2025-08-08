import 'package:flutter/material.dart';
import 'report_element.dart';

/// Represents a text element on the report page.
class TextElement extends ReportElement {
  TextElement({
    required super.id,
    required super.rect,
    super.name,
    this.text = 'Text',
    this.style = const TextStyle(fontSize: 12, color: Colors.black),
    this.alignment = TextAlign.left,
    this.wordWrap = true,
  });

  final String text;
  final TextStyle style;
  final TextAlign alignment;
  final bool wordWrap;

  @override
  ElementType get type => ElementType.text;

  @override
  TextElement copyWith({
    String? id,
    Rect? rect,
    String? name,
    String? text,
    TextStyle? style,
    TextAlign? alignment,
    bool? wordWrap,
  }) {
    return TextElement(
      id: id ?? this.id,
      rect: rect ?? this.rect,
      name: name ?? this.name,
      text: text ?? this.text,
      style: style ?? this.style,
      alignment: alignment ?? this.alignment,
      wordWrap: wordWrap ?? this.wordWrap,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'rect': {'l': rect.left, 't': rect.top, 'w': rect.width, 'h': rect.height},
      'name': name,
      'text': text,
      // TODO: Serialize TextStyle more robustly
      'style': {
        'fontSize': style.fontSize,
        'color': style.color?.value,
      },
      'alignment': alignment.toString(),
      'wordWrap': wordWrap,
    };
  }

  factory TextElement.fromJson(Map<String, dynamic> json) {
    final rectJson = json['rect'];
    final styleJson = json['style'];
    return TextElement(
      id: json['id'],
      rect: Rect.fromLTWH(rectJson['l'], rectJson['t'], rectJson['w'], rectJson['h']),
      name: json['name'],
      text: json['text'],
      style: TextStyle(
        fontSize: styleJson['fontSize'],
        color: styleJson['color'] != null ? Color(styleJson['color']) : Colors.black,
      ),
      alignment: TextAlign.values.firstWhere((e) => e.toString() == json['alignment']),
      wordWrap: json['wordWrap'],
    );
  }
}
