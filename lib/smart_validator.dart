export 'validator_tag.dart';
abstract class Rule {
  ValidResult validate(String value);
}

/// 验证结果对象
class ValidResult {
  ValidResult({this.pass, this.message});

  final bool pass;
  final String message;

  get filteredMsg => pass == true ? "" : message;

  @override
  String toString() {
    return 'ValidResult{ pass: $pass, message: $message, filteredMsg: $filteredMsg }';
  }
}

typedef StringCallback = String Function();
typedef DoubleCallback = double Function();
typedef IntCallback = int Function();

_message(dynamic message){
  if(message is String)return message;
  if(message is StringCallback)return message();
  throw "message does not provide any types other than String and StringCallback";
}

_comparativeValue(dynamic comparativeValue){
  if(comparativeValue is int)return comparativeValue;
  if(comparativeValue is double)return comparativeValue;
  if(comparativeValue is DoubleCallback)return comparativeValue();
  if(comparativeValue is IntCallback)return comparativeValue();
  throw "comparativeValue do not provide types other than int, double, IntCallback, and NumberCallback";
}



///必填验证
class Required extends Rule {
  Required({this.message});

  final dynamic message;


  @override
  ValidResult validate(String value) => ValidResult(pass: value != "" && value != null, message: _message(message));
}

/// 邮箱验证
class Email extends Rule {
  Email({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(
      pass: RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
          .hasMatch(value),
      message: _message(message));
}

/// 数字验证,可包含小数点
class Number extends Rule {
  Number({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$").hasMatch(value), message: _message(message));
}

/// 数字验证， 不带小数点
class Digit extends Rule {
  Digit({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^\d+$").hasMatch(value), message: _message(message));
}

/// qq验证
class QQ extends Rule {
  QQ({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^[1-9][0-9]{4,14}$").hasMatch(value), message: _message(message));
}

/// 手机号验证
class Mobile extends Rule {
  Mobile({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^((1)+\d{10})$").hasMatch(value) && value.length == 11, message: _message(message));
}

/// 电话号码验证
class Phone extends Rule {
  Phone({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(
      pass:
          RegExp(r"^((\d{10,11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)$")
              .hasMatch(value),
      message: _message(message));
}

/// 非法字符验证
class IllegalChar extends Rule {
  IllegalChar({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"""/[&\\<>'"]""").hasMatch(value) && value.length == 11, message: _message(message));
}

/// 邮编验证
class PostCode extends Rule {
  PostCode({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^[0-9]{6}$").hasMatch(value) && value.length == 11, message: _message(message));
}

/// 中文和字母
class ChineseLetter extends Rule {
  ChineseLetter({this.message});

  final dynamic message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^([\u4e00-\u9fa5]|[a-zA-Z])*$").hasMatch(value), message: _message(message));
}

/// 数字字符串验证
class NumberLetter extends Rule{
  NumberLetter({this.message});

  final dynamic message;
  
  @override
  ValidResult validate(String value)=>ValidResult(pass: RegExp(r"^([0-9]|[a-zA-Z])*$").hasMatch(value) ,message: _message(message));
  
}

/// 最小长度验证
class MinLength extends Rule {
  MinLength({this.comparativeValue, this.message, this.closed = true});

  final int comparativeValue;
  final dynamic message;
  final bool closed;

  @override
  ValidResult validate(value) => ValidResult(pass: closed == true ? value.length >= _comparativeValue(comparativeValue) : value.length > _comparativeValue(comparativeValue), message: _message(message));
}

/// 最大长度验证
class MaxLength extends Rule {
  MaxLength({this.comparativeValue, this.message, this.closed = true});


  final int comparativeValue;
  final dynamic message;
  final bool closed;

  @override
  ValidResult validate(String value) => ValidResult(pass: closed == true ? value.length <= _comparativeValue(comparativeValue) : value.length < _comparativeValue(comparativeValue), message: _message(message));
}

class Section {
  Section({this.comparativeValue, this.closed});
  
  final dynamic comparativeValue;
  final bool closed;

  @override
  String toString() {
    return 'Section{comparativeValue: $comparativeValue, closed: $closed}';
  }


}

/// 范围长度验证
class RangeLength extends Rule {
  RangeLength({this.min, this.max, this.message});
  
  final Section min;
  final dynamic message;
  final Section max;

  @override
  ValidResult validate(String value) {
    bool minBoolValue;
    bool maxBoolValue;
    if (min.closed == true) {
      minBoolValue = value.length >= _comparativeValue(min.comparativeValue);
    } else {
      minBoolValue = value.length > _comparativeValue(min.comparativeValue);
    }
    if (max.closed == true) {
      maxBoolValue = value.length <= _comparativeValue(max.comparativeValue);
    } else {
      maxBoolValue = value.length < _comparativeValue(max.comparativeValue);
    }
    return ValidResult(pass: minBoolValue == true && maxBoolValue == true, message: _message(message));
  }
}

/// 范围验证
class Range extends Rule {
  Range({this.min, this.max, this.message});
  
  final Section min;
  final dynamic message;
  final Section max;

  @override
  ValidResult validate(String value) {
    bool minBoolValue;
    bool maxBoolValue;
    if (min.closed == true) {
      minBoolValue = int.parse(value) >= _comparativeValue(min.comparativeValue);
    } else {
      minBoolValue = int.parse(value) > _comparativeValue(min.comparativeValue);
    }
    if (max.closed == true) {
      maxBoolValue = int.parse(value) <= _comparativeValue(max.comparativeValue);
    } else {
      maxBoolValue = int.parse(value) < _comparativeValue(max.comparativeValue);
    }
    return ValidResult(pass: minBoolValue == true && maxBoolValue == true, message: _message(message));
  }
}

/// 最小值验证
class Min extends Rule {
  Min({this.comparativeValue, this.message, this.closed = true});
  
  final dynamic comparativeValue;
  final dynamic message;
  final bool closed;

  @override
  ValidResult validate(value) =>
      ValidResult(pass: closed == true ? double.parse(value) >= _comparativeValue(comparativeValue) : double.parse(value) > _comparativeValue(comparativeValue), message: _message(message));
}

/// 最大值验证
class Max extends Rule {
  Max({this.comparativeValue, this.message, this.closed = true});

  
  final dynamic comparativeValue;
  final dynamic message;
  final bool closed;

  @override
  ValidResult validate(value) =>
      ValidResult(pass: closed == true ? double.parse(value) <= _comparativeValue(comparativeValue) : double.parse(value) < _comparativeValue(comparativeValue), message: _message(message));
}

///    验证器
///
///    Validator validator = Validator(rules: {
///      "name": [Required(message: "name参数不能为空")],
///      "password":[Required(message: "password参数不能为空")]
///    });
///
///   validator.validate("name",123)
///
class Validator {
  Validator({this.rules, this.options = const {}});

  final Map<String, List<Rule>> rules;
  final Map<String, dynamic> options;
  
  addRules(Map<String,List<Rule>> rules)=>rules.addAll(rules);

  ValidResult validate(dynamic key, dynamic value) {
    ValidResult validResult;
    if (!rules.containsKey(key)) throw "The key [$key] not exist in rules";
    List<Rule> ruleList = rules[key];
    for (int i = 0; i < ruleList.length; i++) {
      validResult = ruleList.elementAt(i).validate(value);
      if (!validResult.pass) return validResult;
    }
    return validResult;
  }
}
