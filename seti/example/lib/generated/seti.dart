import 'package:flutter/widgets.dart';
import 'data.dart';

class SetiIcon extends StatelessWidget {
  final String fileName;
  final double size;

  SetiIcon(String fileName, {this.size})
      : this.fileName = fileName.toLowerCase();

  @override
  Widget build(BuildContext context) {
    String key;

    if (iconSetMap.containsKey(fileName)) {
      key = fileName;
    } else {
      var chunks = fileName.split('.').sublist(1);
      while (chunks.isNotEmpty) {
        var k = '.' + chunks.join();
        if (iconSetMap.containsKey(k)) {
          key = k;
          break;
        }
        chunks = chunks.sublist(1);
      }
    }

    if (key == null) {
      key = '.txt';
    }

    return Icon(
      IconData(
        iconSetMap[key].codePoint,
        fontFamily: 'Seti',
        
      ),
      color: Color(iconSetMap[key].color),
      size: size,
    );
  }
}
