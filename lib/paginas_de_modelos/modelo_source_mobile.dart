import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> downloadModelToCache(String modelUrl, String modelId) async {
  final uri = Uri.parse(modelUrl);
  if (uri.scheme != 'https') {
    throw const FormatException('La URL del modelo debe usar HTTPS.');
  }

  final cacheDirectory = await getTemporaryDirectory();
  final modelCacheDirectory = Directory(
    '${cacheDirectory.path}${Platform.pathSeparator}modelos',
  );
  await modelCacheDirectory.create(recursive: true);

  final safeModelId = modelId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  final cacheKey = _stableHash(uri.path);
  final cachedFile = File(
    '${modelCacheDirectory.path}${Platform.pathSeparator}'
    'modelo-$safeModelId-$cacheKey.glb',
  );
  if (await cachedFile.exists() && await cachedFile.length() > 0) {
    return Uri.file(cachedFile.path).toString();
  }

  final temporaryFile = File(
    '${cachedFile.path}.${DateTime.now().microsecondsSinceEpoch}.part',
  );
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      final statusCode = response.statusCode;
      await response.drain<void>();
      throw HttpException(
        'El servidor respondió con HTTP $statusCode al descargar el modelo.',
        uri: uri,
      );
    }

    await response.pipe(temporaryFile.openWrite());
    if (await temporaryFile.length() == 0) {
      throw const FormatException('El archivo del modelo está vacío.');
    }

    if (await cachedFile.exists()) {
      await cachedFile.delete();
    }
    final file = await temporaryFile.rename(cachedFile.path);
    return Uri.file(file.path).toString();
  } catch (_) {
    if (await temporaryFile.exists()) {
      await temporaryFile.delete();
    }
    rethrow;
  } finally {
    client.close(force: true);
  }
}

String _stableHash(String value) {
  var hash = 0x811c9dc5;
  for (final codeUnit in value.codeUnits) {
    hash = ((hash ^ codeUnit) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
