import 'report_page.dart';

/// Represents the entire report document.
/// This is the top-level container that holds all the pages.
class ReportDocument {
  ReportDocument({
    this.pages = const [],
  });

  final List<ReportPage> pages;

  ReportDocument copyWith({
    List<ReportPage>? pages,
  }) {
    return ReportDocument(
      pages: pages ?? this.pages,
    );
  }

  factory ReportDocument.fromJson(Map<String, dynamic> json) {
    return ReportDocument(
      pages: (json['pages'] as List)
          .map((item) => ReportPage.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pages': pages.map((p) => p.toJson()).toList(),
    };
  }
}
