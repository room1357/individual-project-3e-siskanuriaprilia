import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'dowload_utils.dart';

Future<void> saveCSV(String csv, String filename) async {
  if (kIsWeb) {
    downloadCSV(csv, filename);
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';
    final file = File(path);
    await file.writeAsString(csv);
    print('CSV berhasil disimpan di $path');
  }
}
