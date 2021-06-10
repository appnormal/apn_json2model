import 'package:json_to_model/core/json_model.dart';

typedef JsonModelConverter = String Function(JsonModel data, [bool isNested]);

String modelFromJsonModel(JsonModel data, {bool isNested = false}) => _defaultJsonTemplate(
      isNested: isNested,
      constructor: data.constructor,
      imports: data.imports,
      fileName: data.fileName,
      className: data.className,
      extendsClass: data.extendsClass,
      mixinClass: data.mixinClass,
      equalsDeclarations: data.equalsDeclarations,
      hashDeclarations: data.hashDeclarations,
      declaration: data.declaration,
      copyWith: data.copyWith,
      cloneFunction: data.cloneFunction,
      jsonFunctions: data.jsonFunctions,
      enums: data.enums,
      enumConverters: data.enumConverters,
      nestedClasses: data.nestedClasses,
    );

String _defaultJsonTemplate({
  required bool isNested,
  required String constructor,
  required String imports,
  required String fileName,
  required String className,
  required String mixinClass,
  required String equalsDeclarations,
  required String hashDeclarations,
  required String declaration,
  required String copyWith,
  required String cloneFunction,
  required String jsonFunctions,
  String? enums,
  String? enumConverters,
  String? nestedClasses,
  String? extendsClass,
}) {
  var template = '';

  if (!isNested) {
    template += '''
import 'package:flutter/foundation.dart';
$imports

''';
  }

  template += '''
@immutable
class $className${extendsClass != null ? ' extends $extendsClass ' : ''}${mixinClass.isNotEmpty ? ' with $mixinClass' : ''} {

$constructor

  $declaration

$jsonFunctions

  $cloneFunction

''';

  if ((enumConverters?.length ?? 0) > 0) {
    template += '\n$enumConverters';
  }

  template += '''

$copyWith

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is $className && $equalsDeclarations;

  @override
  int get hashCode => $hashDeclarations;
''';

  template += '}\n';

  if ((enums?.length ?? 0) > 0) {
    template += '\n$enums\n';
  }

  if ((nestedClasses?.length ?? 0) > 0) {
    template += '\n$nestedClasses';
  }

  return template;
}
