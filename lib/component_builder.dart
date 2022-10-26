import 'package:dart_app_architecture_cli/extensions.dart';
import 'package:dart_app_architecture_cli/model_structure.dart';

/// Gets file path.
String getFilePath({
  required String path,
  required String name,
  required String type,
  bool isBase = false,
}) =>
    '$path/${isBase ? 'base_' : ''}${name.toSnakeCase}_$type.dart';

/// Gets component imports structure.
String getImportsStructure(String name) => '''
    export 'data/${name.toSnakeCase}_model.dart';
    export 'data/repositories/${name.toSnakeCase}_repository.dart';
    export 'domain/base_${name.toSnakeCase}_repository.dart';
    export 'domain/${name.toSnakeCase}_entity.dart';
    export 'domain/${name.toSnakeCase}_service.dart';
    export 'presentation/${name.toSnakeCase}_cubit.dart';
    export 'presentation/${name.toSnakeCase}_widget.dart';
  ''';

/// Gets model structure.
String getModelStructure({
  required String path,
  required String name,
  required List<ModelStructure> modelStructures,
}) =>
    '''
      import '../${name.toSnakeCase}_component.dart';

      /// ${name.toSentenceCase} model.
      class ${name}Model {
        ${_generateConstructor(name: name, modelStructures: modelStructures)}

        ${_generateFromJson(name: name, modelStructures: modelStructures)}

        ${_generateFromEntity(name: name, modelStructures: modelStructures)}

        ${_generateFields(modelStructures)}

        ${_generateToJson(name: name, modelStructures: modelStructures)}
        
        ${_generateToEntity(name: name, modelStructures: modelStructures)}
      }
    ''';

/// Gets base repository structure.
String getBaseRepositoryStructure(String name) => '''
    import 'package:flutter_app_architecture/components.dart';

    /// Base ${name.toSentenceLowerCase} repository.
    abstract class Base${name}Repository extends BaseRepository {}
  ''';

/// Gets repository structure.
String getRepositoryStructure({
  required String name,
  required String postfix,
}) =>
    '''
      import '../../${name.toSnakeCase}_$postfix.dart';

      /// ${name.toSentenceCase} repository.
      class ${name}Repository extends Base${name}Repository {}
    ''';

/// Gets entity structure.
String getEntityStructure({
  required String name,
  required List<ModelStructure> modelStructures,
}) =>
    '''
      import 'package:flutter_app_architecture/components.dart';

      /// ${name.toSentenceCase} entity.
      class ${name}Entity extends BaseEntity {
        ${_generateConstructor(name: name, modelStructures: modelStructures, isModel: false)}

        ${_generateFields(modelStructures)}

        @override
        String toString() => throw UnimplementedError();  
      }
    ''';

/// Gets service structure.
String getServiceStructure({required String name, required String postfix}) =>
    '''
      import 'package:flutter_app_architecture/components.dart';

      import '../${name.toSnakeCase}_$postfix.dart';

      /// ${name.toSentenceCase} service.
      class ${name}Service extends BaseService<${name}Entity> {
        /// Initializes [${name}Service].
        ${name}Service(Base${name}Repository repository) : super(repository);
      }
    ''';

/// Gets cubit structure.
String getCubitStructure({required String name, required String postfix}) => '''
      import 'package:flutter_app_architecture/components.dart';

      import '../${name.toSnakeCase}_$postfix.dart';
      
      /// ${name.toSentenceCase} cubit.
      class ${name}Cubit extends BaseCubit<${name}Entity> {
        /// Initializes [${name}Cubit].
        ${name}Cubit({${name}Service? service})
            : super(
                service: service,
                initialState: BaseState<${name}Entity>(status: BaseStateStatus.initial),
              );
      }
    ''';

/// Gets widget structure.
String getWidgetStructure({required String name, required String postfix}) =>
    '''
      import 'package:flutter/material.dart';

      import 'package:flutter_app_architecture/components.dart';

      import '../${name.toSnakeCase}_$postfix.dart';
      
      /// ${name.toSentenceCase} widget.
      class ${name}Widget extends StatelessWidget {
        @override
        Widget build(BuildContext context) => BaseWidget<${name}Entity, ${name}Cubit>(
              loadingWidgetBuilder:
                  (BuildContext context, BaseState<BaseEntity> state) =>
                      throw UnimplementedError(),
              successWidgetBuilder:
                  (BuildContext context, BaseState<BaseEntity> state) =>
                      throw UnimplementedError(),
              errorWidgetBuilder:
                  (BuildContext context, BaseState<BaseEntity> state) =>
                      throw UnimplementedError(),
            );
        }
      ''';

String _generateConstructor({
  required String name,
  required List<ModelStructure> modelStructures,
  bool isModel = true,
}) {
  modelStructures.sortModelStructures();

  final StringBuffer body = StringBuffer();

  for (final ModelStructure modelStructure in modelStructures) {
    body.write(modelStructure.getConstructorDefinition);
  }

  return '''
    /// Initializes [$name${isModel ? 'Model' : 'Entity'}].
    $name${isModel ? 'Model' : 'Entity'}({$body});
  ''';
}

String _generateFromJson({
  required String name,
  required List<ModelStructure> modelStructures,
}) {
  modelStructures.sortModelStructures();

  final StringBuffer body = StringBuffer();

  for (final ModelStructure modelStructure in modelStructures) {
    body.write(modelStructure.getFromJsonDefinition);
  }

  return '''
    /// Creates an instance from JSON.
    factory ${name}Model.fromJson(Map<String, dynamic> json) =>
      ${name}Model($body);
  ''';
}

String _generateFromEntity({
  required String name,
  required List<ModelStructure> modelStructures,
}) {
  modelStructures.sortModelStructures();

  final StringBuffer body = StringBuffer();

  for (final ModelStructure modelStructure in modelStructures) {
    body.write(modelStructure.getFromEntityDefinition);
  }

  return '''
    /// Creates an instance from [${name}Entity].
    factory ${name}Model.fromEntity(${name}Entity entity) =>
      ${name}Model($body);
  ''';
}

String _generateToJson({
  required String name,
  required List<ModelStructure> modelStructures,
}) {
  modelStructures.sortModelStructures();

  final StringBuffer body = StringBuffer();

  for (final ModelStructure modelStructure in modelStructures) {
    body.write(modelStructure.getToJsonDefinition);
  }

  return '''
    //// Converts an instance to JSON.
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> json = <String, dynamic>{};

      $body

      return json;
    }
  ''';
}

String _generateToEntity({
  required String name,
  required List<ModelStructure> modelStructures,
}) {
  modelStructures.sortModelStructures();

  final StringBuffer body = StringBuffer();

  for (final ModelStructure modelStructure in modelStructures) {
    body.write(modelStructure.getToEntityDefinition);
  }

  return '''
    /// Converts an instance to [${name}Entity].
    ${name}Entity toEntity() =>
      ${name}Entity($body);
  ''';
}

String _generateFields(List<ModelStructure> modelStructures) {
  modelStructures.sortModelStructures();

  final StringBuffer body = StringBuffer();

  for (final ModelStructure modelStructure in modelStructures) {
    body
      ..write('/// ${modelStructure.name.toSentenceCase}.\n')
      ..write(modelStructure.getFieldDefinition);
  }

  return '$body';
}