import 'package:flutter/material.dart';
import 'package:report_designer/models/models.dart';

class PropertiesPanel extends StatefulWidget {
  const PropertiesPanel({
    super.key,
    this.selectedElement,
    required this.onUpdateElement,
  });

  final ReportElement? selectedElement;
  final ValueChanged<ReportElement> onUpdateElement;

  @override
  State<PropertiesPanel> createState() => _PropertiesPanelState();
}

class _PropertiesPanelState extends State<PropertiesPanel> {
  // Controllers to manage the text fields
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PropertiesPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update text controller when the selected element changes
    if (widget.selectedElement != oldWidget.selectedElement) {
      if (widget.selectedElement is TextElement) {
        final text = (widget.selectedElement as TextElement).text;
        _textController.text = text;
        // Move cursor to the end
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.all(12.0),
      child: widget.selectedElement == null
          ? const Center(child: Text('No element selected'))
          : _buildProperties(widget.selectedElement!),
    );
  }

  Widget _buildProperties(ReportElement element) {
    if (element is TextElement) {
      return _buildTextProperties(element);
    }
    // TODO: Add property editors for other element types
    return Text('Properties for ${element.type}');
  }

  Widget _buildTextProperties(TextElement element) {
    return ListView(
      children: [
        Text(
          'Text Element Properties',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),

        // --- Text Content ---
        const Text('Content', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          maxLines: 5,
          onChanged: (value) {
            widget.onUpdateElement(element.copyWith(text: value));
          },
        ),
        const SizedBox(height: 16),

        // --- Position & Size (Read-only for now) ---
        const Text('Layout', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('X: ${element.rect.left.toStringAsFixed(1)}'),
        Text('Y: ${element.rect.top.toStringAsFixed(1)}'),
        Text('Width: ${element.rect.width.toStringAsFixed(1)}'),
        Text('Height: ${element.rect.height.toStringAsFixed(1)}'),

      ],
    );
  }
}
