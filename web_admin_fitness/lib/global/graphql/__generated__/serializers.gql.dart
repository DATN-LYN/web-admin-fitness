// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' show StandardJsonPlugin;
import 'package:ferry_exec/ferry_exec.dart';
import 'package:gql_code_builder/src/serializers/operation_serializer.dart'
    show OperationSerializer;
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart'
    show
        GFILTER_OPERATOR,
        GFilterDto,
        GLoginInputDto,
        GQueryFilterDto,
        GRegisterInputDto,
        GUpsertCategoryInputDto,
        GUpsertExerciseInputDto,
        GUpsertInboxInputDto,
        GUpsertProgramInputDto;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_logout.data.gql.dart'
    show GLogoutData, GLogoutData_logout;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_logout.req.gql.dart'
    show GLogoutReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_logout.var.gql.dart'
    show GLogoutVars;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.data.gql.dart'
    show GRegisterData, GRegisterData_register;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.req.gql.dart'
    show GRegisterReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.var.gql.dart'
    show GRegisterVars;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.data.gql.dart'
    show GLoginData, GLoginData_login, GLoginData_login_user;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.req.gql.dart'
    show GLoginReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.var.gql.dart'
    show GLoginVars;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_refresh_token.data.gql.dart'
    show GRefreshTokenData, GRefreshTokenData_refreshToken;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_refresh_token.req.gql.dart'
    show GRefreshTokenReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_refresh_token.var.gql.dart'
    show GRefreshTokenVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart'
    show GCategoryData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.req.gql.dart'
    show GCategoryReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.var.gql.dart'
    show GCategoryVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart'
    show GExerciseData, GExerciseData_program;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.req.gql.dart'
    show GExerciseReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.var.gql.dart'
    show GExerciseVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart'
    show GInboxData, GInboxData_user;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.req.gql.dart'
    show GInboxReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.var.gql.dart'
    show GInboxVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/meta_fragment.data.gql.dart'
    show GMetaData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/meta_fragment.req.gql.dart'
    show GMetaReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/meta_fragment.var.gql.dart'
    show GMetaVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart'
    show GProgramData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.req.gql.dart'
    show GProgramReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.var.gql.dart'
    show GProgramVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.data.gql.dart'
    show
        GGetCategoriesData,
        GGetCategoriesData_getCategories,
        GGetCategoriesData_getCategories_items,
        GGetCategoriesData_getCategories_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart'
    show GGetCategoriesReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.var.gql.dart'
    show GGetCategoriesVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.data.gql.dart'
    show GGetCategoryData, GGetCategoryData_getCategory;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.req.gql.dart'
    show GGetCategoryReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.var.gql.dart'
    show GGetCategoryVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercise.data.gql.dart'
    show GGetExerciseData, GGetExerciseData_getExercise;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercise.req.gql.dart'
    show GGetExerciseReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercise.var.gql.dart'
    show GGetExerciseVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.data.gql.dart'
    show
        GGetExercisesData,
        GGetExercisesData_getExercises,
        GGetExercisesData_getExercises_items,
        GGetExercisesData_getExercises_items_program,
        GGetExercisesData_getExercises_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart'
    show GGetExercisesReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.var.gql.dart'
    show GGetExercisesVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inbox.data.gql.dart'
    show GGetInboxData, GGetInboxData_getInbox, GGetInboxData_getInbox_user;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inbox.req.gql.dart'
    show GGetInboxReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inbox.var.gql.dart'
    show GGetInboxVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.data.gql.dart'
    show
        GGetInboxesData,
        GGetInboxesData_getInboxes,
        GGetInboxesData_getInboxes_items,
        GGetInboxesData_getInboxes_items_user,
        GGetInboxesData_getInboxes_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.req.gql.dart'
    show GGetInboxesReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.var.gql.dart'
    show GGetInboxesVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.data.gql.dart'
    show GGetProgramData, GGetProgramData_getProgram;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.req.gql.dart'
    show GGetProgramReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.var.gql.dart'
    show GGetProgramVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.data.gql.dart'
    show
        GGetProgramsData,
        GGetProgramsData_getPrograms,
        GGetProgramsData_getPrograms_items,
        GGetProgramsData_getPrograms_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart'
    show GGetProgramsReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.var.gql.dart'
    show GGetProgramsVars;
import 'package:web_admin_fitness/global/utils/date_serializer.dart'
    show DateSerializer;

part 'serializers.gql.g.dart';

final SerializersBuilder _serializersBuilder = _$serializers.toBuilder()
  ..add(OperationSerializer())
  ..add(DateSerializer())
  ..addPlugin(StandardJsonPlugin());
@SerializersFor([
  GCategoryData,
  GCategoryReq,
  GCategoryVars,
  GExerciseData,
  GExerciseData_program,
  GExerciseReq,
  GExerciseVars,
  GFILTER_OPERATOR,
  GFilterDto,
  GGetCategoriesData,
  GGetCategoriesData_getCategories,
  GGetCategoriesData_getCategories_items,
  GGetCategoriesData_getCategories_meta,
  GGetCategoriesReq,
  GGetCategoriesVars,
  GGetCategoryData,
  GGetCategoryData_getCategory,
  GGetCategoryReq,
  GGetCategoryVars,
  GGetExerciseData,
  GGetExerciseData_getExercise,
  GGetExerciseReq,
  GGetExerciseVars,
  GGetExercisesData,
  GGetExercisesData_getExercises,
  GGetExercisesData_getExercises_items,
  GGetExercisesData_getExercises_items_program,
  GGetExercisesData_getExercises_meta,
  GGetExercisesReq,
  GGetExercisesVars,
  GGetInboxData,
  GGetInboxData_getInbox,
  GGetInboxData_getInbox_user,
  GGetInboxReq,
  GGetInboxVars,
  GGetInboxesData,
  GGetInboxesData_getInboxes,
  GGetInboxesData_getInboxes_items,
  GGetInboxesData_getInboxes_items_user,
  GGetInboxesData_getInboxes_meta,
  GGetInboxesReq,
  GGetInboxesVars,
  GGetProgramData,
  GGetProgramData_getProgram,
  GGetProgramReq,
  GGetProgramVars,
  GGetProgramsData,
  GGetProgramsData_getPrograms,
  GGetProgramsData_getPrograms_items,
  GGetProgramsData_getPrograms_meta,
  GGetProgramsReq,
  GGetProgramsVars,
  GInboxData,
  GInboxData_user,
  GInboxReq,
  GInboxVars,
  GLoginData,
  GLoginData_login,
  GLoginData_login_user,
  GLoginInputDto,
  GLoginReq,
  GLoginVars,
  GLogoutData,
  GLogoutData_logout,
  GLogoutReq,
  GLogoutVars,
  GMetaData,
  GMetaReq,
  GMetaVars,
  GProgramData,
  GProgramReq,
  GProgramVars,
  GQueryFilterDto,
  GRefreshTokenData,
  GRefreshTokenData_refreshToken,
  GRefreshTokenReq,
  GRefreshTokenVars,
  GRegisterData,
  GRegisterData_register,
  GRegisterInputDto,
  GRegisterReq,
  GRegisterVars,
  GUpsertCategoryInputDto,
  GUpsertExerciseInputDto,
  GUpsertInboxInputDto,
  GUpsertProgramInputDto,
])
final Serializers serializers = _serializersBuilder.build();
