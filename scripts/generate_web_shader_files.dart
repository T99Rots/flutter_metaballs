// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

void generateShadersClassFromDir(Directory shadersDir) async {
  // Get a list of all file system entities (files and directories) in the shaders directory
  final List<FileSystemEntity> fileSystemEntities = shadersDir.listSync();

  // Create a list to store only the files (not directories)
  final List<File> files = <File>[];

  // Iterate over the file system entities and add only the files to the list
  for (FileSystemEntity fileSystemEntity in fileSystemEntities) {
    if (FileSystemEntity.isDirectorySync(fileSystemEntity.path)) {
      continue;
    }

    files.add(File(fileSystemEntity.path));
  }

  // Create a list to store the shader code strings
  final List<String> shaderCodeList = <String>[];

  // Read the contents of each file and create a string containing a Dart constant declaration for the code
  for (final File file in files) {
    final String code = await file.readAsString();
    final String name = path.basename(file.path).camelCase;
    final String wrappedCode = '  static const String $name = """$code""";';
    shaderCodeList.add(wrappedCode);
  }

  // Create a new file called web_shaders.dart in the lib/src/generated directory
  final File destinationFile = File(path.join(
    Directory.current.path,
    'lib/src/generated/web_shaders.dart',
  ));

  // Wrap the list of shader code strings in a Dart class definition
  final String wrappedCode = 'class WebShaders {\n  const WebShaders._();\n\n${shaderCodeList.join('\n\n')}\n}';

  // Write the code to the web_shaders.dart file
  await destinationFile.writeAsString(wrappedCode);
}

void main(List<String> arguments) async {
  final bool watch = arguments.contains('--watch');

  // Get a reference to the shaders directory
  final Directory shadersDir = Directory('shaders/webgl');

  if (watch) {
    print('Watch mode. Waiting for changes.');
    shadersDir.watch().listen((_) {
      print('changes, regenerating shaders files.');
      generateShadersClassFromDir(shadersDir);
    });
  }

  generateShadersClassFromDir(shadersDir);
}
