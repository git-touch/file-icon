import 'package:flutter/widgets.dart';
import 'data.dart';

class SetiIcon extends StatelessWidget {
  final String fileName;
  final bool light;
  final double size;

  SetiIcon(String fileName, {this.light = false, this.size})
      : this.fileName = fileName.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final meta = light ? setiLightMeta : setiMeta;
    String key;

    if (meta['names'].containsKey(fileName)) {
      key = meta['names'][fileName];
    } else {
      var ext = fileName.split('.').last;
      if (meta['extensions'].containsKey(ext)) {
        key = meta['extensions'][ext];
      }
    }

    if (key == null) {
      key = light ? '_default_light' : '_default';
    }

    var m = iconDefinitions[key];
    return Icon(
      IconData(m.codePoint, fontFamily: 'Seti', fontPackage: 'seti'),
      color: m.color,
      size: size,
    );
  }
}
