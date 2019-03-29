[English](./README.md) | 简体中文

# validator

<!--[![pub package](https://img.shields.io/pub/v/flutter_icons.svg)](https://pub.dartlang.org/packages/flutter_icons)-->

一个用于验证字符串和数字的flutter插件包，包括邮箱、手机等等

<!--## Usage
To use this plugin, add `flutter_icons` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).-->

## 示例

``` dart
// 引入包
import 'package:validator/validator.dart';

 Validator validator = Validator(rules: {
    "param1": [
      Required(message: "param1不能为空"),
      Number(message: "param1必须是数字"),
      Range(max: Section(value: 10), min: Section(value: 1), message: "param1必须在1到10之间")
    ],
  });

   print(validator.validate("param1", ""));
   // ValidResult{ pass: false, message: param1不能为空, filteredMsg: param1不能为空 }

   print(validator.validate("param1", "sdfsf"));
    // ValidResult{ pass: false, message: param1必须是数字, filteredMsg: param1必须是数字 }

   print(validator.validate("param1", "20"));
   // ValidResult{ pass: false, message: param1必须在1到10之间, filteredMsg: param1必须在1到10之间 }

   print(validator.validate("param1", "5"));
   // ValidResult{ pass: true, message: param1必须在1到10之间, filteredMsg:  }

```
