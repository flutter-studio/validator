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
typedef NumberCallback = double Function();
typedef IntCallback = int Function();

///必填验证
class Required extends Rule {
  Required({this.message});

  Required.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(dynamic value) => ValidResult(pass: value != "" && value != null, message: message);
}

/// 邮箱验证
class Email extends Rule {
  Email({this.message});

  Email.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(
      pass: RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
          .hasMatch(value),
      message: message);
}

/// 数字验证,可包含小数点
class Number extends Rule {
  Number({this.message});

  Number.func({StringCallback message}) : this(message: message());
  final String message;

  @override
  ValidResult validate(value) => ValidResult(pass: RegExp(r"^(?:-?\d+|-?\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$").hasMatch(value), message: message);
}

/// 数字验证， 不带小数点
class Digit extends Rule {
  Digit({this.message});

  Digit.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(pass: RegExp(r"^\d+$").hasMatch(value), message: message);
}

/// qq验证
class QQ extends Rule {
  QQ({this.message});

  QQ.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(pass: RegExp(r"^[1-9][0-9]{4,14}$").hasMatch(value), message: message);
}

/// 手机号验证
class Mobile extends Rule {
  Mobile({this.message});

  Mobile.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(pass: RegExp(r"^((1)+\d{10})$").hasMatch(value) && value.length == 11, message: message);
}

/// 电话号码验证
class Phone extends Rule {
  Phone({this.message});

  Phone.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(
      pass:
          RegExp(r"^((\d{10,11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)$")
              .hasMatch(value),
      message: message);
}

/// 非法字符验证
class IllegalChar extends Rule {
  IllegalChar({this.message});

  IllegalChar.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(pass: RegExp(r"""/[&\\<>'"]""").hasMatch(value) && value.length == 11, message: message);
}

/// 邮编验证
class PostCode extends Rule {
  PostCode({this.message});

  PostCode.func({StringCallback message}) : this(message: message());

  final String message;

  @override
  ValidResult validate(value) => ValidResult(pass: RegExp(r"^[0-9]{6}$").hasMatch(value) && value.length == 11, message: message);
}

/// 中文和字母
class ChineseLetter extends Rule {
  ChineseLetter({this.message});

  ChineseLetter.func({StringCallback message}) : this(message: message());
  final String message;

  @override
  ValidResult validate(String value) => ValidResult(pass: RegExp(r"^([\u4e00-\u9fa5]|[a-zA-Z])*$").hasMatch(value), message: message);
}

/// 数字字符串验证
class NumberLetter extends Rule{
  NumberLetter({this.message});
  
  NumberLetter.func({StringCallback message}):this(message: message());
  final String message;
  
  @override
  ValidResult validate(String value)=>ValidResult(pass: RegExp(r"^([0-9]|[a-zA-Z])*$").hasMatch(value) ,message: message);
  
}

/// 最小长度验证
class MinLength extends Rule {
  MinLength({this.comparativeValue, this.message, this.closed = true});

  MinLength.func({IntCallback comparativeValue, StringCallback message, bool closed})
      : this(comparativeValue: comparativeValue(), message: message(), closed: closed);

  final int comparativeValue;
  final String message;
  final bool closed;

  @override
  ValidResult validate(value) => ValidResult(pass: closed == true ? value.length >= comparativeValue : value.length > comparativeValue, message: message);
}

/// 最大长度验证
class MaxLength extends Rule {
  MaxLength({this.comparativeValue, this.message, this.closed = true});

  MaxLength.func({IntCallback comparativeValue, StringCallback message, bool closed})
      : this(comparativeValue: comparativeValue(), message: message(), closed: closed);

  final int comparativeValue;
  final String message;
  final bool closed;

  @override
  ValidResult validate(value) => ValidResult(pass: closed == true ? value.length <= comparativeValue : value.length < comparativeValue, message: message);
}

class Section {
  Section({this.value, this.closed});

  Section.func({NumberCallback value, bool closed}) : this(value: value(), closed: closed);

  final double value;
  final bool closed;
}

/// 范围长度验证
class RangeLength extends Rule {
  RangeLength({this.min, this.max, this.message});

  RangeLength.func({Section min, Section max, StringCallback message}) : this(min: min, max: max, message: message());

  final Section min;
  final String message;
  final Section max;

  @override
  ValidResult validate(String value) {
    bool minBoolValue;
    bool maxBoolValue;
    if (min.closed) {
      minBoolValue = value.length >= min.value;
    } else {
      minBoolValue = value.length > min.value;
    }
    if (max.closed) {
      maxBoolValue = value.length <= max.value;
    } else {
      maxBoolValue = value.length < max.value;
    }
    return ValidResult(pass: minBoolValue == true && maxBoolValue == true, message: message);
  }
}

/// 范围验证
class Range extends Rule {
  Range({this.min, this.max, this.message});

  Range.func({Section min, Section max, StringCallback message}) : this(min: min, max: max, message: message());

  final Section min;
  final String message;
  final Section max;

  @override
  ValidResult validate(String value) {
    bool minBoolValue;
    bool maxBoolValue;
    if (min.closed) {
      minBoolValue = int.parse(value) >= min.value;
    } else {
      minBoolValue = int.parse(value) > min.value;
    }
    if (max.closed) {
      maxBoolValue = int.parse(value) <= max.value;
    } else {
      maxBoolValue = int.parse(value) < max.value;
    }
    return ValidResult(pass: minBoolValue == true && maxBoolValue == true, message: message);
  }
}

/// 最小值验证
class Min extends Rule {
  Min({this.comparativeValue, this.message, this.closed = true});

  Min.func({NumberCallback comparativeValue, StringCallback message, bool closed})
      : this(comparativeValue: comparativeValue(), message: message(), closed: closed);

  final double comparativeValue;
  final String message;
  final bool closed;

  @override
  ValidResult validate(value) =>
      ValidResult(pass: closed == true ? double.parse(value) >= comparativeValue : double.parse(value) > comparativeValue, message: message);
}

/// 最大值验证
class Max extends Rule {
  Max({this.comparativeValue, this.message, this.closed = true});

  Max.func({NumberCallback comparativeValue, StringCallback message, bool closed})
      : this(comparativeValue: comparativeValue(), message: message(), closed: closed);

  final double comparativeValue;
  final String message;
  final bool closed;

  @override
  ValidResult validate(value) =>
      ValidResult(pass: closed == true ? double.parse(value) <= comparativeValue : double.parse(value) < comparativeValue, message: message);
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
