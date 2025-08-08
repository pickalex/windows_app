import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class BartenderService {
  static const CLSID_BarTender = '{B9425246-4131-11D2-BE48-004005A04EDF}';
  static const IID_IBarTender = '{B942524C-4131-11D2-BE48-004005A04EDF}';

  late Pointer<COMObject> _btApp;
  late Pointer<COMObject> _btFormat;

  void init() {
    final hr = CoInitializeEx(
        nullptr, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    if (FAILED(hr)) {
      throw Exception('Failed to initialize COM: $hr');
    }

    final clsid = CLSIDFromString(TEXT(CLSID_BarTender));
    final iid = IIDFromString(TEXT(IID_IBarTender));

    try {
      _btApp = Pointer<COMObject>.fromAddress(
          CoCreateInstance(clsid, nullptr, CLSCTX_LOCAL_SERVER, iid));
    } finally {
      free(clsid);
      free(iid);
    }
  }

  void open(String templatePath) {
    final formats = calloc<Pointer<COMObject>>();
    final dispatch = IDispatch(_btApp);

    try {
      final getFormats = dispatch.vtable.elementAt(7).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(Pointer, Pointer<Pointer<COMObject>>)>>>().value;

      var hr = getFormats(_btApp.cast(), formats);
      if (FAILED(hr)) {
        throw Exception('Failed to get formats collection: $hr');
      }

      final formatsDispatch = IDispatch(formats.value);
      final open = formatsDispatch.vtable.elementAt(8).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(
                      Pointer,
                      Pointer<Utf16>,
                      Int32,
                      Pointer<Utf16>,
                      Pointer<Pointer<COMObject>>)>>>().value;

      _btFormat = calloc<Pointer<COMObject>>();
      final templatePathNative = templatePath.toNativeUtf16();

      hr = open(formats.value.cast(), templatePathNative, 0, ''.toNativeUtf16(), _btFormat);

      free(templatePathNative);

      if (FAILED(hr)) {
        throw Exception('Failed to open template: $hr');
      }

    } finally {
      dispatch.Release();
      free(formats);
    }
  }

  void setPrinter(String printerName) {
    final dispatch = IDispatch(_btFormat);
    final setPrinterName = dispatch.vtable.elementAt(10).cast<
        Pointer<
            NativeFunction<
                Int32 Function(Pointer, Pointer<Utf16>)>>>().value;

    final printerNameNative = printerName.toNativeUtf16();
    try {
      final hr = setPrinterName(_btFormat.cast(), printerNameNative);
      if (FAILED(hr)) {
        throw Exception('Failed to set printer: $hr');
      }
    } finally {
      free(printerNameNative);
      dispatch.Release();
    }
  }

  void setVariable(String name, String value) {
    final dispatch = IDispatch(_btFormat);
    final namedSubStrings = calloc<Pointer<COMObject>>();

    try {
      final getNamedSubStrings = dispatch.vtable.elementAt(13).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(Pointer, Pointer<Pointer<COMObject>>)>>>().value;

      var hr = getNamedSubStrings(_btFormat.cast(), namedSubStrings);
      if (FAILED(hr)) {
        throw Exception('Failed to get named substrings: $hr');
      }

      final namedSubStringsDispatch = IDispatch(namedSubStrings.value);
      final setNamedSubStringValue = namedSubStringsDispatch.vtable.elementAt(9).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(Pointer, Pointer<Utf16>, Pointer<Utf16>)>>>().value;

      final nameNative = name.toNativeUtf16();
      final valueNative = value.toNativeUtf16();

      hr = setNamedSubStringValue(namedSubStrings.value.cast(), nameNative, valueNative);

      free(nameNative);
      free(valueNative);

      if (FAILED(hr)) {
        throw Exception('Failed to set variable: $hr');
      }
    } finally {
      dispatch.Release();
      free(namedSubStrings);
    }
  }

  void printLabel({int copies = 1}) {
    final dispatch = IDispatch(_btFormat);
    try {
      // Set the number of identical copies to print.
      // This corresponds to the 'Identical Copies of Label' setting in BarTender.
      // The v-table index for put_IdenticalCopiesOfLabel is 24.
      final setCopies = dispatch.vtable.elementAt(24).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(Pointer, Int32)>>>().value;

      var hr = setCopies(_btFormat.cast(), copies);
      if (FAILED(hr)) {
          throw Exception('Failed to set number of copies: $hr');
      }

      // Call the PrintOut method.
      // The v-table index for PrintOut is 16.
      final printOut = dispatch.vtable.elementAt(16).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(Pointer, Pointer<Utf16>, Int32)>>>().value;

      hr = printOut(_btFormat.cast(), ''.toNativeUtf16(), 0);
      if (FAILED(hr)) {
        throw Exception('Failed to print: $hr');
      }
    } finally {
      dispatch.Release();
    }
  }

  void showPreviewDialog() {
    final dispatch = IDispatch(_btFormat);
    try {
      final methodName = 'ShowPrintDialog'.toNativeUtf16();
      final dispId = calloc<Int32>();

      try {
        var hr = dispatch.GetIDsOfNames(
            IID_NULL,
            [methodName].toPointerArray(),
            1,
            LOCALE_USER_DEFAULT,
            dispId);

        if (FAILED(hr)) {
          throw Exception('Failed to get DispID for ShowPrintDialog: $hr');
        }

        final params = calloc<DISPPARAMS>();
        // No arguments for ShowPrintDialog
        params.ref.cArgs = 0;
        params.ref.cNamedArgs = 0;

        hr = dispatch.Invoke(dispId.value, IID_NULL, LOCALE_USER_DEFAULT,
            DISPATCH_METHOD, params, nullptr, nullptr, nullptr);

        if (FAILED(hr)) {
          throw Exception('Failed to invoke ShowPrintDialog: $hr');
        }
      } finally {
        free(methodName);
        free(dispId);
      }
    } finally {
      dispatch.Release();
    }
  }

  void close() {
    if (_btFormat != null) {
      final dispatch = IDispatch(_btFormat);
      dispatch.Release();
    }
    if (_btApp != null) {
      final dispatch = IDispatch(_btApp);
      final quit = dispatch.vtable.elementAt(10).cast<
          Pointer<
              NativeFunction<
                  Int32 Function(Pointer, Int32)>>>().value;
      quit(_btApp.cast(), 0);
      dispatch.Release();
    }
    CoUninitialize();
  }
}
