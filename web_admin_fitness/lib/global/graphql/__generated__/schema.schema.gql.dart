// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/serializers.gql.dart'
    as _i1;

part 'schema.schema.gql.g.dart';

abstract class GCreateCategoryInput
    implements Built<GCreateCategoryInput, GCreateCategoryInputBuilder> {
  GCreateCategoryInput._();

  factory GCreateCategoryInput(
          [Function(GCreateCategoryInputBuilder b) updates]) =
      _$GCreateCategoryInput;

  String get name;
  String get imgUrl;
  static Serializer<GCreateCategoryInput> get serializer =>
      _$gCreateCategoryInputSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GCreateCategoryInput.serializer,
        this,
      ) as Map<String, dynamic>);
  static GCreateCategoryInput? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GCreateCategoryInput.serializer,
        json,
      );
}

abstract class GCreateProgramInput
    implements Built<GCreateProgramInput, GCreateProgramInputBuilder> {
  GCreateProgramInput._();

  factory GCreateProgramInput(
      [Function(GCreateProgramInputBuilder b) updates]) = _$GCreateProgramInput;

  String get name;
  String get imgUrl;
  String get videoUrl;
  String get duration;
  double get setNum;
  String get bodyPart;
  double get level;
  String get description;
  static Serializer<GCreateProgramInput> get serializer =>
      _$gCreateProgramInputSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GCreateProgramInput.serializer,
        this,
      ) as Map<String, dynamic>);
  static GCreateProgramInput? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GCreateProgramInput.serializer,
        json,
      );
}

abstract class GLoginInput implements Built<GLoginInput, GLoginInputBuilder> {
  GLoginInput._();

  factory GLoginInput([Function(GLoginInputBuilder b) updates]) = _$GLoginInput;

  String get email;
  String get password;
  static Serializer<GLoginInput> get serializer => _$gLoginInputSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GLoginInput.serializer,
        this,
      ) as Map<String, dynamic>);
  static GLoginInput? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GLoginInput.serializer,
        json,
      );
}

abstract class GRegisterInput
    implements Built<GRegisterInput, GRegisterInputBuilder> {
  GRegisterInput._();

  factory GRegisterInput([Function(GRegisterInputBuilder b) updates]) =
      _$GRegisterInput;

  String get fullName;
  String get email;
  String get password;
  static Serializer<GRegisterInput> get serializer =>
      _$gRegisterInputSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GRegisterInput.serializer,
        this,
      ) as Map<String, dynamic>);
  static GRegisterInput? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GRegisterInput.serializer,
        json,
      );
}

const Map<String, Set<String>> possibleTypesMap = {
  'IMutationResponse': {
    'CategoryMutationResponse',
    'ProgramMutationResponse',
    'UserMutationResponse',
  }
};
