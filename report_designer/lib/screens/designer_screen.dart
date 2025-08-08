import 'package:flutter/material.dart';
import 'package:report_designer/models/models.dart';
import 'package:report_designer/widgets/canvas_panel.dart';
import 'package:report_designer/widgets/properties_panel.dart';
import 'package:report_designer/widgets/toolbox_panel.dart';

class DesignerScreen extends StatefulWidget {
  const DesignerScreen({super.key});

  @override
  State<DesignerScreen> createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  // --- State Lifted Up ---
  List<ReportElement> _elements = [
    TextElement(
      id: 'txt1',
      rect: const Rect.fromLTWH(50, 50, 200, 40),
      text: '这是一个示例文本',
      style: const TextStyle(fontSize: 14, color: Colors.black),
    ),
    TextElement(
      id: 'txt2',
      rect: const Rect.fromLTWH(150, 150, 150, 80),
      text: '主从结构报表设计器\n支持文字自动换行',
      style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
    ),
  ];
  String? _selectedElementId;
  // --- End of State ---

  void _selectElement(String? elementId) {
    setState(() {
      _selectedElementId = elementId;
    });
  }

  void _updateElement(ReportElement element) {
    setState(() {
      final index = _elements.indexWhere((e) => e.id == element.id);
      if (index != -1) {
        _elements[index] = element;
      }
    });
  }

  ReportElement? get _selectedElement {
    if (_selectedElementId == null) return null;
    return _elements.firstWhere((e) => e.id == _selectedElementId);
  }

import 'dart:typed_data';
import 'package:printing/printing.dart';
import 'package:report_designer/rendering/report_renderer.dart';

  void _onPreviewPressed() {
    // Create a document from the current state
    final reportDoc = ReportDocument(
      pages: [
        ReportPage(elements: _elements),
      ],
    );

    // Render and show preview
    Printing.layoutPdf(
      onLayout: (format) => ReportRenderer.render(reportDoc),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Designer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            tooltip: 'Preview & Print',
            onPressed: _onPreviewPressed,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // 1. Toolbox Panel
          const ToolboxPanel(),

          const VerticalDivider(width: 1, thickness: 1),

          // 2. Canvas Panel
          Expanded(
            child: CanvasPanel(
              elements: _elements,
              selectedElementId: _selectedElementId,
              onSelectElement: _selectElement,
              onUpdateElement: _updateElement,
            ),
          ),

          const VerticalDivider(width: 1, thickness: 1),

          // 3. Properties Panel
          PropertiesPanel(
            selectedElement: _selectedElement,
            onUpdateElement: _updateElement,
          ),
        ],
      ),
    );
  }
}
