import 'dart:typed_data';

class PrinterImageModel {
  PrinterImageModel({
    required this.ipAddress,
    required this.port,
    this.image,
  });

  String ipAddress;
  int port;
  Uint8List? image;
}
