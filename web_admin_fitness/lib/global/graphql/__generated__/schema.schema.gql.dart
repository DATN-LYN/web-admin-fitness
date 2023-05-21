// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/serializers.gql.dart'
    as _i1;

part 'schema.schema.gql.g.dart';

class GFILTER_OPERATOR extends EnumClass {
  const GFILTER_OPERATOR._(String name) : super(name);

  static const GFILTER_OPERATOR eq = _$gFILTEROPERATOReq;

  static const GFILTER_OPERATOR like = _$gFILTEROPERATORlike;

  @BuiltValueEnumConst(wireName: 'in')
  static const GFILTER_OPERATOR Gin = _$gFILTEROPERATORGin;

  static const GFILTER_OPERATOR lt = _$gFILTEROPERATORlt;

  static const GFILTER_OPERATOR gt = _$gFILTEROPERATORgt;

  static Serializer<GFILTER_OPERATOR> get serializer =>
      _$gFILTEROPERATORSerializer;
  static BuiltSet<GFILTER_OPERATOR> get values => _$gFILTEROPERATORValues;
  static GFILTER_OPERATOR valueOf(String name) =>
      _$gFILTEROPERATORValueOf(name);
}

abstract class GFilterDto implements Built<GFilterDto, GFilterDtoBuilder> {
  GFilterDto._();

  factory GFilterDto([Function(GFilterDtoBuilder b) updates]) = _$GFilterDto;

  String? get field;
  String? get data;
  GFILTER_OPERATOR? get operator;
  static Serializer<GFilterDto> get serializer => _$gFilterDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GFilterDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GFilterDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GFilterDto.serializer,
        json,
      );
}

abstract class GLoginInputDto
    implements Built<GLoginInputDto, GLoginInputDtoBuilder> {
  GLoginInputDto._();

  factory GLoginInputDto([Function(GLoginInputDtoBuilder b) updates]) =
      _$GLoginInputDto;

  String? get accessToken;
  String? get expiresIn;
  String? get token;
  String? get email;
  String? get password;
  static Serializer<GLoginInputDto> get serializer =>
      _$gLoginInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GLoginInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GLoginInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GLoginInputDto.serializer,
        json,
      );
}

abstract class GQueryFilterDto
    implements Built<GQueryFilterDto, GQueryFilterDtoBuilder> {
  GQueryFilterDto._();

  factory GQueryFilterDto([Function(GQueryFilterDtoBuilder b) updates]) =
      _$GQueryFilterDto;

  double? get limit;
  double? get page;
  String? get orderBy;
  BuiltList<GFilterDto>? get filters;
  static Serializer<GQueryFilterDto> get serializer =>
      _$gQueryFilterDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GQueryFilterDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GQueryFilterDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GQueryFilterDto.serializer,
        json,
      );
}

abstract class GRegisterInputDto
    implements Built<GRegisterInputDto, GRegisterInputDtoBuilder> {
  GRegisterInputDto._();

  factory GRegisterInputDto([Function(GRegisterInputDtoBuilder b) updates]) =
      _$GRegisterInputDto;

  String get email;
  String get password;
  String? get avatar;
  double get age;
  String get fullName;
  static Serializer<GRegisterInputDto> get serializer =>
      _$gRegisterInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GRegisterInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GRegisterInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GRegisterInputDto.serializer,
        json,
      );
}

abstract class GUpsertCategoryInputDto
    implements Built<GUpsertCategoryInputDto, GUpsertCategoryInputDtoBuilder> {
  GUpsertCategoryInputDto._();

  factory GUpsertCategoryInputDto(
          [Function(GUpsertCategoryInputDtoBuilder b) updates]) =
      _$GUpsertCategoryInputDto;

  String? get id;
  String get name;
  String get imgUrl;
  static Serializer<GUpsertCategoryInputDto> get serializer =>
      _$gUpsertCategoryInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertCategoryInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertCategoryInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertCategoryInputDto.serializer,
        json,
      );
}

abstract class GUpsertExerciseInputDto
    implements Built<GUpsertExerciseInputDto, GUpsertExerciseInputDtoBuilder> {
  GUpsertExerciseInputDto._();

  factory GUpsertExerciseInputDto(
          [Function(GUpsertExerciseInputDtoBuilder b) updates]) =
      _$GUpsertExerciseInputDto;

  String? get id;
  String get name;
  String get imgUrl;
  double get duration;
  String get videoUrl;
  double get calo;
  String get programId;
  static Serializer<GUpsertExerciseInputDto> get serializer =>
      _$gUpsertExerciseInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertExerciseInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertExerciseInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertExerciseInputDto.serializer,
        json,
      );
}

