English | [简体中文](./README_zh-CN.md)

# smart_validator

[![pub package](https://img.shields.io/pub/v/smart_validator.svg)](https://pub.dartlang.org/packages/smart_validator)

A string or numeric validator for flutter，Including email, phone and so on

## Usage
To use this plugin, add `smart_validator` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

## Example

``` dart
// Import package
import 'package:smart_validator/smart_validator.dart';

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
