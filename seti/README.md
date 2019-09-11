# seti-flutter

[![pub](https://img.shields.io/pub/v/seti)](https://pub.dev/packages/seti)

[Seti file icons](https://github.com/jesseweed/seti-ui#current-icons) for Flutter. Show file icon for different file types, auto detected by file name.

## Usage

```dart
import 'package:flutter/widgets.dart';
import 'package:seti/seti.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SetiIcon(
      // File name
      'main.dart',

      // Icon size
      size: 32,
    );
  }
}
```

## License

MIT