abstract class GUpsertInboxInputDto
    implements Built<GUpsertInboxInputDto, GUpsertInboxInputDtoBuilder> {
  GUpsertInboxInputDto._();

  factory GUpsertInboxInputDto(
          [Function(GUpsertInboxInputDtoBuilder b) updates]) =
      _$GUpsertInboxInputDto;

  String? get id;
  String get message;
  String get userId;
  bool get isSender;
  static Serializer<GUpsertInboxInputDto> get serializer =>
      _$gUpsertInboxInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertInboxInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertInboxInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertInboxInputDto.serializer,
        json,
      );
}

abstract class GUpsertProgramInputDto
    implements Built<GUpsertProgramInputDto, GUpsertProgramInputDtoBuilder> {
  GUpsertProgramInputDto._();

  factory GUpsertProgramInputDto(
          [Function(GUpsertProgramInputDtoBuilder b) updates]) =
      _$GUpsertProgramInputDto;

  String? get id;
  String get name;
  double get level;
  double get bodyPart;
  String get description;
  String get imgUrl;
  String get categoryId;
  double get view;
  static Serializer<GUpsertProgramInputDto> get serializer =>
      _$gUpsertProgramInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertProgramInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertProgramInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertProgramInputDto.serializer,
        json,
      );
}

abstract class GUpsertUserExerciseInputDto
    implements
        Built<GUpsertUserExerciseInputDto, GUpsertUserExerciseInputDtoBuilder> {
  GUpsertUserExerciseInputDto._();

  factory GUpsertUserExerciseInputDto(
          [Function(GUpsertUserExerciseInputDtoBuilder b) updates]) =
      _$GUpsertUserExerciseInputDto;

  String? get id;
  String get userId;
  String get exerciseId;
  static Serializer<GUpsertUserExerciseInputDto> get serializer =>
      _$gUpsertUserExerciseInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertUserExerciseInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertUserExerciseInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertUserExerciseInputDto.serializer,
        json,
      );
}

abstract class GUpsertUserInputDto
    implements Built<GUpsertUserInputDto, GUpsertUserInputDtoBuilder> {
  GUpsertUserInputDto._();

  factory GUpsertUserInputDto(
      [Function(GUpsertUserInputDtoBuilder b) updates]) = _$GUpsertUserInputDto;

  String? get id;
  String get fullName;
  String get avatar;
  String get email;
  double get age;
  static Serializer<GUpsertUserInputDto> get serializer =>
      _$gUpsertUserInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertUserInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertUserInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertUserInputDto.serializer,
        json,
      );
}

abstract class GUpsertUserProgramInputDto
    implements
        Built<GUpsertUserProgramInputDto, GUpsertUserProgramInputDtoBuilder> {
  GUpsertUserProgramInputDto._();

  factory GUpsertUserProgramInputDto(
          [Function(GUpsertUserProgramInputDtoBuilder b) updates]) =
      _$GUpsertUserProgramInputDto;

  String? get id;
  String get userId;
  String get programId;
  static Serializer<GUpsertUserProgramInputDto> get serializer =>
      _$gUpsertUserProgramInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertUserProgramInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertUserProgramInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertUserProgramInputDto.serializer,
        json,
      );
}

abstract class GUpsertUserStatisticsInputDto
    implements
        Built<GUpsertUserStatisticsInputDto,
            GUpsertUserStatisticsInputDtoBuilder> {
  GUpsertUserStatisticsInputDto._();

  factory GUpsertUserStatisticsInputDto(
          [Function(GUpsertUserStatisticsInputDtoBuilder b) updates]) =
      _$GUpsertUserStatisticsInputDto;

  String? get id;
  String get userId;
  double get programCount;
  double get caloCount;
  double get durationCount;
  static Serializer<GUpsertUserStatisticsInputDto> get serializer =>
      _$gUpsertUserStatisticsInputDtoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GUpsertUserStatisticsInputDto.serializer,
        this,
      ) as Map<String, dynamic>);
  static GUpsertUserStatisticsInputDto? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GUpsertUserStatisticsInputDto.serializer,
        json,
      );
}

const Map<String, Set<String>> possibleTypesMap = {};
