import 'dart:convert';
import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:http/http.dart' as http;

// #123, #112233 -> 0xff112233
String convertColor(String cssHex) {
  if (cssHex == null) return null;

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
import 'meta.dart';
''';

  var res = await http.get(
      'https://raw.githubusercontent.com/microsoft/vscode/master/extensions/theme-seti/icons/vs-seti-icon-theme.json');
  var data = json.decode(res.body);

  code += 'const iconDefinitions = {';
  // List<SetiMeta> items;
  data['iconDefinitions'].forEach((String k, v) {
    if (k.endsWith('_light')) {
      var noLightKey = k.substring(0, k.length - 6);
      data['iconDefinitions'][noLightKey]['fontColorLight'] = v['fontColor'];
    }
  });

  for (var entry in data['iconDefinitions'].entries) {
    if (entry.key.endsWith('_light')) continue;

    var codePoint =
        (entry.value['fontCharacter'] as String).replaceFirst('\\', '0x');
    var color = convertColor(entry.value['fontColor']);
    var lightColor = convertColor(entry.value['fontColorLight']);
    code += '"${entry.key}": SetiMeta($codePoint, $color, $lightColor),';
  }
  code += '};';

  code += 'const setiNameMap = ${json.encode(data['fileNames'])};';
  code += 'const setiExtensionMap = ${json.encode(data['fileExtensions'])};';

  await File('./lib/data.dart').writeAsString(DartFormatter().format(code));
}
