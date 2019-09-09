import 'dart:convert';
import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:http/http.dart' as http;

// #123, #112233 -> 0xff112233
String convertColor(String cssHex) {
  if (cssHex == null) {
    return '0xff000000'; // FIXME:
  }

  if (cssHex.startsWith('#')) {
    cssHex = cssHex.substring(1);
  }
  if (cssHex.length == 3) {
    cssHex = cssHex.split('').map((char) => char + char).join('');
  }
  return '0xff' + cssHex;
}

main(List<String> args) async {
  var code = '''// GENERATED CODE - DO NOT MODIFY BY HAND
import 'dart:ui';
import 'meta.dart';
''';

  var res = await http.get(
      'https://raw.githubusercontent.com/microsoft/vscode/master/extensions/theme-seti/icons/vs-seti-icon-theme.json');
  var data = json.decode(res.body);

  code += 'const iconDefinitions = {';
  for (var entry in data['iconDefinitions'].entries) {
    var codePoint =
        (entry.value['fontCharacter'] as String).replaceFirst('\\', '0x');
    var colorValue = convertColor(entry.value['fontColor']);
    code += '"${entry.key}": SetiMeta($codePoint, Color($colorValue)),';
  }
  code += '};';

  var metaString = json.encode(
      {'extensions': data['fileExtensions'], 'names': data['fileNames']});
  code += 'const setiMeta = $metaString;';

  var lightString = json.encode({
    'extensions': data['light']['fileExtensions'],
    'names': data['light']['fileNames']
  });
  code += 'const setiLightMeta = $lightString;';

  await File('./lib/data.dart').writeAsString(DartFormatter().format(code));
}
