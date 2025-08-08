import 'package:label_printer/bartender_service.dart';

void main() {
  final bartenderService = BartenderService();

  try {
    // 1. Initialize the BarTender engine
    bartenderService.init();
    print('BarTender engine initialized.');

    // 2. Open a label template
    // IMPORTANT: Replace with the actual path to your .btw file
    final templatePath = r'C:\Path\To\Your\Template.btw';
    bartenderService.open(templatePath);
    print('Template opened: $templatePath');

    // 3. Set the printer
    // IMPORTANT: Replace with your printer name
    final printerName = 'MyLabelPrinter';
    bartenderService.setPrinter(printerName);
    print('Printer set to: $printerName');

    // 4. Set variables
    bartenderService.setVariable('ProductName', 'Flutter Widget');
    bartenderService.setVariable('ProductID', '12345-ABC');
    bartenderService.setVariable('Price', '19.99');
    print('Variables set.');

    // 5. Print the label (3 copies)
    bartenderService.printLabel(copies: 3);
    print('Label (3 copies) sent to printer.');

  } catch (e) {
    print('An error occurred: $e');
  } finally {
    // 6. Close the BarTender engine
    bartenderService.close();
    print('BarTender engine closed.');
  }
}
