import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:template_expressions/expressions.dart';

/// Processor that integrates https://pub.dev/packages/expressions library
/// syntax with [JsonWidgetRegistry] variables and functions.  All expressions
/// should be placed in ${.*} syntax.
///
/// A few examples:
/// * `${var1}` - find the value of 'var1' variable inside of [JsonWidgetRegistry]
/// and return ['var1'] it's name as the listen variable names.
/// * `${print('var1 value is: ' + var1)}` - executes 'print' function from
/// [JsonWidgetRegistry]. As the arg for that function it takes contatenation
/// of 'var1 value is: ' string and the value of 'var1'.
///
/// Listen variable names for such a expression is ['var1'].
class ExpressionArgProcessor implements ArgProcessor {
  final _matchRegexp = RegExp(r'^\${\s*(.*?)\s*}$');
  @override
  bool support(dynamic arg) {
    return arg != null && arg is String && _matchRegexp.hasMatch(arg);
  }

  @override
  ProcessedArg process(
    JsonWidgetRegistry registry,
    dynamic arg,
    Set<String>? jsonWidgetListenVariables,
  ) {
    final calculateListenVariables =
        jsonWidgetListenVariables == null || jsonWidgetListenVariables.isEmpty;
    var resultListenVariables = jsonWidgetListenVariables ?? <String>{};

    final regexpMatch = _matchRegexp.firstMatch(arg.toString())!;
    final expression = Expression.tryParse(regexpMatch.group(1)!);
    if (expression != null) {
      final evaluator = ArgsExpressionEvaluator(
        registry,
        calculateListenVariables,
      );
      arg = evaluator.evaluate(expression);
      if (calculateListenVariables) {
        resultListenVariables = evaluator.jsonWidgetListenVariables;
      }
    }
    return ProcessedArg(
      jsonWidgetListenVariables: resultListenVariables,
      value: arg,
    );
  }
}

/// Modification added to [ExpressionEvaluator] which integrates
/// [JsonWidgetRegistry] variables and functions.
class ArgsExpressionEvaluator extends ExpressionEvaluator {
  ArgsExpressionEvaluator(this.registry, this.calculateListenVariables);

  final bool calculateListenVariables;
  final JsonWidgetRegistry registry;

  final Set<String> _jsonWidgetListenVariables = {};

  Set<String> get jsonWidgetListenVariables => _jsonWidgetListenVariables;

  dynamic evaluate(Expression expression) => super.eval(expression, {});

  @override
  dynamic evalVariable(Variable variable, Map<String, dynamic> context) {
    final variableName = variable.identifier.name;
    return super.evalVariable(
      variable,
      _updateContextIfNeeded(context, variableName),
    );
  }

  @override
  dynamic evalMemberExpression(
    MemberExpression expression,
    Map<String, dynamic> context, {
    bool nullable = false,
  }) {
    final variableName = '${expression.object}.${expression.property}';
    return evalVariable(Variable(Identifier(variableName)), context);
  }

  @override
  dynamic evalIndexExpression(
    IndexExpression expression,
    Map<String, dynamic> context, {
    bool nullable = false,
  }) {
    dynamic objectIndexValue;
    final objectValue = eval(expression.object, context);
    if (objectValue != null) {
      objectIndexValue =
          eval(expression.object, context)[eval(expression.index, context)];
    }
    return objectIndexValue;
  }

  @override
  dynamic evalCallExpression(
    CallExpression expression,
    Map<String, dynamic> context,
  ) {
    dynamic result;
    final callee = eval(expression.callee, context);
    final arguments =
        expression.arguments.map((e) => eval(e, context)).toList();
    if (callee is JsonWidgetFunction) {
      result = Function.apply(callee, null, {
        const Symbol('args'): arguments,
        const Symbol('registry'): registry,
      });
    } else {
      result = Function.apply(callee, arguments);
    }
    return result;
  }

  Map<String, dynamic> _updateContextIfNeeded(
    Map<String, dynamic> context,
    String variableName,
  ) {
    if (!context.containsKey(variableName)) {
      final function = registry.getFunction(variableName);
      if (function == null) {
        if (calculateListenVariables) {
          _jsonWidgetListenVariables.add(variableName);
        }
        context[variableName] = registry.getValue(variableName);
      } else {
        context[variableName] = function;
      }
    }
    return context;
  }
}
