import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadPDF(Uint8List pdfBytes, String filename) async {
  await _requestPermission();

  final dir = await _getDownloadDirectory();
  final file = File('${dir.path}/$filename');

  await file.writeAsBytes(pdfBytes);
  await OpenFilex.open(file.path);
}

Future<void> downloadCSV(String csv, String filename) async {
  await _requestPermission();

  final dir = await _getDownloadDirectory();
  final file = File('${dir.path}/$filename');

  await file.writeAsString(csv);
  await OpenFilex.open(file.path);
}

Future<Directory> _getDownloadDirectory() async {
  Directory? directory;

  if (Platform.isAndroid) {
    // Coba dapatkan folder Download
    final dir = Directory('/storage/emulated/0/Download');
    if (await dir.exists()) {
      directory = dir;
    } else {
      directory = await getExternalStorageDirectory();
    }
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  return directory!;
}

Future<void> _requestPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    final manageStatus = await Permission.manageExternalStorage.request();

    if (!status.isGranted && !manageStatus.isGranted) {
      throw Exception("Izin penyimpanan ditolak");
    }
  }
}
