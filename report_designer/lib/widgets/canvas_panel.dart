import 'package:flutter/material.dart';
import 'package:report_designer/models/models.dart';
import 'dart:math';

class CanvasPanel extends StatelessWidget {
  const CanvasPanel({
    super.key,
    required this.elements,
    this.selectedElementId,
    required this.onSelectElement,
    required this.onUpdateElement,
  });

  final List<ReportElement> elements;
  final String? selectedElementId;
  final ValueChanged<String?> onSelectElement;
  final ValueChanged<ReportElement> onUpdateElement;

  @override
  Widget build(BuildContext context) {
    // A visual representation of the paper
    return GestureDetector(
      onTap: () => onSelectElement(null), // Deselect when tapping the background
      child: Container(
        color: Colors.grey[350],
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: PaperSize.a4.width / PaperSize.a4.height,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: _buildElementWidgets(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildElementWidgets(BuildContext context) {
    // We need the RenderBox of the stack to calculate the correct offset
    final stackBox = context.findRenderObject() as RenderBox?;

    return elements.map((element) {
      Widget child;
      if (element is TextElement) {
        child = Text(
          element.text,
          style: element.style,
          textAlign: element.alignment,
          maxLines: element.wordWrap ? null : 1,
          overflow: TextOverflow.clip,
        );
      } else {
        child = Container(color: Colors.red, child: const Text('Unknown Element'));
      }

      // Wrap with GestureDetector for selection
      child = GestureDetector(
        onTap: () => onSelectElement(element.id),
        child: Container(
          width: element.rect.width,
          height: element.rect.height,
          decoration: BoxDecoration(
            border: selectedElementId == element.id
                ? Border.all(color: Colors.blue, width: 1.5, strokeAlign: BorderSide.strokeAlignOutside)
                : null,
          ),
          child: child,
        ),
      );

      // Wrap with Draggable
      return Positioned(
        left: element.rect.left,
        top: element.rect.top,
        width: element.rect.width,
        height: element.rect.height,
        child: Draggable(
          feedback: Material(
            color: Colors.transparent,
            child: Opacity(opacity: 0.7, child: child),
          ),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            if (stackBox == null) return;
            // Convert global drag offset to local offset within the Stack
            final localOffset = stackBox.globalToLocal(details.offset);
            final newRect = Rect.fromLTWH(
              max(0, localOffset.dx),
              max(0, localOffset.dy),
              element.rect.width,
              element.rect.height,
            );
            onUpdateElement(element.copyWith(rect: newRect));
          },
          child: child,
        ),
      );
    }).toList();
  }
}
