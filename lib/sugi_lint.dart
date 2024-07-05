// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sugi_lint/rules/variable_rule.dart';

import 'rules/class_rule.dart';
import 'rules/file_rule.dart';
import 'rules/folder_rule.dart';

// TODO(hodoan): miss rule -> Widgets that transition via routers and widgets that are displayed independently using dialogs, bottom sheets, etc. are classified as screens.
// TODO(hodoan): miss rule -> https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E3%81%9D%E3%81%AE%E4%BB%96
// TODO(hodoan): miss rule -> https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%97%E7%AE%A1%E7%90%86
// TODO(hodoan): miss rule -> https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#Widget%E5%87%A6%E7%90%86%E8%A8%98%E8%BF%B0%E9%A0%86%E5%BA%8F
// TODO(hodoan): miss rule -> https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89
// TODO(hodoan): miss rule -> https://sugi-pharmacy.atlassian.net/wiki/spaces/SUGIAPP/pages/212893698/13.2.2#%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88

PluginBase createPlugin() => _CleanArchitectureLint();

class _CleanArchitectureLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        FolderNameCode(),
        FileRuleCode(),
        ClassRuleCode(),
        VariableRuleCode(),
      ];

  @override
  List<Assist> getAssists() => [];
}
