import 'dart:io';
import 'dart:typed_data';

void downloadFile(Uint8List bytes, String fileName, String mimeType) {
  try {
    // En escritorio o Android guarda en la carpeta actual o temp
    final file = File(fileName);
    file.writeAsBytesSync(bytes);
  } catch (_) {}
}

void openWhatsAppWeb(String text) {
  // En móvil o escritorio
}

void triggerPrint() {
  // Impresión en escritorio
}

