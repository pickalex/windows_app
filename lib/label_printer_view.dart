import 'package:flutter/material.dart';
import 'package:label_printer/bartender_service.dart';

class LabelPrinterView extends StatefulWidget {
  const LabelPrinterView({super.key});

  @override
  State<LabelPrinterView> createState() => _LabelPrinterViewState();
}

class _LabelPrinterViewState extends State<LabelPrinterView> {
  final _formKey = GlobalKey<FormState>();
  final _templatePathController = TextEditingController(text: r'C:\Path\To\Your\Template.btw');
  final _printerNameController = TextEditingController(text: 'MyLabelPrinter');
  final _copiesController = TextEditingController(text: '1');
  final _productNameController = TextEditingController(text: 'Flutter Widget');
  final _productIdController = TextEditingController(text: '12345-ABC');
  final _priceController = TextEditingController(text: '19.99');

  String _statusMessage = '';
  bool _isBusy = false;

  Future<void> _interactWithBarTender(Function(BartenderService) action) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isBusy = true;
      _statusMessage = 'Communicating with BarTender...';
    });

    try {
      final bartenderService = BartenderService();
      bartenderService.init();
      bartenderService.open(_templatePathController.text);
      bartenderService.setPrinter(_printerNameController.text);
      bartenderService.setVariable('ProductName', _productNameController.text);
      bartenderService.setVariable('ProductID', _productIdController.text);
      bartenderService.setVariable('Price', _priceController.text);

      action(bartenderService);

      bartenderService.close();
      setState(() {
        _statusMessage = 'Action completed successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isBusy = false;
      });
    }
  }

  Future<void> _printLabel() async {
    final copies = int.parse(_copiesController.text);
    await _interactWithBarTender((service) {
      service.printLabel(copies: copies);
    });
  }

  Future<void> _showPreview() async {
    await _interactWithBarTender((service) {
      service.showPreviewDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BarTender Label Printer'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard(
                  title: 'Configuration',
                  children: [
                    TextFormField(
                      controller: _templatePathController,
                      decoration: const InputDecoration(labelText: 'Template Path (.btw)'),
                      validator: (value) => value!.isEmpty ? 'Please enter a path' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _printerNameController,
                      decoration: const InputDecoration(labelText: 'Printer Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter a printer name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _copiesController,
                      decoration: const InputDecoration(labelText: 'Number of Copies'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of copies';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 1) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildCard(
                  title: 'Label Data',
                  children: [
                    TextFormField(
                      controller: _productNameController,
                      decoration: const InputDecoration(labelText: 'Product Name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _productIdController,
                      decoration: const InputDecoration(labelText: 'Product ID'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isBusy ? null : _showPreview,
                        icon: const Icon(Icons.visibility),
                        label: const Text('PREVIEW'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.grey[600],
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isBusy ? null : _printLabel,
                        icon: _isBusy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.print),
                        label: Text(_isBusy ? 'BUSY...' : 'PRINT LABEL'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_statusMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _statusMessage.startsWith('Error') ? Colors.red[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _statusMessage.startsWith('Error') ? Colors.red[800] : Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _templatePathController.dispose();
    _printerNameController.dispose();
    _productNameController.dispose();
    _productIdController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
