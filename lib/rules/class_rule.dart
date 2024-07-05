import 'package:analyzer/error/listener.dart';
import 'package:change_case/change_case.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sugi_lint/utils/ext/resolver_ext.dart';
import 'package:sugi_lint/utils/ext/string_ext.dart';

const _title = 'class_name';
const _body = 'Class name is valid';
const _bodyTheSame = 'Class name not the same with file';
const _bodyAbstract = 'Add a suffix to the file name';
const _bodyMixin = 'Add as a suffix';
const _bodyPage =
    'Give the screen a name appropriate to its function and add a `_page` suffix';

LintCode _code([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_body$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E5%9F%BA%E6%9C%AC%E3%83%AB%E3%83%BC%E3%83%AB',
    );

LintCode _codeFileSameClass([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_bodyTheSame$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E3%82%AF%E3%83%A9%E3%82%B9',
    );
LintCode _codeAbstract([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_bodyAbstract$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E6%8A%BD%E8%B1%A1%E3%82%AF%E3%83%A9%E3%82%B9',
    );
LintCode _codeMixin([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_bodyMixin$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E6%8A%BD%E8%B1%A1%E3%82%AF%E3%83%A9%E3%82%B9',
    );
LintCode _codePage([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: '$_bodyPage$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E7%94%BB%E9%9D%A2',
    );
LintCode _codeDialog([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage:
          'Dialogs and bottom sheets are classified as suffixes$subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E7%94%BB%E9%9D%A2',
    );
LintCode _codeRepository([String? subCode = '']) => LintCode(
      name: _title,
      problemMessage: 'Add as a suffix $subCode',
      url:
          'https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E3%83%AA%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA',
    );

class ClassRuleCode extends DartLintRule {
  ClassRuleCode() : super(code: _code());

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final className = node.name.lexeme;

      if (!(className.specChar.toPascalCase() == className.specChar)) {
        reporter.reportErrorForNode(
          _code(
            '`${className.specChar}`'
            ' -> `${className.specChar.toPascalCase()}`',
          ),
          node,
        );
      }

      final fileName =
          resolver.partName.split('/').last.replaceFirst('.dart', '');
      final privateClass = className.startsWith('_');
      if (!privateClass &&
          !fileName.contains('provider') &&
          fileName.toSnakeCase() != className.specChar.toSnakeCase()) {
        reporter.reportErrorForNode(
          _codeFileSameClass(
            '`${className.specChar}`'
            ' -> `${fileName.toPascalCase()}`',
          ),
          node,
        );
      }

      if (fileName.endsWith('widget')) {
        reporter.reportErrorForNode(
          _codeFileSameClass(
            '`There is no need to add a suffix to the implementation class`'
            ' -> `${fileName.toPascalCase()}`',
          ),
          node,
        );
      }

      if (className.endsWith('widget')) {
        reporter.reportErrorForNode(
          _code(
            '`There is no need to add a suffix to the implementation class`'
            ' -> `${className.toPascalCase()}`',
          ),
          node,
        );
      }

      if ((node.declaredElement?.isAbstract ?? false) &&
          !fileName.endsWith('_abstract')) {
        reporter.reportErrorForNode(
          _codeAbstract(
            '`$fileName`'
            ' -> `${fileName}_abstract`',
          ),
          node,
        );
      }

      if ((node.declaredElement?.isMixinClass ?? false) &&
          !fileName.endsWith('_mixin')) {
        reporter.reportErrorForNode(
          _codeMixin(
            '`$fileName`'
            ' -> `${fileName}_mixin`',
          ),
          node,
        );
      }

      if (className.endsWith('Page') && !fileName.endsWith('_page')) {
        reporter.reportErrorForNode(
          _codePage(
            '`$fileName`'
            ' -> `${fileName}_page`',
          ),
          node,
        );
      }
      if (className.endsWith('Dialog') && !fileName.endsWith('_dialog')) {
        reporter.reportErrorForNode(
          _codeDialog(
            '`$fileName`'
            ' -> `${fileName}_dialog`',
          ),
          node,
        );
      }
      if (className.endsWith('BottomSheet') &&
          !fileName.endsWith('_bottom_sheet')) {
        reporter.reportErrorForNode(
          _codeDialog(
            '`$fileName`'
            ' -> `${fileName}_bottom_sheet`',
          ),
          node,
        );
      }
      if (className.endsWith('Repository') &&
          !fileName.endsWith('_repository')) {
        reporter.reportErrorForNode(
          _codeRepository(
            '`$fileName`'
            ' -> `${fileName}_repository`',
          ),
          node,
        );
      }
      if (fileName.endsWith('_repository') &&
          !className.endsWith('Repository')) {
        reporter.reportErrorForNode(
          _codeRepository(
            '`$className`'
            ' -> `${className}Repository`',
          ),
          node,
        );
      }

      if (!fileName.contains('provider') &&
          !className.startsWith('_') &&
          fileName.toSnakeCase() != className.toSnakeCase()) {
        reporter.reportErrorForNode(
          _code(': Single class in file'),
          node,
        );
      }
    });

    context.registry.addClassTypeAlias((node) {
      final className = node.name.lexeme;

      if (!(className.specChar.toPascalCase() == className.specChar)) {
        reporter.reportErrorForNode(
            LintCode(
              name: _title,
              problemMessage: '$_body `${className.specChar}`'
                  ' -> `${className.specChar.toPascalCase()}`',
            ),
            node);
      }
    });
  }
}
