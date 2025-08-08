import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:report_designer/models/models.dart';

class ReportRenderer {
  /// Renders a [ReportDocument] into a PDF file represented by a [Uint8List].
  static Future<Uint8List> render(ReportDocument doc) async {
    final pdf = pw.Document();

    for (final page in doc.pages) {
      pdf.addPage(_buildPdfPage(page));
    }

    return pdf.save();
  }

  static pw.Page _buildPdfPage(ReportPage page) {
    return pw.Page(
      pageFormat: PdfPageFormat(page.size.width, page.size.height),
      margin: pw.EdgeInsets.fromLTRB(
        page.margins.left,
        page.margins.top,
        page.margins.right,
        page.margins.bottom,
      ),
      build: (pw.Context context) {
        return pw.Stack(
          children: page.elements.map((e) => _buildPdfElement(e)).toList(),
        );
      },
    );
  }

  static pw.Widget _buildPdfElement(ReportElement element) {
    // Note: PDF coordinate system's origin (0,0) is at the bottom-left,
    // while Flutter's is at the top-left. We need to convert coordinates.
    // However, for simplicity here, we'll assume the pw.Stack behaves similarly
    // enough for top-left positioning if we specify it. A more robust solution
    // might require flipping the Y-axis.

    if (element is TextElement) {
      return pw.Positioned(
        left: element.rect.left,
        top: element.rect.top,
        width: element.rect.width,
        height: element.rect.height,
        child: pw.Text(
          element.text,
          textAlign: _toPdfTextAlign(element.alignment),
          style: pw.TextStyle(
            fontSize: element.style.fontSize,
            color: _toPdfColor(element.style.color),
            // TODO: Add font support
          ),
        ),
      );
    }
    // TODO: Add rendering for other element types like ImageElement.

    return pw.Positioned(
      left: element.rect.left,
      top: element.rect.top,
      width: element.rect.width,
      height: element.rect.height,
      child: pw.Container(
        color: PdfColors.red,
        child: pw.Text('Unimplemented Element: ${element.type}'),
      ),
    );
  }

  static PdfColor _toPdfColor(Color? color) {
    if (color == null) return PdfColors.black;
    return PdfColor.fromInt(color.value);
  }

  static pw.TextAlign _toPdfTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.left:
        return pw.TextAlign.left;
      case TextAlign.right:
        return pw.TextAlign.right;
      case TextAlign.center:
        return pw.TextAlign.center;
      case TextAlign.justify:
        return pw.TextAlign.justify;
      default:
        return pw.TextAlign.left;
    }
  }
}
