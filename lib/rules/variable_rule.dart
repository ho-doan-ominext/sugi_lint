import 'package:analyzer/error/listener.dart';
import 'package:change_case/change_case.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sugi_lint/utils/ext/resolver_ext.dart';
import 'package:sugi_lint/utils/ext/string_ext.dart';

const _title = 'variable_name';
const _body = 'Variable name is valid';
const _bodyBad = 'Variable name is bad';

LintCode _code([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_body$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E5%9F%BA%E6%9C%AC%E3%83%AB%E3%83%BC%E3%83%AB',
    );
LintCode _codeBad([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_bodyBad$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E5%A4%89%E6%95%B0%E3%80%81%E5%AE%9A%E6%95%B0%E3%80%81%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF',
    );

class VariableRuleCode extends DartLintRule {
  VariableRuleCode() : super(code: _code());

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      final name = node.name.lexeme.replaceFirst(RegExp(r'^[_|$]'), '');

      if (!(name.specChar.toCamelCase() == name.specChar)) {
        reporter.reportErrorForNode(
          _code(
            '`${name.specChar}`'
            ' -> `${name.specChar.toCamelCase()}`',
          ),
          node,
        );
      }
      if (name.toSnakeCase().split('_').length < 2) {
        reporter.reportErrorForNode(
          _codeBad('ex: `_data` -> `_cookieData`'),
          node,
        );
      }

      if ((node.declaredElement?.isConst ?? false) &&
          !resolver.partName.split('/').last.contains('constant')) {
        reporter.reportErrorForNode(
          _codeBad(
              '$name -> Manage them together. Write them in the AppConstant file.'),
          node,
        );
      }
    });
    context.registry.addConstructorDeclaration((node) {
      final ps = node.parameters.parameters;
      for (final p in ps) {
        final isFunc = p.declaredElement?.nonSynthetic
            .thisOrAncestorOfType()
            .toString()
            .contains('Function(');

        if ((isFunc ?? false) &&
            p.name?.lexeme != 'key' &&
            (p.name?.lexeme.toSnakeCase().split('_').length ?? 2) < 2) {
          reporter.reportErrorForNode(
            _codeBad(
                ' change `${p.name?.lexeme}` ex: `callback` -> `onCompleted`'),
            p,
          );
        }
      }
    });
  }
}
